groups:
  - name: DSO_Keycloak
    rules:
      - alert: Keycloak instance not available
        annotations:
          message: Keycloak instance in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: Keycloak instance down (no ready container)
        expr: |
          (absent(kube_pod_container_status_ready{
          pod=~"keycloak-\\d+",
          container="keycloak",
          namespace="{{ .Values.app.namespacePrefix }}keycloak"}) == 1)
          or sum(kube_pod_container_status_ready{
          pod=~"keycloak-\\d+",
          container="keycloak",
          namespace="{{ .Values.app.namespacePrefix }}keycloak"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: Keycloak Pod not healthy
        annotations:
          message: Keycloak {{`{{`}} $labels.pod {{`}}`}} pod in namespace {{`{{`}} $labels.namespace {{`}}`}} has been unavailable for the last 5 minutes.
          summary: Keycloak pod not healthy (container is not ready)
        expr: |
          kube_pod_container_status_ready{
          pod=~"keycloak-\\d+",
          container="keycloak",
          namespace="{{ .Values.app.namespacePrefix }}keycloak"} == 0
        for: 5m
        labels:
          severity: warning
      - alert: Keycloak DB not available
        annotations:
          message: All Keycloak CNPG pods in namespace {{`{{`}} $labels.namespace {{`}}`}} have been unavailable for the last 5 minutes.
          summary: Keycloak database down (containers not ready)
        expr: |
          (absent(kube_pod_container_status_ready{
          pod=~"pg-cluster-keycloak-\\d+",
          container="postgres", namespace="{{ .Values.app.namespacePrefix }}keycloak"}) == 1)
          or sum(kube_pod_container_status_ready{
          pod=~"pg-cluster-keycloak-\\d+",
          container="postgres", namespace="{{ .Values.app.namespacePrefix }}keycloak"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: Keycloak DB Pod not healthy
        annotations:
          message: Keycloak {{`{{`}} $labels.pod {{`}}`}} pod in namespace {{`{{`}} $labels.namespace {{`}}`}} has been unavailable for the last 5 minutes.
          summary: Keycloak database pod not healthy (container is not ready)
        expr: |
          kube_pod_container_status_ready{
          pod=~"pg-cluster-keycloak-\\d+",
          container="postgres", namespace="{{ .Values.app.namespacePrefix }}keycloak"} == 0
        for: 5m
        labels:
          severity: warning
      - alert: Keycloak DB PVC has low remaining disk space
        annotations:
          message: PVC {{`{{`}} $labels.persistentvolumeclaim {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} is running out of disk space (< 20% left). VALUE = {{`{{`}} $value {{`}}`}}%
          summary: Keycloak CNPG PVC is running out of disk space in namespace {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          round(
          kubelet_volume_stats_available_bytes{
          persistentvolumeclaim=~"pg-cluster-keycloak-\\d+",
          namespace="{{ .Values.app.namespacePrefix }}keycloak"}
          / kubelet_volume_stats_capacity_bytes{
          persistentvolumeclaim=~"pg-cluster-keycloak-\\d+",
          namespace="{{ .Values.app.namespacePrefix }}keycloak"} * 100, 0.01) < 20 > 10
        for: 1m
        labels:
          severity: warning
      - alert: Keycloak DB PVC almost out of disk space
        annotations:
          message: PVC {{`{{`}} $labels.persistentvolumeclaim {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} is almost full (< 10% left). VALUE = {{`{{`}} $value {{`}}`}}%
          summary: Keycloak CNPG PVC almost out of disk space in namespace {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          round(
          kubelet_volume_stats_available_bytes{
          persistentvolumeclaim=~"pg-cluster-keycloak-\\d+",
          namespace="{{ .Values.app.namespacePrefix }}keycloak"}
          / kubelet_volume_stats_capacity_bytes{
          persistentvolumeclaim=~"pg-cluster-keycloak-\\d+",
          namespace="{{ .Values.app.namespacePrefix }}keycloak"} * 100, 0.01) < 10 > 0
        for: 1m
        labels:
          severity: critical
      - alert: Keycloak DB PVC out of disk space
        annotations:
          message: PVC {{`{{`}} $labels.persistentvolumeclaim {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} is full (0% left).
          summary: Keycloak CNPG PVC out of disk space in namespace {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          kubelet_volume_stats_available_bytes{
          persistentvolumeclaim=~"pg-cluster-keycloak-\\d+",
          namespace="{{ .Values.app.namespacePrefix }}keycloak"} == 0
        for: 1m
        labels:
          severity: critical
