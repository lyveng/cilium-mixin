{
  grafanaDashboards+:: {
    'cilium-dashboard.json': (import 'cilium-dashboard.json'),
    'cilium-operator-dashboard.json': (import 'cilium-operator-dashboard.json'),
    [if $._config.cilium.enableHubble then 'hubble-dashboard.json']: (import 'hubble-dashboard.json'),
  },
}
