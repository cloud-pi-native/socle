groups:
  - name: DSO_Nexus
    rules:
      - alert: Nexus instance not available
        annotations:
          message: Nexus instance in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: Nexus instance down (no ready container)"
        expr: |
          (absent(kube_pod_container_status_ready{
          pod=~"nexus-.*",
          container="nexus",
          namespace="{{ .Values.app.namespacePrefix }}nexus"}) == 1)
          or sum(kube_pod_container_status_ready{
          pod=~"nexus-.*",
          container="nexus",
          namespace="{{ .Values.app.namespacePrefix }}nexus"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: Nexus PVC has low remaining disk space
        annotations:
          message: PVC {{`{{`}} $labels.persistentvolumeclaim {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} is running out of disk space (< 20% left). VALUE = {{`{{`}} $value {{`}}`}}%
          summary: Nexus PVC is running out of disk space in namespace {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          round(
          kubelet_volume_stats_available_bytes{
          persistentvolumeclaim=~"nexus-data-.*",
          namespace="{{ .Values.app.namespacePrefix }}nexus"}
          / kubelet_volume_stats_capacity_bytes{
          persistentvolumeclaim=~"nexus-data-.*",
          namespace="{{ .Values.app.namespacePrefix }}nexus"} * 100, 0.01) < 20 > 10
        for: 1m
        labels:
          severity: warning
      - alert: Nexus PVC almost out of disk space
        annotations:
          message: PVC {{`{{`}} $labels.persistentvolumeclaim {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} is almost full (< 10% left). VALUE = {{`{{`}} $value {{`}}`}}%
          summary: Nexus PVC almost out of disk space in namespace {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          round(
          kubelet_volume_stats_available_bytes{
          persistentvolumeclaim=~"nexus-data-.*",
          namespace="{{ .Values.app.namespacePrefix }}nexus"}
          / kubelet_volume_stats_capacity_bytes{
          persistentvolumeclaim=~"nexus-data-.*",
          namespace="{{ .Values.app.namespacePrefix }}nexus"} * 100, 0.01) < 10 > 0
        for: 1m
        labels:
          severity: critical
      - alert: Nexus PVC out of disk space
        annotations:
          message: PVC {{`{{`}} $labels.persistentvolumeclaim {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} is full (0% left).
          summary: Nexus PVC out of disk space in namespace {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          kubelet_volume_stats_available_bytes{
          persistentvolumeclaim=~"nexus-data-.*",
          namespace="{{ .Values.app.namespacePrefix }}nexus"} == 0
        for: 1m
        labels:
          severity: critical
