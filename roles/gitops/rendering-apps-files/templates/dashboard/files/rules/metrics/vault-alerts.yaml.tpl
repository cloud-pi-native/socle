groups:
  - name: DSO_Vault
    rules:
      - alert: Vault is sealed
        annotations:
          message: Vault instance in namespace {{`{{`}} $labels.namespace {{`}}`}} is sealed.
          summary: Vault instance sealed
        expr: |
          max(1 + vault_core_unsealed{namespace="{{ .Values.app.namespacePrefix }}vault"}) == 1
        for: 5m
        labels:
          severity: critical
      - alert: Vault instance not healthy
        annotations:
          message: Vault {{`{{`}} $labels.pod {{`}}`}} pod in namespace {{`{{`}} $labels.namespace {{`}}`}} is not healthy (sealed?). Check its logs.
          summary: Vault instance is not healthy (sealed?)
        expr: |
          up{job="(.*-)*vault-internal",pod=~"(.*-)*vault(-.*)*"} == 0
        for: 5m
        labels:
          severity: warning
      - alert: Vault is not available
        annotations:
          message: Vault in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: Vault is down (no ready container)
        expr: |
          (absent(kube_pod_container_status_ready{
          pod=~"(.*-)*vault(-.*)*",
          container="vault",
          namespace="{{ .Values.app.namespacePrefix }}vault"}) == 1)
          or sum(kube_pod_container_status_ready{
          pod=~"(.*-)*vault(-.*)*",
          container="vault",
          namespace="{{ .Values.app.namespacePrefix }}vault"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: Vault agent injector is not available
        annotations:
          message: Vault agent injector in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: Vault agent injector is down (no ready container)
        expr: |
          (absent(kube_pod_container_status_ready{
          pod=~"(.*-)*vault(-.*)*",
          container="sidecar-injector",
          namespace="{{ .Values.app.namespacePrefix }}vault"}) == 1)
          or sum(kube_pod_container_status_ready{
          pod=~"(.*-)*vault(-.*)*",
          container="sidecar-injector",
          namespace="{{ .Values.app.namespacePrefix }}vault"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: Vault Pod not healthy
        annotations:
          message: Vault {{`{{`}} $labels.pod {{`}}`}} pod in namespace {{`{{`}} $labels.namespace {{`}}`}} has been unavailable for the last 5 minutes.
          summary: Vault pod not healthy (container is not ready)
        expr: |
          kube_pod_container_status_ready{
          pod!~"backup-utils-vault(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}vault"} == 0
        for: 5m
        labels:
          severity: warning
      - alert: Vault PVC has low remaining disk space
        annotations:
          message: PVC {{`{{`}} $labels.persistentvolumeclaim {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} is running out of disk space (< 20% left). VALUE = {{`{{`}} $value {{`}}`}}%
          summary: Vault PVC is running out of disk space in namespace {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          round(
          kubelet_volume_stats_available_bytes{
          persistentvolumeclaim=~"(.*-)*vault(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}vault"}
          / kubelet_volume_stats_capacity_bytes{
          persistentvolumeclaim=~"(.*-)*vault(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}vault"} * 100, 0.01) < 20 > 10
        for: 1m
        labels:
          severity: warning
      - alert: Vault PVC almost out of disk space
        annotations:
          message: PVC {{`{{`}} $labels.persistentvolumeclaim {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} is almost full (< 10% left). VALUE = {{`{{`}} $value {{`}}`}}%
          summary: Vault PVC almost out of disk space in namespace {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          round(
          kubelet_volume_stats_available_bytes{
          persistentvolumeclaim=~"(.*-)*vault(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}vault"}
          / kubelet_volume_stats_capacity_bytes{
          persistentvolumeclaim=~"(.*-)*vault(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}vault"} * 100, 0.01) < 10 > 0
        for: 1m
        labels:
          severity: critical
      - alert: Vault PVC out of disk space
        annotations:
          message: PVC {{`{{`}} $labels.persistentvolumeclaim {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} is full (0% left).
          summary: Vault PVC out of disk space in namespace {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          kubelet_volume_stats_available_bytes{
          persistentvolumeclaim=~"(.*-)*vault(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}vault"} == 0
        for: 1m
        labels:
          severity: critical
