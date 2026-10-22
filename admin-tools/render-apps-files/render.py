"""Render the GitOps apps files without Ansible.

Standalone equivalent of:

    ansible-playbook install-gitops.yaml -t rendering-apps-files [-e dsc_cr=<name>]

for machines where ansible-playbook can't run (Windows without WSL). It needs
Python with jinja2 and pyyaml (both installed by "uv sync"), kubectl access to
the cluster holding the dsc, and helm unless --argo-app-version is given.

Templates, defaults and the app list are read from the roles, so template
changes need nothing here. The task logic of the roles below is mirrored in
this file, so changes to them must be reported here (check/check.sh fails
when the output differs from the playbook's):
  - roles/socle-config/tasks/main.yaml   (dsc merge, dsc.yaml and dsc-crd.yaml)
  - roles/gitops/rendering-apps-files/tasks/*.yml
  - roles/combine/tasks/main.yaml

Unlike the playbook, nothing is written to the cluster (the dsc CRD is not
applied) and Vault is not read: rendering only needs the dsc.

Usage (from the socle repo root):
    uv run admin-tools/render-apps-files/render.py --gitops-repo <path to the GitOps repo clone>
"""
from __future__ import annotations

import argparse
import base64
import copy
import json
import os
import re
import shlex
import shutil
import subprocess
import sys
from pathlib import Path

import jinja2
import yaml
from jinja2.filters import do_indent

try:
    from yaml import CSafeDumper as _BaseDumper, CSafeLoader as SafeLoader
except ImportError:
    from yaml import SafeDumper as _BaseDumper, SafeLoader


class SafeDumper(_BaseDumper):
    """Like Ansible's dumper: values shared through YAML anchors are written out in full, without &id001 aliases."""

    def ignore_aliases(self, data):
        return True

REPO_ROOT = Path(__file__).resolve().parents[2]
ROLES = REPO_ROOT / "roles"
SOCLE_CONFIG = ROLES / "socle-config"
RENDERING = ROLES / "gitops" / "rendering-apps-files"

DSC_API_VERSION = "cloud-pi-native.fr/v1alpha"
ARGO_CRD = "applications.argoproj.io"


class RenderError(Exception):
    pass


# --- Ansible-compatible data helpers ----------------------------------------


def merge_hash(x, y, recursive=True, list_merge="replace"):
    """Same semantics as Ansible's merge_hash (keys of y win over keys of x)."""
    if x == {} or x == y:
        return dict(y)
    if y == {}:
        return x
    x = dict(x)
    for key, y_value in y.items():
        if key not in x:
            x[key] = y_value
            continue
        x_value = x[key]
        if isinstance(x_value, dict) and isinstance(y_value, dict):
            x[key] = merge_hash(x_value, y_value, recursive, list_merge) if recursive else y_value
        elif isinstance(x_value, list) and isinstance(y_value, list):
            if list_merge == "replace":
                x[key] = y_value
            elif list_merge == "append":
                x[key] = x_value + y_value
            elif list_merge == "prepend":
                x[key] = y_value + x_value
            elif list_merge == "append_rp":
                x[key] = [z for z in x_value if z not in y_value] + y_value
            elif list_merge == "prepend_rp":
                x[key] = y_value + [z for z in x_value if z not in y_value]
            # "keep": leave x_value
        else:
            x[key] = y_value
    return x


def flatten(items, levels=None, skip_nulls=True):
    result = []
    for element in items:
        if skip_nulls and element in (None, "None", "null"):
            continue
        if isinstance(element, (list, tuple)):
            if levels is None:
                result.extend(flatten(element, skip_nulls=skip_nulls))
            elif levels >= 1:
                result.extend(flatten(element, levels=int(levels) - 1, skip_nulls=skip_nulls))
            else:
                result.append(element)
        else:
            result.append(element)
    return result


def combine(*terms, recursive=False, list_merge="replace"):
    dictionaries = flatten(terms, levels=1)
    if not dictionaries:
        return {}
    if len(dictionaries) == 1:
        return dictionaries[0]
    for d in dictionaries:
        if not isinstance(d, dict):
            raise RenderError(f"combine expects dictionaries, got {type(d).__name__}: {d!r}")
    result = dictionaries[-1]
    for dictionary in reversed(dictionaries[:-1]):
        result = merge_hash(dictionary, result, recursive, list_merge)
    return result


def subelements(obj, key, skip_missing=False):
    elements = list(obj.values()) if isinstance(obj, dict) else list(obj)
    result = []
    for element in elements:
        if key not in element:
            if skip_missing:
                continue
            raise RenderError(f"could not find {key!r} key in iterated item {element!r}")
        for sub in element[key]:
            result.append((element, sub))
    return result


def dict2items(mapping, key_name="key", value_name="value"):
    return [{key_name: k, value_name: v} for k, v in mapping.items()]


def remove_keys(data, target):
    """ansible.utils.remove_keys with matching_parameter=equality (also drops falsy list items)."""
    def remove(value):
        if isinstance(value, dict):
            for key in set(target):
                value.pop(key, None)
            for v in value.values():
                remove(v)
        elif isinstance(value, list):
            for v in value:
                remove(v)

    def clear_empty(value):
        if isinstance(value, dict):
            for k, v in value.items():
                value[k] = clear_empty(v)
        if isinstance(value, list):
            return [clear_empty(v) for v in value if v]
        return value

    data = copy.deepcopy(data)
    remove(data)
    return clear_empty(data)


def from_yaml(text):
    if text is None:
        return None
    return yaml.load(text, Loader=SafeLoader)


def to_yaml(data, indent=None, default_flow_style=None, **kwargs):
    return yaml.dump(data, Dumper=SafeDumper, allow_unicode=True, default_flow_style=default_flow_style,
                     indent=indent, **kwargs)


def to_nice_yaml(data, indent=4, **kwargs):
    return to_yaml(data, indent=indent, default_flow_style=False, **kwargs)


def to_json(data, **kwargs):
    return json.dumps(data, **kwargs)


def quote(value):
    return shlex.quote("" if value is None else str(value))


def b64encode(value, encoding="utf-8"):
    return base64.b64encode(str(value).encode(encoding)).decode()


def b64decode(value, encoding="utf-8"):
    return base64.b64decode(str(value).encode()).decode(encoding)


def regex_replace(value="", pattern="", replacement="", ignorecase=False, multiline=False, count=0):
    flags = (re.I if ignorecase else 0) | (re.M if multiline else 0)
    return re.sub(pattern, replacement, str(value), count=count, flags=flags)


def regex_search(value, pattern):
    match = re.search(pattern, str(value))
    return match.group(0) if match else None


def to_bool(value):
    if isinstance(value, bool):
        return value
    if isinstance(value, str):
        return value.strip().lower() in ("yes", "on", "true", "1")
    return bool(value)


# --- Jinja environment matching Ansible's -----------------------------------


class AnsibleUndefined(jinja2.ChainableUndefined):
    """Chains through missing attributes like Ansible (for `is defined` and `default`), but fails when rendered."""

    def __str__(self):
        self._fail_with_undefined_error()


def make_environment():
    env = jinja2.Environment(
        trim_blocks=True,
        autoescape=False,
        undefined=AnsibleUndefined,
        loader=jinja2.FileSystemLoader([]),
    )
    env.filters.update(
        b64decode=b64decode,
        b64encode=b64encode,
        basename=lambda p: os.path.basename(p),
        bool=to_bool,
        combine=combine,
        dict2items=dict2items,
        flatten=flatten,
        from_json=json.loads,
        from_yaml=from_yaml,
        quote=quote,
        regex_replace=regex_replace,
        regex_search=regex_search,
        subelements=subelements,
        to_json=to_json,
        to_nice_yaml=to_nice_yaml,
        to_yaml=to_yaml,
    )
    return env


def read_text(path: Path) -> str:
    # Universal newlines: a Windows clone with CRLF files renders like the Linux one
    return path.read_text(encoding="utf-8")


def write_text(path: Path, content: str):
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", encoding="utf-8", newline="\n") as f:
        f.write(content)


def _count_trailing_newlines(text: str) -> int:
    return len(text) - len(text.rstrip("\n"))


class Renderer:
    def __init__(self, context: dict):
        self.env = make_environment()
        self.context = context

    def render_string(self, source: str, search_path: list[str] | None = None) -> str:
        """Render a template string, keeping its trailing newlines like Ansible does."""
        self.env.loader = jinja2.FileSystemLoader(search_path or [])
        result = self.env.from_string(source).render(self.context)
        missing = _count_trailing_newlines(source) - _count_trailing_newlines(result)
        if missing > 0:
            result += "\n" * missing
        return result

    def render_file(self, path: Path) -> str:
        """Equivalent of lookup('ansible.builtin.template', path)."""
        return self.render_string(read_text(path), [str(path.parent)])

    def evaluate(self, value):
        """Template a task argument: a lone {{ expression }} keeps its native type, like Ansible."""
        if isinstance(value, dict):
            return {k: self.evaluate(v) for k, v in value.items()}
        if isinstance(value, list):
            return [self.evaluate(v) for v in value]
        if not isinstance(value, str) or ("{{" not in value and "{%" not in value):
            return value
        match = re.fullmatch(r"\{\{(.*)\}\}", value.strip(), re.S)
        if match and "{{" not in match.group(1):
            result = self.env.compile_expression(match.group(1), undefined_to_none=False)(**self.context)
            if isinstance(result, jinja2.Undefined):
                str(result)  # raises the undefined error
            return result
        return self.render_string(value)


# --- Reading the roles ------------------------------------------------------


def load_yaml_file(path: Path):
    return yaml.load(read_text(path), Loader=SafeLoader)


def find_task(tasks_file: Path, name: str) -> dict:
    """Find a task by name (looking into blocks) so the values come from the role itself."""
    def walk(tasks):
        for task in tasks or []:
            if task.get("name") == name:
                return task
            for key in ("block", "rescue", "always"):
                if key in task and (found := walk(task[key])):
                    return found
        return None

    task = walk(load_yaml_file(tasks_file))
    if task is None:
        raise RenderError(f"task {name!r} not found in {tasks_file.relative_to(REPO_ROOT)}: "
                          "the role changed, render.py must be updated")
    return task


def set_fact_args(tasks_file: Path, name: str) -> dict:
    return find_task(tasks_file, name)["ansible.builtin.set_fact"]


# --- Cluster access ---------------------------------------------------------


class Cluster:
    def __init__(self, kubectl: str, context: str | None):
        self.kubectl = shlex.split(kubectl) if os.name != "nt" else [kubectl]
        self.context = context

    def get(self, kind: str, name: str):
        """Return the resource as a dict, or None if it doesn't exist."""
        cmd = [*self.kubectl, "get", kind, name, "-o", "json"]
        if self.context:
            cmd.insert(len(self.kubectl), f"--context={self.context}")
        try:
            proc = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8")
        except FileNotFoundError:
            raise RenderError(f"{self.kubectl[0]!r} not found, use --kubectl")
        if proc.returncode != 0:
            if "NotFound" in proc.stderr or "not found" in proc.stderr:
                return None
            raise RenderError(f"{' '.join(cmd)} failed:\n{proc.stderr.strip()}")
        return json.loads(proc.stdout)


def helm_argo_app_version(helm: str, repo_url: str, chart_version: str) -> str | None:
    """Same lookup as rendering-apps-files/tasks/preliminary.yml."""
    helm_cmd = shlex.split(helm) if os.name != "nt" else [helm]
    try:
        add = subprocess.run([*helm_cmd, "repo", "add", "argo", repo_url, "--force-update"],
                             capture_output=True, text=True, encoding="utf-8")
        if add.returncode != 0:
            raise RenderError(f"helm repo add argo {repo_url} failed:\n{add.stderr.strip()}\n"
                              "Use --argo-app-version if the Helm repository can't be reached.")
        search = subprocess.run([*helm_cmd, "search", "repo", "-l", "argo", "--version", chart_version],
                                capture_output=True, text=True, encoding="utf-8")
    except FileNotFoundError:
        raise RenderError(f"{helm_cmd[0]!r} not found, use --helm or --argo-app-version")
    if search.returncode != 0:
        raise RenderError(f"helm search repo failed:\n{search.stderr.strip()}")
    lines = search.stdout.rstrip("\n").split("\n")
    return regex_search(lines[-1] if lines else "", r"v([0-9]*\.)+([0-9]+)")


# --- blockinfile ------------------------------------------------------------


def blockinfile(path: Path, insertafter: str, block: str, marker: str):
    """ansible.builtin.blockinfile with insertafter=<regex>, state=present."""
    original = read_text(path) if path.exists() else ""
    lines = original.splitlines(True)
    marker0 = marker.replace("{mark}", "BEGIN") + "\n"
    marker1 = marker.replace("{mark}", "END") + "\n"
    if block:
        if not block.endswith("\n"):
            block += "\n"
        blocklines = [marker0] + block.splitlines(True) + [marker1]
    else:
        blocklines = []

    n0 = n1 = None
    for i, line in enumerate(lines):
        if line == marker0:
            n0 = i
        if line == marker1:
            n1 = i

    if None in (n0, n1):
        n0 = None
        insertre = re.compile(insertafter)
        for i, line in enumerate(lines):
            if insertre.search(line):
                n0 = i
        n0 = len(lines) if n0 is None else n0 + 1
    elif n0 < n1:
        lines[n0:n1 + 1] = []
    else:
        lines[n1:n0 + 1] = []
        n0 = n1

    if n0 > 0 and not lines[n0 - 1].endswith("\n"):
        lines[n0 - 1] += "\n"
    lines[n0:n0] = blocklines
    write_text(path, "".join(lines))


# --- Rendering --------------------------------------------------------------


class Rendering:
    def __init__(self, args):
        self.args = args
        self.gitops_repo = Path(args.gitops_repo).resolve()
        self.cluster = Cluster(args.kubectl, args.context)
        self.written = 0
        self.deleted = 0

    def write(self, path: Path, content: str):
        write_text(path, content)
        self.written += 1

    def delete(self, path: Path):
        if path.is_file():
            path.unlink()
            self.deleted += 1

    # socle-config role

    def load_dsc(self):
        name = self.args.dsc_cr
        if self.args.dsc_file:
            raw = load_yaml_file(Path(self.args.dsc_file))
        else:
            raw = self.cluster.get("dsc", name)
            if raw is None:
                raise RenderError(f"dsc {name!r} not found in the cluster (kubectl get dsc)")
        if raw.get("apiVersion") != DSC_API_VERSION:
            print(f"warning: dsc apiVersion is {raw.get('apiVersion')!r}, expected {DSC_API_VERSION!r}", file=sys.stderr)
        return raw

    def socle_config(self):
        tasks = SOCLE_CONFIG / "tasks" / "main.yaml"
        raw = self.load_dsc()
        dsc_name = raw["metadata"]["name"]
        socle_version = json.loads(read_text(REPO_ROOT / "package.json"))["version"]
        ctx = {"dsc": raw, "dsc_name": dsc_name, "socle_version": socle_version,
               "gitops_local_repo": str(self.gitops_repo)}
        renderer = Renderer(ctx)
        global_dir = self.gitops_repo / raw["spec"]["global"]["gitOps"]["repo"]["path"] / "envs" / dsc_name / "apps" / "global"

        # Store CRD to local repository
        if dsc_name == "conf-dso":
            self.write(global_dir / "crds" / "dsc-crd.yaml",
                       renderer.render_file(SOCLE_CONFIG / "templates" / "crd-conf-dso.yaml"))

        # dsc_yaml, socle_version annotation and dsc name, then Store dsc to local repository
        target = ["metadata", "creationTimestamp", "generation", "managedFields", "resourceVersion", "uid"]
        dsc_yaml = to_nice_yaml(remove_keys(raw, target), indent=2)
        dsc_yaml_dict = combine(from_yaml(dsc_yaml),
                                {"metadata": {"annotations": {"socleVersion": socle_version}, "name": dsc_name}},
                                recursive=True)
        self.write(global_dir / "templates" / "dsc.yaml", to_nice_yaml(dsc_yaml_dict, indent=2))

        ctx.update(renderer.evaluate(set_fact_args(tasks, "Set instance name fact")))

        # Set full_dsc fact / Set dsc fact
        defaults_config = load_yaml_file(SOCLE_CONFIG / "files" / "config.yaml")
        defaults_releases = load_yaml_file(SOCLE_CONFIG / "files" / "releases.yaml")
        full_dsc = combine(combine(defaults_releases, defaults_config, recursive=True), raw, recursive=True)
        ctx["dsc"] = full_dsc["spec"]

        for task in ("Set private registry fact",
                     "Set root_domain fact from dsc global config",
                     "Set infra_root_domain fact from dsc global config",
                     "Set tools domains facts from dsc config",
                     "Set vaultinfra_kv_name fact"):
            for key, value in set_fact_args(tasks, task).items():
                ctx[key] = renderer.evaluate(value)

        # Set envs fact (only the app list: the vault_values are for the vault-secrets tag)
        envs = set_fact_args(SOCLE_CONFIG / "tasks" / "envs.yaml", "Set envs fact")["envs"]
        ctx["envs"] = [
            {"name": renderer.evaluate(env["name"]),
             "apps": [{k: renderer.evaluate(v) for k, v in app.items() if k != "vault_values"} for app in env["apps"]]}
            for env in envs
        ]
        self.raw_dsc = raw
        return ctx

    # rendering-apps-files role

    def combine_values(self, renderer: Renderer, values_dir: Path, user_values):
        """roles/combine: merge the rendered files in path order, then the user supplied values."""
        acc = {}
        files = sorted(p for p in values_dir.glob("*") if p.is_file() and not p.name.startswith(".")) \
            if values_dir.is_dir() else []
        for template_file in files:
            acc = combine(acc, from_yaml(renderer.render_file(template_file)), recursive=True, list_merge="append")
        return combine(acc, user_values if user_values is not None else {}, recursive=True, list_merge="prepend")

    def preliminary(self, renderer: Renderer, ctx: dict):
        dsc = ctx["dsc"]
        if self.args.argo_app_version:
            ctx["argo_app_version"] = self.args.argo_app_version
        else:
            ctx["argo_app_version"] = helm_argo_app_version(self.args.helm, dsc["argocd"]["helmRepoUrl"],
                                                            str(dsc["argocd"]["chartVersion"]))

        if self.args.argo_infra_ownership != "auto":
            ctx["argo_infra_ownership"] = self.args.argo_infra_ownership == "true"
        else:
            crd = self.cluster.get("crd", ARGO_CRD)
            annotations = ((crd or {}).get("metadata") or {}).get("annotations") or {}
            # The role compares the annotation with "{{ dsc.argocdInfra.namespace }}" nested in an expression:
            # ansible-core >= 2.19 doesn't template it and compares with the literal string, so the playbook
            # always gets false. Mirror it; once the role is fixed, compare with dsc["argocdInfra"]["namespace"].
            expected_namespace = "{{ dsc.argocdInfra.namespace }}"
            ctx["argo_infra_ownership"] = bool(
                crd is not None
                and annotations.get("meta.helm.sh/release-namespace") == expected_namespace
            )

        # GitLab instance template generation
        gitlab_values = self.combine_values(renderer, RENDERING / "gitlab" / "values", dsc["gitlab"].get("values"))
        gitlab_definition = {
            "apiVersion": "apps.gitlab.com/v1beta1",
            "kind": "GitLab",
            "metadata": {
                "name": "gitlab",
                "namespace": dsc["gitlab"]["namespace"],
                "annotations": {"argocd.argoproj.io/sync-wave": "5"},
            },
            "spec": {"chart": {"version": dsc["gitlab"]["chartVersion"], "values": gitlab_values}},
        }
        env_dir = self.gitops_repo / dsc["global"]["gitOps"]["repo"]["path"] / "envs" / ctx["envs"][0]["name"]
        (env_dir / "apps" / "gitlab" / "templates").mkdir(parents=True, exist_ok=True)
        self.write(env_dir / "apps" / "gitlab" / "templates" / "gitlab.yaml", to_nice_yaml(gitlab_definition, indent=2))

    def generate_dsc_json(self, renderer: Renderer, ctx: dict):
        content = json.loads(renderer.render_file(RENDERING / "config" / "dsc.json.j2"))
        dest = (self.gitops_repo / ctx["dsc"]["global"]["gitOps"]["repo"]["path"] / "envs" / ctx["envs"][0]["name"]
                / f"{self.raw_dsc['metadata']['name']}.json")
        self.write(dest, json.dumps(content, indent=2))

    def user_values(self, dsc: dict, app_name: str):
        """combine_user_values of rendering-apps-files/tasks/template.yml.

        Any undefined value makes the whole variable undefined, which the combine role
        turns into {} with "combine_user_values | default({})" (e.g. no dsc.observability).
        """
        try:
            return self._user_values(dsc, app_name)
        except (KeyError, TypeError):
            return {}

    @staticmethod
    def _user_values(dsc: dict, app_name: str):
        if app_name == "gitlab":
            if "cnpg" in dsc["gitlab"] and "values" in dsc["gitlab"]["cnpg"]:
                return {app_name: dsc["gitlabOperator"]["values"], "cluster": dsc[app_name]["cnpg"]["values"]}
            return {app_name: dsc["gitlabOperator"]["values"]}
        if app_name == "cloudnativepg":
            return {app_name: dsc[app_name]["operator"]["values"]}
        if "cnpg" in dsc[app_name] and "values" in dsc[app_name]["cnpg"]:
            return {app_name: dsc[app_name]["values"], "cluster": dsc[app_name]["cnpg"]["values"]}
        return {app_name: dsc[app_name]["values"]}

    def template_app(self, renderer: Renderer, ctx: dict, env: dict, app: dict):
        dsc = ctx["dsc"]
        app_name = app["argocd_app"]
        print(f"  {app_name}")
        source_path = RENDERING / "templates" / app_name
        dest_path = self.gitops_repo / dsc["global"]["gitOps"]["repo"]["path"] / "envs" / env["name"] / "apps" / app_name

        # Like the role, install_enabled keeps the previous app's value when the app has no installEnabled
        if isinstance(dsc.get(app_name), dict) and "installEnabled" in dsc[app_name]:
            if app_name != "observability":
                self.install_enabled = dsc[app_name]["installEnabled"]
            else:
                self.install_enabled = dsc["observatorium"]["installEnabled"]
        if self.install_enabled is None:
            raise RenderError(f"install_enabled is undefined for {app_name!r}")

        dest_path.mkdir(parents=True, exist_ok=True)
        if not self.install_enabled:
            return

        # Files copy
        if (source_path / "files").exists():
            shutil.copytree(source_path / "files", dest_path / "files", dirs_exist_ok=True)

        # Chart file rendering
        chart = from_yaml(renderer.render_file(source_path / "Chart.yaml.j2"))
        self.write(dest_path / "Chart.yaml", to_nice_yaml(chart, indent=2))

        # Templates rendering
        templates_dest = dest_path / "templates"
        templates_dest.mkdir(parents=True, exist_ok=True)
        users_file_exists = (templates_dest / "users.yaml").exists()
        templates = sorted(p for p in (source_path / "templates").glob("*") if p.is_file())
        for template in templates:
            if template.name == "users.yaml.j2" and users_file_exists:
                continue
            rendered = renderer.render_file(template)
            dest_file = templates_dest / re.sub(r"\.j2$", "", template.name)
            if rendered.strip() not in ("", "None"):
                self.write(dest_file, rendered)
            else:
                self.delete(dest_file)

        # Delete stale files: same globs as the role (files at the GitOps repo root, not the templates dir)
        repo_root_files = {p.name for p in self.gitops_repo.glob("*") if p.is_file()}
        template_names = {re.sub(r"\.j2$", "", p.name) for p in templates}
        for name in repo_root_files - template_names:
            self.delete(templates_dest / name)

        # Values rendering
        values = self.combine_values(renderer, source_path / "values", self.user_values(dsc, app_name))
        ctx[f"{app_name}_values"] = values
        values_file = dest_path / "values.yaml"
        self.write(values_file, to_nice_yaml(values, indent=2))

        if app_name == "argocd":
            self.parse_argocd(ctx, values_file)
        elif app_name == "vault":
            self.parse_vault(ctx, values_file)

    def parse_argocd(self, ctx: dict, values_file: Path):
        """rendering-apps-files/tasks/parsing/argocd.yml"""
        dsc = ctx["dsc"]
        argocd = dict(ctx["values"]["argocd"])
        if dsc["global"]["environment"] == "development":
            argocd["configs"] = argocd["configs"] + do_indent("p, cpin-sa, applications, *, *, allow", 4, True)
        if dsc["exposedCA"]["type"] != "none":
            argocd["cm"] = argocd["cm"] + do_indent(argocd["rootCA_block"], 2, True)
        if "additionalLabels" in dsc["global"]["metrics"]:
            argocd["controller_metrics"] = (argocd["controller_metrics"]
                                            + do_indent(argocd["controller_metrics_labels"], 4, True))
        ctx["values"] = combine(ctx["values"], {"argocd": argocd}, recursive=True)

        blockinfile(values_file, r"^  configs:\s*$", do_indent(argocd["configs"], 4, True),
                    "# {mark} ANSIBLE MANAGED BLOCK: rbac")
        blockinfile(values_file, r"^    cm:\s*$", do_indent(argocd["cm"], 6, True),
                    "# {mark} ANSIBLE MANAGED BLOCK: resource.exclusions, oidc.config and resource.customizations")
        blockinfile(values_file, r"^  controller:\s*$", do_indent(argocd["controller_metrics"], 4, True),
                    "# {mark} ANSIBLE MANAGED BLOCK: controller_metrics")

    def parse_vault(self, ctx: dict, values_file: Path):
        """rendering-apps-files/tasks/parsing/vault.yml"""
        dsc = ctx["dsc"]
        vault = ctx["values"]["vault"]
        server = ctx["vault_values"]["vault"]["server"]
        if dsc["global"]["metrics"]["enabled"] and server["ha"]["raft"]["enabled"]:
            blockinfile(values_file, r"^      raft:\s*$", do_indent(vault["raft_standalone_config"], 8, True),
                        "# {mark} ANSIBLE MANAGED BLOCK: config")
        if dsc["global"]["metrics"]["enabled"] and server["standalone"]["enabled"]:
            blockinfile(values_file, r"^    standalone:\s*$", do_indent(vault["raft_standalone_config"], 6, True),
                        "# {mark} ANSIBLE MANAGED BLOCK: config")
        if dsc["global"]["metrics"]["enabled"]:
            blockinfile(values_file, r"^vault:\s*$", do_indent(vault["serverTelemetry"], 2, True),
                        "# {mark} ANSIBLE MANAGED BLOCK: serverTelemetry")

    def run(self):
        print(f"Reading dsc {self.args.dsc_cr!r}")
        ctx = self.socle_config()
        renderer = Renderer(ctx)
        ctx["role_path"] = str(RENDERING)
        # Role vars are templated on access by Ansible, so render them once the facts exist
        ctx["values"] = renderer.evaluate(load_yaml_file(RENDERING / "vars" / "main.yaml")["values"])

        self.preliminary(renderer, ctx)
        self.generate_dsc_json(renderer, ctx)
        self.install_enabled = None
        print("Rendering apps:")
        for env, app in subelements(ctx["envs"], "apps"):
            self.template_app(renderer, ctx, env, app)
        print(f"Done: {self.written} files written, {self.deleted} deleted in {self.gitops_repo}")


def main(argv=None):
    parser = argparse.ArgumentParser(
        description="Render the GitOps apps files like 'ansible-playbook install-gitops.yaml -t rendering-apps-files'.")
    parser.add_argument("--gitops-repo", default=os.environ.get("GITOPS_REPO_PATH"),
                        help="local clone of the GitOps repository (default: $GITOPS_REPO_PATH)")
    parser.add_argument("--dsc-cr", default="conf-dso", help="name of the dsc resource (like -e dsc_cr=...)")
    parser.add_argument("--dsc-file", help="read the dsc from this YAML/JSON file instead of the cluster")
    parser.add_argument("--context", help="kubectl context to use")
    parser.add_argument("--kubectl", default="kubectl", help="kubectl command (default: kubectl)")
    parser.add_argument("--helm", default="helm", help="helm command (default: helm)")
    parser.add_argument("--argo-app-version",
                        help="Argo CD app version (e.g. v3.1.9) for dsc.argocd.chartVersion; skips the helm lookup")
    parser.add_argument("--argo-infra-ownership", choices=["auto", "true", "false"], default="auto",
                        help="whether the Argo CD CRDs belong to the infra Argo CD (default: read the CRD with kubectl)")
    args = parser.parse_args(argv)
    if not args.gitops_repo:
        parser.error("--gitops-repo is required (or set GITOPS_REPO_PATH)")
    if not Path(args.gitops_repo).is_dir():
        parser.error(f"GitOps repository not found: {args.gitops_repo}")

    try:
        Rendering(args).run()
    except (RenderError, jinja2.TemplateError) as e:
        print(f"ERROR: {e}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
