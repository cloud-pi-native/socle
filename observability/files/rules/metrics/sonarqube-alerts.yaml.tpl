groups:
  - name: DSO_SonarQube
    rules:
      - alert: SonarQube instance not available
        annotations:
          message: SonarQube instance in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: SonarQube instance down (no ready container)"
        expr: |
          (absent(kube_pod_container_status_ready{
          pod=~"sonarqube-.*",
          container="sonarqube",
          namespace="{{ .Values.app.namespacePrefix }}sonarqube"}) == 1)
          or sum(kube_pod_container_status_ready{
          pod=~"sonarqube-.*",
          container="sonarqube",
          namespace="{{ .Values.app.namespacePrefix }}sonarqube"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: SonarQube DB not available
        annotations:
          message: All SonarQube CNPG pods in namespace {{`{{`}} $labels.namespace {{`}}`}} have been unavailable for the last 5 minutes.
          summary: SonarQube database down (containers not ready)
        expr: |
          (absent(kube_pod_container_status_ready{
          pod=~"pg-cluster-sonar-\\d+",
          container="postgres", namespace="{{ .Values.app.namespacePrefix }}sonarqube"}) == 1)
          or sum(kube_pod_container_status_ready{
          pod=~"pg-cluster-sonar-\\d+",
          container="postgres", namespace="{{ .Values.app.namespacePrefix }}sonarqube"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: Sonarqube DB Pod not healthy
        annotations:
          message: SonarQube {{`{{`}} $labels.pod {{`}}`}} pod in namespace {{`{{`}} $labels.namespace {{`}}`}} has been unavailable for the last 5 minutes.
          summary: SonarQube database pod not healthy (container is not ready)
        expr: |
          kube_pod_container_status_ready{
          pod=~"pg-cluster-sonar-\\d+",
          container="postgres", namespace="{{ .Values.app.namespacePrefix }}sonarqube"} == 0
        for: 5m
        labels:
          severity: warning
      - alert: SonarQube DB PVC almost out of disk space
        annotations:
          message: PVC {{`{{`}} $labels.persistentvolumeclaim {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} is almost full (< 10% left). VALUE = {{`{{`}} $value {{`}}`}}%
          summary: SonarQube CNPG PVC almost out of disk space in namespace {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          round(
          kubelet_volume_stats_available_bytes{
          persistentvolumeclaim=~"pg-cluster-sonar-\\d+",
          namespace="{{ .Values.app.namespacePrefix }}sonarqube"}
          / kubelet_volume_stats_capacity_bytes{
          persistentvolumeclaim=~"pg-cluster-sonar-\\d+",
          namespace="{{ .Values.app.namespacePrefix }}sonarqube"} * 100, 0.01) < 10 > 0
        for: 1m
        labels:
          severity: warning
      - alert: SonarQube DB PVC out of disk space
        annotations:
          message: PVC {{`{{`}} $labels.persistentvolumeclaim {{`}}`}} in namespace {{`{{`}} $labels.namespace {{`}}`}} is full (0% left).
          summary: SonarQube CNPG PVC out of disk space in namespace {{`{{`}} $labels.namespace {{`}}`}}
        expr: |
          kubelet_volume_stats_available_bytes{
          persistentvolumeclaim=~"pg-cluster-sonar-\\d+",
          namespace="{{ .Values.app.namespacePrefix }}sonarqube"} == 0
        for: 1m
        labels:
          severity: critical
