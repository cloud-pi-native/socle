groups:
  - name: DSO_GitLab
    rules:
      - alert: GitLab webservice not available
        annotations:
          message: GitLab webservice in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: GitLab webservice down (no ready pod)"
        expr: |
          sum by(namespace) (kube_pod_status_ready{
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
          sum by(namespace) (kube_pod_status_ready{
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
          sum by(namespace) (kube_pod_status_ready{
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
          sum by(namespace) (kube_pod_status_ready{
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
          sum by(namespace) (kube_pod_status_ready{
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
          sum by(namespace) (kube_pod_status_ready{
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
          sum by(namespace) (kube_pod_status_ready{
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
          sum by(namespace) (kube_pod_status_ready{
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
          sum by(namespace) (kube_pod_status_ready{
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
          sum by(namespace) (kube_pod_status_ready{
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
          sum by(namespace) (kube_pod_status_ready{
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
      - alert: GitLab PVC has low remaining disk space
        annotations:
          message: PVC {{`{{`}} $labels.persistentvolumeclaim {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} is running out of disk space (< 20% left). VALUE = {{`{{`}} $value {{`}}`}}%
          summary: GitLab PVC is running out of disk space in namespace {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          round(
          kubelet_volume_stats_available_bytes{
          persistentvolumeclaim=~"(.*-)*gitlab(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}gitlab"}
          / kubelet_volume_stats_capacity_bytes{
          persistentvolumeclaim=~"(.*-)*gitlab(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}gitlab"} * 100, 0.01) < 20 > 10
        for: 1m
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
          severity: critical
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

