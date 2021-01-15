# cilium-mixin

## Using with [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus)

### Configuration
These are the available fields with respective default values that can be overridden
```jsonnet
{
  _config+:: {
    cilium+:: {
      namespace: 'kube-system', # namespace in which cilium is installed
      enableHubble: true, # will create serviceMonitor object for hubble if enabled
    }
  }
}
```

### Example Usage
```jsonnet
local kp = (import 'kube-prometheus/kube-prometheus.libsonnet') +
           (import 'cilium-mixin/kube-prometheus-cilium.libsonnet') + {
  _config+:: {
    cilium+:: {
      namespace: 'cilium-system',
      enableHubble: false,
    }
  }
};

{ ['00namespace-' + name]: kp.kubePrometheus[name] for name in std.objectFields(kp.kubePrometheus) } +
{ ['0prometheus-operator-' + name]: kp.prometheusOperator[name] for name in std.objectFields(kp.prometheusOperator) } +
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) }
```
