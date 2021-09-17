(import 'mixin.libsonnet') + {
  prometheus+:: {
    serviceCilium: {
      apiVersion: 'v1',
      kind: 'Service',
      metadata: {
        labels: {
          'k8s-app': 'cilium',
        },
        name: 'cilium-agent',
        namespace: $._config.cilium.namespace,
      },
      spec: {
        clusterIP: 'None',
        ports: [
          {
            name: 'metrics',
            port: 9090,
            protocol: 'TCP',
            targetPort: 'prometheus',
          },
          {
            name: 'envoy-metrics',
            port: 9095,
            protocol: 'TCP',
            targetPort: 'envoy-metrics',
          },
        ],
        selector: {
          'k8s-app': 'cilium',
        },
        type: 'ClusterIP',
      },
    },

    serviceCiliumOperator: {
      apiVersion: 'v1',
      kind: 'Service',
      metadata: {
        labels: {
          'io.cilium/app': 'operator',
          name: 'cilium-operator',
        },
        name: 'cilium-operator',
        namespace: $._config.cilium.namespace,
      },
      spec: {
        clusterIP: 'None',
        ports: [
          {
            name: 'metrics',
            port: 6942,
            protocol: 'TCP',
            targetPort: 'prometheus',
          },
        ],
        selector: {
          'io.cilium/app': 'operator',
          name: 'cilium-operator',
        },
        type: 'ClusterIP',
      },
    },

    serviceMonitorCilium: {
      apiVersion: 'monitoring.coreos.com/v1',
      kind: 'ServiceMonitor',
      metadata: {
        name: 'cilium-agent',
        namespace: $._config.cilium.namespace,
        labels: {
          k8s-app: 'cilium-agent',
          'app.kubernetes.io/name': 'cilium-agent',
        },
      },
      spec: {
        endpoints: [
          {
            honorLabels: true,
            interval: '10s',
            path: '/metrics',
            port: 'metrics',
          },
        ],
        namespaceSelector: {
          matchNames: [
            $._config.cilium.namespace,
          ],
        },
        selector: {
          matchLabels: {
            'k8s-app': 'cilium',
          },
        },
        targetLabels: ['k8s-app'],
      },
    },

    serviceMonitorCiliumOperator: {
      apiVersion: 'monitoring.coreos.com/v1',
      kind: 'ServiceMonitor',
      metadata: {
        name: 'cilium-operator',
        namespace: $._config.cilium.namespace,
        labels: {
          k8s-app: 'cilium-operator',
          'app.kubernetes.io/name': 'cilium-operator',
        },
      },
      spec: {
        endpoints: [
          {
            honorLabels: true,
            interval: '10s',
            path: '/metrics',
            port: 'metrics',
          },
        ],
        namespaceSelector: {
          matchNames: [
            $._config.cilium.namespace,
          ],
        },
        selector: {
          matchLabels: {
            'io.cilium/app': 'operator',
            name: 'cilium-operator',
          },
        },
        targetLabels: ['io.cilium/app'],
      },
    },

    [if $._config.cilium.enableHubble then 'serviceMonitorHubble']: {
      apiVersion: 'monitoring.coreos.com/v1',
      kind: 'ServiceMonitor',
      metadata: {
        name: 'hubble',
        namespace: $._config.cilium.namespace,
        labels: {
          k8s-app: 'hubble',
          'app.kubernetes.io/name': 'hubble',
        },
      },
      spec: {
        endpoints: [
          {
            honorLabels: true,
            interval: '10s',
            path: '/metrics',
            port: 'hubble-metrics',
            relabelings: [
              {
                replacement: '${1}',
                sourceLabels: [
                  '__meta_kubernetes_pod_node_name',
                ],
                targetLabel: 'node',
              },
            ],
          },
        ],
        namespaceSelector: {
          matchNames: [
            $._config.cilium.namespace,
          ],
        },
        selector: {
          matchLabels: {
            'k8s-app': 'cilium',
          },
        },
      },
    },
  },
}
