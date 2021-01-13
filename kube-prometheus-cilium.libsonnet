(import 'mixin.libsonnet') + {
  prometheus+:: {
    local p = self,

    serviceMonitorCilium: {
      "apiVersion": "monitoring.coreos.com/v1",
      "kind": "ServiceMonitor",
      "metadata": {
        "name": "cilium-agent",
        "namespace": p.namespace
      },
      "spec": {
        "endpoints": [
          {
            "honorLabels": true,
            "interval": "10s",
            "path": "/metrics",
            "port": "prometheus"
          }
        ],
        "namespaceSelector": {
          "matchNames": [
            $._config.cilium.namespace
          ]
        },
        "selector": {
          "matchLabels": {
            "k8s-app": "cilium"
          }
        }
      }
    },

    serviceMonitorCiliumOperator: {
      "apiVersion": "monitoring.coreos.com/v1",
      "kind": "ServiceMonitor",
      "metadata": {
        "name": "cilium-operator",
        "namespace": p.namespace,
      },
      "spec": {
        "endpoints": [
          {
            "honorLabels": true,
            "interval": "10s",
            "path": "/metrics",
            "port": "prometheus"
          }
        ],
        "namespaceSelector": {
          "matchNames": [
            $._config.cilium.namespace
          ]
        },
        "selector": {
          "matchLabels": {
            "io.cilium/app": "operator",
            "name": "cilium-operator"
          }
        }
      }
    },

    [if $._config.cilium.enableHubble then 'serviceMonitorHubble']: {
      "apiVersion": "monitoring.coreos.com/v1",
      "kind": "ServiceMonitor",
      "metadata": {
        "name": "hubble",
        "namespace": p.namespace
      },
      "spec": {
        "endpoints": [
          {
            "honorLabels": true,
            "interval": "10s",
            "path": "/metrics",
            "port": "hubble-metrics",
            "relabelings": [
              {
                "replacement": "${1}",
                "sourceLabels": [
                  "__meta_kubernetes_pod_node_name"
                ],
                "targetLabel": "node"
              }
            ]
          }
        ],
        "namespaceSelector": {
          "matchNames": [
            $._config.cilium.namespace
          ]
        },
        "selector": {
          "matchLabels": {
            "k8s-app": "cilium"
          }
        }
      }
    },
  }
}
