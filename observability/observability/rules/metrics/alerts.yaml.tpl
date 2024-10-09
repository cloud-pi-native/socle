groups:
  - name: DSO_ArgoCD
    rules:
      - alert: Argo CD App Missing
        expr: |
          absent(argocd_app_info) == 1
        for: 15m
        labels:
          severity: critical
        annotations:
          summary: "[Argo CD] No reported applications"
          description: |
            Argo CD has not reported any applications data for the past 15 minutes which
            means that it must be down or not functioning properly.  This needs to be
            resolved for this cloud to continue to maintain state.
      - alert: Argo CD App Not Synced
        expr: |
          argocd_app_info{sync_status!="Synced"} == 1
        for: 12h
        labels:
          severity: warning
        annotations:
          summary: Application not synchronized
          description: |
            Argo CD instance in namespace {{`{{`}} $labels.namespace {{`}}`}} : The application {{`{{`}} $labels.name {{`}}`}}
            in namespace {{`{{`}} $labels.dest_namespace {{`}}`}} has not been synchronized for over 12 hours,
            which means that the state of this cloud has drifted away from the state inside Git.
      - alert: Argo CD Redis HA not available
        annotations:
          message: Argo CD Redis HA in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: Argo CD Redis HA down (no ready pod)"
        expr: |
          sum(kube_pod_status_ready{
          pod=~"(.*-)*argo-redis-ha-server-.*",
          namespace="{{ .Values.app.namespacePrefix }}argocd",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: Argo CD Redis HA Haproxy not available
        annotations:
          message: Argo CD Redis HA Haproxy has not been available for the last 5 minutes.
          summary: Argo CD Redis HA Haproxy down (no ready pod)"
        expr: |
          sum(kube_pod_status_ready{
          pod=~"(.*-)*argo-redis-ha-haproxy-.*",
          namespace="{{ .Values.app.namespacePrefix }}argocd",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: Argo CD Server not available
        annotations:
          message: Argo CD Server has not been available for the last 5 minutes.
          summary: Argo CD Server down (no ready pod)"
        expr: |
          sum(kube_pod_status_ready{
          pod=~"(.*-)*argo-argocd-server-.*",
          namespace="{{ .Values.app.namespacePrefix }}argocd",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: Argo CD Repo Server not available
        annotations:
          message: Argo CD Repo Server has not been available for the last 5 minutes.
          summary: Argo CD Repo Server down (no ready pod)"
        expr: |
          sum(kube_pod_status_ready{
          pod=~"(.*-)*argo-argocd-repo-server-.*",
          namespace="{{ .Values.app.namespacePrefix }}argocd",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: Argo CD Applicationset Controller not available
        annotations:
          message: Argo CD Applicationset Controller has not been available for the last 5 minutes.
          summary: Argo CD Applicationset Controller down (no ready pod)"
        expr: |
          sum(kube_pod_status_ready{
          pod=~"(.*-)*argocd-applicationset-controller-.*",
          namespace="{{ .Values.app.namespacePrefix }}argocd",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: Argo CD Application Controller not available
        annotations:
          message: Argo CD Application Controller has not been available for the last 5 minutes.
          summary: Argo CD Application Controller down (no ready pod)"
        expr: |
          sum(kube_pod_status_ready{
          pod=~"(.*-)*argocd-application-controller-.*",
          namespace="{{ .Values.app.namespacePrefix }}argocd",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: Argo CD Pod not healthy
        annotations:
          message: Argo CD {{`{{`}} $labels.pod {{`}}`}} pod in namespace {{`{{`}} $labels.namespace {{`}}`}} has been unavailable for the last 5 minutes.
          summary: Argo CD {{`{{`}} $labels.pod {{`}}`}} pod not healthy (container {{`{{`}} $labels.container {{`}}`}} is not ready)
        expr: |
          kube_pod_container_status_ready{
          pod=~".*",
          container!~"secret-init",
          namespace="{{ .Values.app.namespacePrefix }}argocd"} == 0
        for: 5m
        labels:
          severity: warning
  - name: CNPG
    rules:
      - alert: CNPG Operator Pod not healthy
        annotations:
          message: CNPG Operator {{`{{`}} $labels.pod {{`}}`}} pod in namespace {{`{{`}} $labels.namespace {{`}}`}} has been unavailable for the last 5 minutes.
          summary: CNPG Operator {{`{{`}} $labels.pod {{`}}`}} pod not healthy (container {{`{{`}} $labels.container {{`}}`}} is not ready)
        expr: |
          kube_pod_container_status_ready{
          pod=~"cloudnative-pg(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}cloudnativepg"} == 0
        for: 5m
        labels:
          severity: critical
  - name: DSO_Console
    rules:
      - alert: DSO Console client not available
        annotations:
          message: DSO Console client in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: DSO Console client down (no ready pod)"
        expr: |
          sum(kube_pod_status_ready{
          pod=~"dso-cpn-console-client-.*",
          namespace="{{ .Values.app.namespacePrefix }}console",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: DSO Console server not available
        annotations:
          message: DSO Console server in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: DSO Console server down (no ready pod)"
        expr: |
          sum(kube_pod_status_ready{
          pod=~"dso-cpn-console-server-.*",
          namespace="{{ .Values.app.namespacePrefix }}console",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: DSO Console Pod not healthy
        annotations:
          message: DSO Console {{`{{`}} $labels.pod {{`}}`}} pod in namespace {{`{{`}} $labels.namespace {{`}}`}} has been unavailable for the last 5 minutes.
          summary: DSO Console {{`{{`}} $labels.pod {{`}}`}} pod not healthy (container {{`{{`}} $labels.container {{`}}`}} is not ready)
        expr: |
          kube_pod_container_status_ready{
          pod=~"dso-cpn-console-.*",
          namespace="{{ .Values.app.namespacePrefix }}console"} == 0
        for: 5m
        labels:
          severity: warning
      - alert: DSO Console DB not available
        annotations:
          message: All DSO Console CNPG pods in namespace {{`{{`}} $labels.namespace {{`}}`}} have been unavailable for the last 5 minutes.
          summary: DSO Console database down (containers not ready)
        expr: |
          (absent(kube_pod_container_status_ready{
          pod=~"pg-cluster-console-\\d+",
          container="postgres", namespace="{{ .Values.app.namespacePrefix }}console"}) == 1)
          or sum(kube_pod_container_status_ready{
          pod=~"pg-cluster-console-\\d+",
          container="postgres", namespace="{{ .Values.app.namespacePrefix }}console"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: DSO Console DB Pod not healthy
        annotations:
          message: DSO Console {{`{{`}} $labels.pod {{`}}`}} pod in namespace {{`{{`}} $labels.namespace {{`}}`}} has been unavailable for the last 5 minutes.
          summary: DSO Console database pod not healthy (container is not ready)
        expr: |
          kube_pod_container_status_ready{
          pod=~"pg-cluster-console-\\d+",
          container="postgres", namespace="{{ .Values.app.namespacePrefix }}console"} == 0
        for: 5m
        labels:
          severity: warning
      - alert: DSO Console PVC almost out of disk space
        annotations:
          message: PVC {{`{{`}} $labels.persistentvolumeclaim {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} is almost full (< 10% left). VALUE = {{`{{`}} $value {{`}}`}}%
          summary: DSO Console PVC almost out of disk space in namespace {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          round(
          kubelet_volume_stats_available_bytes{
          persistentvolumeclaim=~"(.*-)*console(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}console"}
          / kubelet_volume_stats_capacity_bytes{
          persistentvolumeclaim=~"(.*-)*console(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}console"} * 100, 0.01) < 10 > 0
        for: 1m
        labels:
          severity: warning
      - alert: DSO Console PVC out of disk space
        annotations:
          message: PVC {{`{{`}} $labels.persistentvolumeclaim {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} is full (0% left).
          summary: DSO Console PVC out of disk space in namespace {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          kubelet_volume_stats_available_bytes{
          persistentvolumeclaim=~"(.*-)*console(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}console"} == 0
        for: 1m
        labels:
          severity: critical
  - name: GitLab
    rules:
      - alert: GitLab webservice not available
        annotations:
          message: GitLab webservice in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: GitLab webservice down (no ready pod)"
        expr: |
          sum(kube_pod_status_ready{
          pod=~"gitlab-webservice-.*",
          namespace="{{ .Values.app.namespacePrefix }}gitlab",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: GitLab toolbox not available
        annotations:
          message: GitLab toolbox in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: GitLab toolbox down (no ready pod)"
        expr: |
          sum(kube_pod_status_ready{
          pod=~"gitlab-toolbox-.*",
          namespace="{{ .Values.app.namespacePrefix }}gitlab",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: GitLab sidekiq not available
        annotations:
          message: GitLab sidekiq in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: GitLab sidekiq down (no ready pod)"
        expr: |
          sum(kube_pod_status_ready{
          pod=~"gitlab-sidekiq-.*",
          namespace="{{ .Values.app.namespacePrefix }}gitlab",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: GitLab runner not available
        annotations:
          message: GitLab runner in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: GitLab runner down (no ready pod)"
        expr: |
          sum(kube_pod_status_ready{
          pod=~"gitlab-runner-.*",
          namespace="{{ .Values.app.namespacePrefix }}gitlab",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: GitLab redis not available
        annotations:
          message: GitLab redis in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: GitLab redis down (no ready pod)"
        expr: |
          sum(kube_pod_status_ready{
          pod=~"gitlab-redis-.*",
          namespace="{{ .Values.app.namespacePrefix }}gitlab",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: GitLab minio not available
        annotations:
          message: GitLab minio in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: GitLab minio down (no ready pod)"
        expr: |
          sum(kube_pod_status_ready{
          pod=~"gitlab-minio-.*",
          namespace="{{ .Values.app.namespacePrefix }}gitlab",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: GitLab kas not available
        annotations:
          message: GitLab kas in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: GitLab kas down (no ready pod)"
        expr: |
          sum(kube_pod_status_ready{
          pod=~"gitlab-kas-.*",
          namespace="{{ .Values.app.namespacePrefix }}gitlab",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: GitLab shell not available
        annotations:
          message: GitLab shell in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: GitLab shell down (no ready pod)"
        expr: |
          sum(kube_pod_status_ready{
          pod=~"gitlab-gitlab-shell-.*",
          namespace="{{ .Values.app.namespacePrefix }}gitlab",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: GitLab exporter not available
        annotations:
          message: GitLab exporter in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: GitLab exporter down (no ready pod)"
        expr: |
          sum(kube_pod_status_ready{
          pod=~"gitlab-gitlab-exporter-.*",
          namespace="{{ .Values.app.namespacePrefix }}gitlab",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: GitLab gitaly not available
        annotations:
          message: GitLab gitaly in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: GitLab gitaly down (no ready pod)"
        expr: |
          sum(kube_pod_status_ready{
          pod=~"gitlab-gitaly-.*",
          namespace="{{ .Values.app.namespacePrefix }}gitlab",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: GitLab ci-pipelines-exporter not available
        annotations:
          message: GitLab ci-pipelines-exporter in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: GitLab ci-pipelines-exporter down (no ready pod)"
        expr: |
          sum(kube_pod_status_ready{
          pod=~"gitlab-ci-pipelines-exporter-.*",
          namespace="{{ .Values.app.namespacePrefix }}gitlab",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: GitLab Pod not healthy
        annotations:
          message: GitLab {{`{{`}} $labels.pod {{`}}`}} pod in namespace {{`{{`}} $labels.namespace {{`}}`}} has been unavailable for the last 5 minutes.
          summary: GitLab {{`{{`}} $labels.pod {{`}}`}} pod not healthy (container {{`{{`}} $labels.container {{`}}`}} is not ready)
        expr: |
          kube_pod_container_status_ready{
          pod=~"gitlab-.*",
          container!~"gitlab|kubectl|minio-mc|migrations", namespace="{{ .Values.app.namespacePrefix }}gitlab"} == 0
        for: 5m
        labels:
          severity: warning
      - alert: GitLab DB not available
        annotations:
          message: All GitLab CNPG pods in namespace {{`{{`}} $labels.namespace {{`}}`}} have been unavailable for the last 5 minutes.
          summary: GitLab database down (containers not ready)
        expr: |
          (absent(kube_pod_container_status_ready{
          pod=~"pg-cluster-gitlab-\\d+",
          container="postgres", namespace="{{ .Values.app.namespacePrefix }}gitlab"}) == 1)
          or sum(kube_pod_container_status_ready{
          pod=~"pg-cluster-gitlab-\\d+",
          container="postgres", namespace="{{ .Values.app.namespacePrefix }}gitlab"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: GitLab DB Pod not healthy
        annotations:
          message: GitLab {{`{{`}} $labels.pod {{`}}`}} pod in namespace {{`{{`}} $labels.namespace {{`}}`}} has been unavailable for the last 5 minutes.
          summary: Gitlab database pod not healthy (container is not ready)
        expr: |
          kube_pod_container_status_ready{
          pod=~"pg-cluster-gitlab-\\d+",
          container="postgres", namespace="{{ .Values.app.namespacePrefix }}gitlab"} == 0
        for: 5m
        labels:
          severity: warning
      - alert: GitLab PVC almost out of disk space
        annotations:
          message: PVC {{`{{`}} $labels.persistentvolumeclaim {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} is almost full (< 10% left). VALUE = {{`{{`}} $value {{`}}`}}%
          summary: GitLab PVC almost out of disk space in namespace {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          round(
          kubelet_volume_stats_available_bytes{
          persistentvolumeclaim=~"(.*-)*gitlab(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}gitlab"}
          / kubelet_volume_stats_capacity_bytes{
          persistentvolumeclaim=~"(.*-)*gitlab(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}gitlab"} * 100, 0.01) < 10 > 0
        for: 1m
        labels:
          severity: warning
      - alert: GitLab PVC out of disk space
        annotations:
          message: PVC {{`{{`}} $labels.persistentvolumeclaim {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} is full (0% left).
          summary: GitLab PVC out of disk space in namespace {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          kubelet_volume_stats_available_bytes{
          persistentvolumeclaim=~"(.*-)*gitlab(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}gitlab"} == 0
        for: 1m
        labels:
          severity: critical
  - name: GitLab Operator
    rules:
      - alert: GitLab Operator Pod not healthy
        annotations:
          message: GitLab Operator {{`{{`}} $labels.pod {{`}}`}} pod in namespace {{`{{`}} $labels.namespace {{`}}`}} has been unavailable for the last 5 minutes.
          summary: GitLab Operator {{`{{`}} $labels.pod {{`}}`}} pod not healthy (container {{`{{`}} $labels.container {{`}}`}} is not ready)
        expr: |
          kube_pod_container_status_ready{
          pod=~"gitlab-controller-manager(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}gitlab-operator"} == 0
        for: 5m
        labels:
          severity: critical