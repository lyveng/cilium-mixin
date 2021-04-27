{
  grafanaDashboards+:: {
    'cilium-dashboard-generic.json': (import 'cilium-dashboard-generic.json'),
    'cilium-dashboard-api.json': (import 'cilium-dashboard-api.json'),
    'cilium-dashboard-bpf.json': (import 'cilium-dashboard-bpf.json'),
    'cilium-dashboard-kvstore.json': (import 'cilium-dashboard-kvstore.json'),
    'cilium-dashboard-network-information.json': (import 'cilium-dashboard-network-information.json'),
    'cilium-dashboard-policy.json': (import 'cilium-dashboard-policy.json'),
    'cilium-dashboard-endpoints.json': (import 'cilium-dashboard-endpoints.json'),
    'cilium-dashboard-controllers.json': (import 'cilium-dashboard-controllers.json'),
    'cilium-dashboard-kubernetes-integration.json': (import 'cilium-dashboard-kubernetes-integration.json'),
    'cilium-operator-dashboard.json': (import 'cilium-operator-dashboard.json'),
    [if $._config.cilium.enableHubble then 'hubble-dashboard.json']: (import 'hubble-dashboard.json'),
  },
}
