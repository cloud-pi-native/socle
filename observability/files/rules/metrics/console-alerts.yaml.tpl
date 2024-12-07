groups:
  - name: DSO_Console
    rules:
      - alert: DSO Console client not available
        annotations:
          message: DSO Console client in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: DSO Console client down (no ready pod)"
        expr: |
          sum by(namespace) (kube_pod_status_ready{
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
          sum by(namespace) (kube_pod_status_ready{
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
      - alert: DSO Console PVC has low remaining disk space
        annotations:
          message: PVC {{`{{`}} $labels.persistentvolumeclaim {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} is running out of disk space (< 20% left). VALUE = {{`{{`}} $value {{`}}`}}%
          summary: DSO Console PVC is running out of disk space in namespace {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          round(
          kubelet_volume_stats_available_bytes{
          persistentvolumeclaim=~"(.*-)*console(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}console"}
          / kubelet_volume_stats_capacity_bytes{
          persistentvolumeclaim=~"(.*-)*console(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}console"} * 100, 0.01) < 20 > 10
        for: 1m
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
          severity: critical
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
