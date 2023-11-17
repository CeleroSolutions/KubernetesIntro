param Environment string
param Location string
param Tags object

var resourceNameMonitorWorkspace = 'MON-KubernetesDemo-${Environment}'

resource monitorWorkspace 'Microsoft.Monitor/accounts@2021-06-03-preview' = {
  name: resourceNameMonitorWorkspace
  location: Location
  tags: Tags
  properties: {}
}

output ResourceIdDataCollectionRule string = monitorWorkspace.properties.defaultIngestionSettings.dataCollectionRuleResourceId
output ResourceIdMonitorWorkspace string = monitorWorkspace.id
