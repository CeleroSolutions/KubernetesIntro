param PrincipalId string

var roleIdManagedIdentityOperator = '${subscription().id}/providers/Microsoft.Authorization/roleDefinitions/f1a07417-d97a-45cb-824c-7a7467783830'
var roleIdNetworkContributor = '${subscription().id}/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7'
var roleIdMonitoringMetricsPublisher = '${subscription().id}/providers/Microsoft.Authorization/roleDefinitions/3913510d-42f4-4e42-8a64-420c390055eb'

resource resourceGroupPermissionManagedIdentityOperator 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(subscription().subscriptionId, resourceGroup().id, roleIdManagedIdentityOperator, PrincipalId)
  properties: {
    roleDefinitionId: roleIdManagedIdentityOperator
    principalId: PrincipalId
    principalType: 'ServicePrincipal'
  }
}

resource resourceGroupPermissionNetworkContributor 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(subscription().subscriptionId, resourceGroup().id, roleIdNetworkContributor, PrincipalId)
  properties: {
    roleDefinitionId: roleIdNetworkContributor
    principalId: PrincipalId
    principalType: 'ServicePrincipal'
  }
}

resource resourceGroupPermissionMonitoringMetricsPublisher 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(subscription().subscriptionId, resourceGroup().id, roleIdMonitoringMetricsPublisher, PrincipalId)
  properties: {
    roleDefinitionId: roleIdMonitoringMetricsPublisher
    principalId: PrincipalId
    principalType: 'ServicePrincipal'
  }
}
