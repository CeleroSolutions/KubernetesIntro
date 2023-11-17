
param TenantId string
param AdminGroupObjectId string

param Location string = resourceGroup().location
param Environment string = 'DEMO'

param VnetAddressSpace string = '10.0.0.0/16'
param SubnetAddressSpaceDemoPod string = '10.0.0.0/20'
param SubnetAddressSpaceSystemPod string = '10.0.16.0/22'
param SubnetAddressSpaceDemoNode string = '10.0.20.0/24'
param SubnetAddressSpaceSystemNode string = '10.0.21.0/24'
param SubnetAddressSpaceIngress string = '10.0.22.0/24'

param KubernetesVersion string = '1.27.3'

@allowed([
  'Standard_D8ads_v5'
  'Standard_D4ads_v5'
  'Standard_D2ads_v5'
  'Standard_E8ads_v5'
  'Standard_E4ads_v5'
  'Standard_E2ads_v5'
])
param NodeSizeSystemPool string = 'Standard_D2ads_v5'

@allowed([
  'Standard_D8ads_v5'
  'Standard_D4ads_v5'
  'Standard_D2ads_v5'
  'Standard_E8ads_v5'
  'Standard_E4ads_v5'
  'Standard_E2ads_v5'
])
param NodeSizeDemoPool string = 'Standard_D4ads_v5'

param InitialNodeCountDemoPool int = 2
param MinimumNodeCountDemoPool int = 2
param MaximumNodeCountDemoPool int = 10


var Tags = {}

module moduleVirtualNetwork 'Modules/VirtualNetwork.bicep' = {
  name: 'moduleVirtualNetwork'
  params: {
    Location: Location
    Environment: Environment
    Tags: Tags

    VnetAddressSpace: VnetAddressSpace
    SubnetAddressSpaceIngress: SubnetAddressSpaceIngress
    SubnetAddressSpaceDemoNode: SubnetAddressSpaceDemoNode
    SubnetAddressSpaceDemoPod: SubnetAddressSpaceDemoPod
    SubnetAddressSpaceSystemNode: SubnetAddressSpaceSystemNode
    SubnetAddressSpaceSystemPod: SubnetAddressSpaceSystemPod
  }
}

module moduleManagedIdentityControlPlane 'Modules/ManagedIdentity.bicep' = {
  name: 'moduleManagedIdentityControlPlane'
  params: {
    ManagedIdentityDescription: 'KubernetesDemoControlPlane'
    Environment: Environment
    Location: Location
    Tags: Tags
  }
}

module moduleResourceGroupPermissionsControlPlane 'Modules/ResourceGroupPermissionsControlPlane.bicep' = {
  name: 'moduleResourceGroupPermissionsControlPlane'
  params: {
    PrincipalId: moduleManagedIdentityControlPlane.outputs.PrincipalIdManagedIdentity
  }
}

module moduleLogAnalytics 'Modules/LogAnalytics.bicep' = {
  name: 'moduleLogAnalytics'
  params: {
    Location: Location
    Environment: Environment
    Tags: Tags
  }
}

module modulePrometheus 'Modules/Prometheus.bicep' = {
  name: 'modulePrometheus'
  params: {
    Location: Location
    Environment: Environment
    Tags: Tags
  }
}

module modulePrometheusRules 'Modules/PrometheusRules.bicep' = {
  name: 'modulePrometheusRules'
  params: {
    Environment: Environment
    Location: Location
    Tags: Tags

    ResourceIdMonitorWorkspace: modulePrometheus.outputs.ResourceIdMonitorWorkspace
    ResourceNameAks: moduleKubernetes.outputs.ResourceNameAksCluster
  }
}

module moduleGrafana 'Modules/Grafana.bicep' = {
  name: 'moduleGrafana'
  params: {
    Environment: Environment
    Location: Location
    Tags: Tags

    ResourceIdPrometheusWorkspace: modulePrometheus.outputs.ResourceIdMonitorWorkspace
    AdminGroupObjectId: AdminGroupObjectId
  }
}

module moduleResourceGroupPermissionsGrafana 'Modules/ResourceGroupPermissionsGrafana.bicep' = {
  name: 'moduleResourceGroupPermissionsGrafana'
  params: {
    PrincipalId: moduleGrafana.outputs.principalIdGrafana
  }
}

module moduleKubernetes 'Modules/Kubernetes.bicep' = {
  name: 'moduleKubernetes'
  dependsOn: [
    moduleResourceGroupPermissionsControlPlane
  ]
  params: {
    Location: Location
    Environment: Environment
    Tags: Tags
    
    TenantId: TenantId
    AdminGroupObjectId: AdminGroupObjectId

    KubernetesVersion: KubernetesVersion

    NodeSizeDemoPool: NodeSizeDemoPool
    NodeSizeSystemPool: NodeSizeSystemPool

    InitialNodeCountDemoPool: InitialNodeCountDemoPool
    MaximumNodeCountDemoPool: MaximumNodeCountDemoPool
    MinimumNodeCountDemoPool: MinimumNodeCountDemoPool

    ResourceIdsManagedIdentity: [
      moduleManagedIdentityControlPlane.outputs.ResourceIdManagedIdentity
    ]

    ResourceIdDataCollectionRule: modulePrometheus.outputs.ResourceIdDataCollectionRule

    ResourceIdLogAnalytics: moduleLogAnalytics.outputs.ResourceIdLogAnalytics
    ResourceNameLogAnalytics: moduleLogAnalytics.outputs.ResourceNameLogAnalytics

    ResourceIdVirtualNetwork: moduleVirtualNetwork.outputs.ResourceIdVirtualNetwork
    ResourceNameSubnetDemoNode: moduleVirtualNetwork.outputs.ResourceNameSubnetDemoNode
    ResourceNameSubnetDemoPod: moduleVirtualNetwork.outputs.ResourceNameSubnetDemoPod
    ResourceNameSubnetSystemNode: moduleVirtualNetwork.outputs.ResourceNameSubnetSystemNode
    ResourceNameSubnetSystemPod: moduleVirtualNetwork.outputs.ResourceNameSubnetSystemPod
  }
}
