param Environment string

param Location string

param Tags object


var resourceNameLogAnalytics = 'LOG-KubernetesDemo-${Environment}'

resource resourceLogAnalytics 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: resourceNameLogAnalytics
  location: Location
  tags: Tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}


output ResourceIdLogAnalytics string = resourceLogAnalytics.id
output ResourceNameLogAnalytics string = resourceLogAnalytics.name
