groups:
  - name: Cert-manager
    rules:
      - alert: Cert-manager Pod not healthy
        annotations:
          message: Cert-manager {{`{{`}} $labels.pod {{`}}`}} pod in namespace {{`{{`}} $labels.namespace {{`}}`}} has been unavailable for the last 5 minutes.
          summary: Cert-manager {{`{{`}} $labels.pod {{`}}`}} pod not healthy (container {{`{{`}} $labels.container {{`}}`}} is not ready)
        expr: |
          kube_pod_container_status_ready{
          pod=~"cert-manager(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}certmanager"} == 0
        for: 5m
        labels:
          severity: critical
