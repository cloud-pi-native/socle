groups:
  - name: DSO_Harbor
    rules:
      - alert: Harbor core not available
        annotations:
          message: Harbor core in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: Harbor core down (no ready pod)"
        expr: |
          sum by(namespace) (kube_pod_status_ready{
          pod=~"harbor-core-.*",
          namespace="{{ .Values.app.namespacePrefix }}harbor",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: Harbor exporter not available
        annotations:
          message: Harbor exporter in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: Harbor exporter down (no ready pod)"
        expr: |
          sum by(namespace) (kube_pod_status_ready{
          pod=~"harbor-exporter-.*",
          namespace="{{ .Values.app.namespacePrefix }}harbor",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: Harbor jobservice not available
        annotations:
          message: Harbor jobservice in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: Harbor jobservice down (no ready pod)"
        expr: |
          sum by(namespace) (kube_pod_status_ready{
          pod=~"harbor-jobservice-.*",
          namespace="{{ .Values.app.namespacePrefix }}harbor",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: Harbor portal not available
        annotations:
          message: Harbor portal in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: Harbor portal down (no ready pod)"
        expr: |
          sum by(namespace) (kube_pod_status_ready{
          pod=~"harbor-portal-.*",
          namespace="{{ .Values.app.namespacePrefix }}harbor",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: Harbor redis not available
        annotations:
          message: Harbor redis in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: Harbor redis down (no ready pod)"
        expr: |
          sum by(namespace) (kube_pod_status_ready{
          pod=~"harbor-redis-.*",
          namespace="{{ .Values.app.namespacePrefix }}harbor",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: Harbor registry not available
        annotations:
          message: Harbor registry in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: Harbor registry down (no ready pod)"
        expr: |
          sum by(namespace) (kube_pod_status_ready{
          pod=~"harbor-registry-.*",
          namespace="{{ .Values.app.namespacePrefix }}harbor",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: Harbor trivy not available
        annotations:
          message: Harbor trivy in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: Harbor trivy down (no ready pod)"
        expr: |
          sum by(namespace) (kube_pod_status_ready{
          pod=~"harbor-trivy-.*",
          namespace="{{ .Values.app.namespacePrefix }}harbor",
          condition="true"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: Harbor Pod not healthy
        annotations:
          message: Harbor {{`{{`}} $labels.pod {{`}}`}} pod in namespace {{`{{`}} $labels.namespace {{`}}`}} has been unavailable for the last 5 minutes.
          summary: Harbor {{`{{`}} $labels.pod {{`}}`}} pod not healthy (container {{`{{`}} $labels.container {{`}}`}} is not ready)
        expr: |
          kube_pod_container_status_ready{
          pod=~"harbor-.*",
          namespace="{{ .Values.app.namespacePrefix }}harbor"} == 0
        for: 5m
        labels:
          severity: warning
      - alert: Harbor DB not available
        annotations:
          message: All Harbor CNPG pods in namespace {{`{{`}} $labels.namespace {{`}}`}} have been unavailable for the last 5 minutes.
          summary: Harbor database down (containers not ready)
        expr: |
          (absent(kube_pod_container_status_ready{
          pod=~"pg-cluster-harbor-\\d+",
          container="postgres", namespace="{{ .Values.app.namespacePrefix }}harbor"}) == 1)
          or sum(kube_pod_container_status_ready{
          pod=~"pg-cluster-harbor-\\d+",
          container="postgres", namespace="{{ .Values.app.namespacePrefix }}harbor"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: Harbor DB Pod not healthy
        annotations:
          message: Harbor {{`{{`}} $labels.pod {{`}}`}} pod in namespace {{`{{`}} $labels.namespace {{`}}`}} has been unavailable for the last 5 minutes.
          summary: Harbor database pod not healthy (container is not ready)
        expr: |
          kube_pod_container_status_ready{
          pod=~"pg-cluster-harbor-\\d+",
          container="postgres", namespace="{{ .Values.app.namespacePrefix }}harbor"} == 0
        for: 5m
        labels:
          severity: warning
      - alert: Harbor PVC has low remaining disk space
        annotations:
          message: PVC {{`{{`}} $labels.persistentvolumeclaim {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} is running out of disk space (< 20% left). VALUE = {{`{{`}} $value {{`}}`}}%
          summary: Harbor PVC is running out of disk space in namespace {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          round(
          kubelet_volume_stats_available_bytes{
          persistentvolumeclaim=~"(.*-)*harbor(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}harbor"}
          / kubelet_volume_stats_capacity_bytes{
          persistentvolumeclaim=~"(.*-)*harbor(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}harbor"} * 100, 0.01) < 20 > 10
        for: 1m
        labels:
          severity: warning
      - alert: Harbor PVC almost out of disk space
        annotations:
          message: PVC {{`{{`}} $labels.persistentvolumeclaim {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} is almost full (< 10% left). VALUE = {{`{{`}} $value {{`}}`}}%
          summary: Harbor PVC almost out of disk space in namespace {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          round(
          kubelet_volume_stats_available_bytes{
          persistentvolumeclaim=~"(.*-)*harbor(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}harbor"}
          / kubelet_volume_stats_capacity_bytes{
          persistentvolumeclaim=~"(.*-)*harbor(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}harbor"} * 100, 0.01) < 10 > 0
        for: 1m
        labels:
          severity: critical
      - alert: Harbor PVC out of disk space
        annotations:
          message: PVC {{`{{`}} $labels.persistentvolumeclaim {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} is full (0% left).
          summary: Harbor PVC out of disk space in namespace {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          kubelet_volume_stats_available_bytes{
          persistentvolumeclaim=~"(.*-)*harbor(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}harbor"} == 0
        for: 1m
        labels:
          severity: critical
