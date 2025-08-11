groups:
  - name: DSO_CNPG_Operator
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
