FROM quay.io/operator-framework/ansible-operator:v1.35.0 AS prod

ARG TARGETARCH

USER root
RUN ansible localhost -c local -m pip -a name=kubernetes
RUN dnf install -y openssl git \
  && curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
  && chmod 700 get_helm.sh \
  && ./get_helm.sh \
  && curl -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/${TARGETARCH}/kubectl \
  && chmod +x ./kubectl \
  && mv ./kubectl /usr/local/bin/kubectl
USER 1001

COPY ./requirements.yml ${HOME}/requirements.yml
RUN ansible-galaxy collection install -r ${HOME}/requirements.yml \
  && chmod -R ug+rwx ${HOME}/.ansible

RUN pip install python-gitlab==4.6.0 \
  && pip install requests==2.31 \
  && pip install jmespath

COPY ./operator/watches.yaml ${HOME}/watches.yaml
COPY ./roles/ ${HOME}/roles/
RUN mkdir playbooks
COPY ./install.yaml ${HOME}/playbooks/
COPY ./filter_plugins/ ${HOME}/playbooks/filter_plugins/
