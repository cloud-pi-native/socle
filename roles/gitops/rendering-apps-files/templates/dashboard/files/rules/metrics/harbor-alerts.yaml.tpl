groups:
  - name: DSO_Harbor_records
    rules:
      - record: harbor:registry:v2:req_rate5m
        expr: |
          sum by (instance) (
            rate(registry_http_requests_total{handler="base"}[5m])
          )
      - record: harbor:registry:push_requests:rate5m
        expr: |
          sum by (instance) (
            rate(registry_http_requests_total{
              handler=~"blob_upload|blob_upload_chunk|manifest",
              method=~"post|put|patch"
            }[5m])
          )
      - record: harbor:registry:push_errors_5xx:rate5m
        expr: |
          sum by (instance) (
            rate(registry_http_requests_total{
              handler=~"blob_upload|blob_upload_chunk|manifest",
              method=~"post|put|patch",
              code=~"5.."
            }[5m])
          )
      - record: harbor:registry:push_latency_seconds:p99
        expr: |
          histogram_quantile(
            0.99,
            sum by (le) (
              rate(registry_http_request_duration_seconds_bucket{
                handler=~"blob_upload|blob_upload_chunk|manifest",
                method=~"post|put|patch"
              }[5m])
            )
          )
      - record: harbor:project:quota_used_ratio
        expr: |
          (harbor_project_quota_usage_byte)
          /
          clamp_max(harbor_project_quota_byte, 1e15)
  - name: DSO_Harbor_alerts
    rules:
      - alert: Harbor registry down
        annotations:
          description: "Harbor registry in namespace {{`{{`}} $labels.namespace {{`}}`}} has been reported down for the last 5 minutes."
          summary: "Harbor registry down"
        expr: max by (instance) (harbor_up{component="registry"}) == 0
        for: 5m
        labels:
          severity: critical
      - alert: HarborRegistryV2NoSuccessWithTraffic
        annotations:
          summary: "Harbor /v2/ not available despite existing traffic"
          description: >
            No HTTP success (2xx/401/403) on /v2/ (handler=base) for 5 min,
            despite significant traffic and Harbor registry up.
        expr: |
          (max by (instance) (harbor_up{component="registry"}) == 1)
          and (harbor:registry:v2:req_rate5m > 0.05)
          and (
            sum by (instance) (
              rate(registry_http_requests_total{
                handler="base",
                code=~"2..|401|403"
              }[5m])
            ) == 0
          )
        for: 5m
        labels:
          severity: critical
      - alert: HarborRegistryPushErrorRateHigh
        annotations:
          summary: "High 5xx errors rate detected on Harbor pushes"
          description: >
            5xx errors exceeding 5% on push endpoints
            (blob_upload|blob_upload_chunk|manifest) for the last 10 min, despite registry up.
        expr: |
          (max by (instance) (harbor_up{component="registry"}) == 1)
          and (harbor:registry:push_requests:rate5m > 0.1)
          and (
            harbor:registry:push_errors_5xx:rate5m
            / ignoring(instance)
            harbor:registry:push_requests:rate5m
          ) > 0.05
        for: 10m
        labels:
          severity: warning
      - alert: HarborRegistryPushErrorsBurst
        annotations:
          summary: "5xx errors burst on Harbor pushes"
          description: "Several 5xx/s errors (5 min average) on push endpoints."
        expr: |
          (max by (instance) (harbor_up{component="registry"}) == 1)
          and (harbor:registry:push_errors_5xx:rate5m > 1)
        for: 5m
        labels:
          severity: critical
      - alert: HarborRegistryPushLatencyHigh
        annotations:
          summary: "High p99 latency on Harbor pushes"
          description: "p99 > 10s on pushes (uploads/manifests) for the last 10 min."
        expr: |
          (max by (instance) (harbor_up{component="registry"}) == 1)
          and (harbor:registry:push_latency_seconds:p99 > 10)
        for: 10m
        labels:
          severity: warning
      - alert: HarborProjectQuotaNearFull
        annotations:
          summary: "Harbor project quota > 90%"
          description: "One Harbor project quota is exceeding 90%. Pushes might fail."
        expr: harbor:project:quota_used_ratio > 0.9
        for: 15m
        labels:
          severity: critical
      - alert: Harbor core not available
        annotations:
          message: Harbor core in namespace {{`{{`}} $labels.namespace {{`}}`}} has not been available for the last 5 minutes.
          summary: Harbor core down (no ready pod)"
        expr: |
          sum by(namespace) (kube_pod_status_ready{
          pod=~"harbor-core(-.*)*",
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
          pod=~"harbor-exporter(-.*)*",
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
          pod=~"harbor-jobservice(-.*)*",
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
          pod=~"harbor-portal(-.*)*",
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
          pod=~"harbor-redis(-.*)*",
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
          pod=~"harbor-registry(-.*)*",
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
          pod=~"harbor-trivy(-.*)*",
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
          pod=~"harbor(-.*)*",
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
