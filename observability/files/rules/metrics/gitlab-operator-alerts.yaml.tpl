groups:
  - name: DSO_GitLab_Operator
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
