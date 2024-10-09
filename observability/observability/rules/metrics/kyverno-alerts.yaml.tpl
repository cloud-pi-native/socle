groups:
  - name: DSO_Kyverno
    rules:
      - alert: Kyverno admission controler not available
        annotations:
          message: Kyverno admission controler in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: Kyverno admission controler down (no ready pod)"
        expr: |
          sum(kube_pod_status_ready{
          pod=~"kyverno-admission-controller-.*",
          namespace="{{ .Values.app.namespacePrefix }}kyverno",
          condition="true"}) == 0
        for: 1m
        labels:
          severity: critical
      - alert: Kyverno background controler not available
        annotations:
          message: Kyverno background controler in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: Kyverno background controler down (no ready pod)"
        expr: |
          sum(kube_pod_status_ready{
          pod=~"kyverno-background-controller-.*",
          namespace="{{ .Values.app.namespacePrefix }}kyverno",
          condition="true"}) == 0
        for: 1m
        labels:
          severity: critical
      - alert: Kyverno cleanup controller not available
        annotations:
          message: Kyverno cleanup controller in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: Kyverno cleanup controller down (no ready pod)"
        expr: |
          sum(kube_pod_status_ready{
          pod=~"kyverno-cleanup-controller-.*",
          namespace="{{ .Values.app.namespacePrefix }}kyverno",
          condition="true"}) == 0
        for: 1m
        labels:
          severity: critical
      - alert: Kyverno reports controller not available
        annotations:
          message: Kyverno reports controller in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: Kyverno reports controller down (no ready pod)"
        expr: |
          sum(kube_pod_status_ready{
          pod=~"kyverno-reports-controller-.*",
          namespace="{{ .Values.app.namespacePrefix }}kyverno",
          condition="true"}) == 0
        for: 1m
        labels:
          severity: critical
      - alert: Kyverno Pod not healthy
        annotations:
          message: Kyverno {{`{{`}} $labels.pod {{`}}`}} pod in namespace {{`{{`}} $labels.namespace {{`}}`}} has been unavailable for the last 5 minutes.
          summary: Kyverno {{`{{`}} $labels.pod {{`}}`}} pod not healthy (container {{`{{`}} $labels.container {{`}}`}} is not ready)
        expr: |
          kube_pod_container_status_ready{
          pod!~"(.*-)*admission-reports(-.*)*",
          namespace="{{ .Values.app.namespacePrefix }}kyverno"} == 0
        for: 1m
        labels:
          severity: warning
