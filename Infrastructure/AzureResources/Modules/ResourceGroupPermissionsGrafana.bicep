param PrincipalId string

var roleIdMonitoringReader = '${subscription().id}/providers/Microsoft.Authorization/roleDefinitions/43d0d8ad-25c7-4714-9337-8ba259a9fe05'
var roleIdMonitoringDataReader = '${subscription().id}/providers/Microsoft.Authorization/roleDefinitions/b0d8363b-8ddd-447d-831f-62ca05bff136'

resource resourceGroupPermissionMonitoringReader 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(subscription().subscriptionId, resourceGroup().id, roleIdMonitoringReader, PrincipalId)
  properties: {
    roleDefinitionId: roleIdMonitoringReader
    principalId: PrincipalId
    principalType: 'ServicePrincipal'
  }
}

resource resourceGroupPermissionMonitoringDataReader 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(subscription().subscriptionId, resourceGroup().id, roleIdMonitoringDataReader, PrincipalId)
  properties: {
    roleDefinitionId: roleIdMonitoringDataReader
    principalId: PrincipalId
    principalType: 'ServicePrincipal'
  }
}
