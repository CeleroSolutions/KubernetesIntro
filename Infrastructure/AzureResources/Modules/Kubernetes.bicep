param Environment string

param Location string

param Tags object

@allowed([
  'Standard_D8ads_v5'
  'Standard_D4ads_v5'
  'Standard_D2ads_v5'
  'Standard_E8ads_v5'
  'Standard_E4ads_v5'
  'Standard_E2ads_v5'
])
param NodeSizeSystemPool string

@allowed([
  'Standard_D8ads_v5'
  'Standard_D4ads_v5'
  'Standard_D2ads_v5'
  'Standard_E8ads_v5'
  'Standard_E4ads_v5'
  'Standard_E2ads_v5'
])
param NodeSizeDemoPool string

param InitialNodeCountDemoPool int
param MinimumNodeCountDemoPool int
param MaximumNodeCountDemoPool int

param KubernetesVersion string

param AdminGroupObjectId string
param TenantId string

param ResourceIdLogAnalytics string
param ResourceNameLogAnalytics string
param ResourceIdVirtualNetwork string
param ResourceIdsManagedIdentity array

param ResourceNameSubnetSystemNode string
param ResourceNameSubnetSystemPod string
param ResourceNameSubnetDemoNode string
param ResourceNameSubnetDemoPod string

param ResourceIdDataCollectionRule string


var resourceNameAks = 'AKS-KubernetesDemo-${Environment}-01'

var resourceGroupNameAksNode = 'RG-KubernetesDemo-${Environment}'

var resourceNameDcr = 'MSCI-${Location}-${resourceNameAks}'

var ResourceIdsManagedIdentityFormatArray = [for resourceIdManagedIdentity in ResourceIdsManagedIdentity: {
  '${resourceIdManagedIdentity}': {}
}]
var ResourceIdsManagedIdentityFormatObject = replace(replace(replace(string(ResourceIdsManagedIdentityFormatArray), '[{', '{'), '}},{', '},'), '}]', '}')
var ResourceIdsManagedIdentityFormatJson = json(ResourceIdsManagedIdentityFormatObject)

var ephemeralDiskSizeMappingGb = {
  Standard_D8ads_v5: 300
  Standard_D4ads_v5: 150
  Standard_D2ads_v5: 75
  Standard_E8ads_v5: 300
  Standard_E4ads_v5: 150
  Standard_E2ads_v5: 75
}


resource resourceAks 'Microsoft.ContainerService/managedClusters@2022-11-02-preview' = {
  name: resourceNameAks
  location: Location
  tags: Tags
  properties: {
    kubernetesVersion: KubernetesVersion
    dnsPrefix: uniqueString(subscription().subscriptionId, resourceGroup().name, resourceNameAks)
    agentPoolProfiles: [
      {
        name: 'system'
        count: 3
        minCount: 3
        maxCount: 6
        enableAutoScaling: true
        vmSize: NodeSizeSystemPool
        osDiskType: 'Ephemeral'
        osDiskSizeGB: ephemeralDiskSizeMappingGb[NodeSizeSystemPool]
        osType: 'Linux'
        vnetSubnetID: '${ResourceIdVirtualNetwork}/subnets/${ResourceNameSubnetSystemNode}'
        podSubnetID: '${ResourceIdVirtualNetwork}/subnets/${ResourceNameSubnetSystemPod}'
        type: 'VirtualMachineScaleSets'
        mode: 'System'
        scaleSetPriority: 'Regular'
        scaleSetEvictionPolicy: 'Delete'
        orchestratorVersion: KubernetesVersion
        enableNodePublicIP: false
        maxPods: 40
        availabilityZones: pickZones('Microsoft.Compute', 'virtualMachineScaleSets', Location, 3)
        upgradeSettings: {
          maxSurge: '33%'
        }
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        nodeLabels: {
          nodetype: 'system'
        }
      }
    ]
    servicePrincipalProfile: {
      clientId: 'msi'
    }
    addonProfiles: {
      httpApplicationRouting: {
        enabled: false
      }
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceId: ResourceIdLogAnalytics
          useAADAuth: 'true'
        }
      }
      aciConnectorLinux: {
        enabled: false
      }
      azurepolicy: {
        enabled: true
        config: {
          version: 'v2'
        }
      }
    }
    nodeResourceGroup: resourceGroupNameAksNode
    enableRBAC: true
    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'azure'
      serviceCidr: '172.16.0.0/16'
      dnsServiceIP: '172.16.0.10'
      dockerBridgeCidr: '172.18.0.1/16'
      loadBalancerSku: 'standard'
      outboundType: 'loadBalancer'
    }
    aadProfile: {
      managed: true
      enableAzureRBAC: false
      adminGroupObjectIDs: [
        AdminGroupObjectId
      ]
      tenantID: TenantId
    }
    autoScalerProfile: {
      'balance-similar-node-groups': 'false'
      expander: 'random'
      'max-empty-bulk-delete': '10'
      'max-graceful-termination-sec': '600'
      'max-node-provision-time': '15m'
      'max-total-unready-percentage': '45'
      'new-pod-scale-up-delay': '0s'
      'ok-total-unready-count': '3'
      'scale-down-delay-after-add': '5m'
      'scale-down-delay-after-delete': '20s'
      'scale-down-delay-after-failure': '3m'
      'scale-down-unneeded-time': '5m'
      'scale-down-unready-time': '20m'
      'scale-down-utilization-threshold': '0.5'
      'scan-interval': '10s'
      'skip-nodes-with-local-storage': 'true'
      'skip-nodes-with-system-pods': 'true'
    }
    oidcIssuerProfile: {
      enabled: true
    }
    podIdentityProfile: {
      enabled: false
    }
    disableLocalAccounts: true
    securityProfile: {
      workloadIdentity: {
        enabled: true
      }
      defender: {
        logAnalyticsWorkspaceResourceId: ResourceIdLogAnalytics
        securityMonitoring: {
          enabled: true
        }
      }
    }
    azureMonitorProfile: {
      metrics: {
        enabled: true
        kubeStateMetrics: {
          metricLabelsAllowlist: ''
          metricAnnotationsAllowList: ''
        }
      }
    }
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: ResourceIdsManagedIdentityFormatJson  
  }
  sku: {
    name: 'Basic'
    tier: 'Free'
  }
}


resource resourceAksAgentPoolDemo 'Microsoft.ContainerService/managedClusters/agentPools@2023-03-01' = {
  name: 'demo'
  parent: resourceAks
  properties: {
    count: InitialNodeCountDemoPool
    minCount: MinimumNodeCountDemoPool
    maxCount: MaximumNodeCountDemoPool
    enableAutoScaling: true
    vmSize: NodeSizeDemoPool
    osDiskType: 'Ephemeral'
    osDiskSizeGB: ephemeralDiskSizeMappingGb[NodeSizeDemoPool]
    osType: 'Linux'
    vnetSubnetID: '${ResourceIdVirtualNetwork}/subnets/${ResourceNameSubnetDemoNode}'
    podSubnetID: '${ResourceIdVirtualNetwork}/subnets/${ResourceNameSubnetDemoPod}'
    type: 'VirtualMachineScaleSets'
    mode: 'User'
    scaleSetPriority: 'Regular'
    scaleSetEvictionPolicy: 'Delete'
    orchestratorVersion: KubernetesVersion
    enableNodePublicIP: false
    maxPods: 50
    availabilityZones: pickZones('Microsoft.Compute', 'virtualMachineScaleSets', Location, 3)
    upgradeSettings: {
      maxSurge: '33%'
    }
    nodeLabels: {
      nodetype: 'app'
    }
  }
}


resource dcr 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: resourceNameDcr
  location: Location
  tags: Tags
  kind: 'Linux'
  properties: {
    dataSources: {
      extensions: [
        {
          name: 'ContainerInsightsExtension'
          streams: [
            'Microsoft-ContainerLogV2'
            'Microsoft-KubeEvents'
            'Microsoft-KubePodInventory'
            'Microsoft-KubeNodeInventory'
            'Microsoft-KubeMonAgentEvents'
          ]
          extensionSettings: {
            dataCollectionSettings: {
              interval: '1m'
              namespaceFilteringMode: 'Off'
              namespaces: []
              enableContainerLogV2: true
            }
          }
          extensionName: 'ContainerInsights'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: ResourceIdLogAnalytics
          name: ResourceNameLogAnalytics
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-KubeEvents'
          'Microsoft-KubePodInventory'
          'Microsoft-KubeNodeInventory'
          'Microsoft-KubeMonAgentEvents'
        ]
        destinations: [
          ResourceNameLogAnalytics
        ]
      }
      {
        streams: [
          'Microsoft-ContainerLogV2'
        ]
        destinations: [
          ResourceNameLogAnalytics
        ]
      }
    ]
  }
}

resource dataCollectionRuleAssociationInsights 'Microsoft.Insights/dataCollectionRuleAssociations@2021-09-01-preview' = {
  name: 'ContainerInsightsExtension'
  scope: resourceAks
  properties: {
    description: 'Association of data collection rule. Deleting this association will break the data collection for this AKS Cluster.'
    dataCollectionRuleId: dcr.id
  }
}

resource dataCollectionRuleAssociationPrometheus 'Microsoft.Insights/dataCollectionRuleAssociations@2021-09-01-preview' = {
  name: '${split(ResourceIdDataCollectionRule, '/')[8]}-${split(resourceAks.id, '/')[8]}' 
  scope: resourceAks
  properties: {
    description: 'Association of data collection rule. Deleting this association will break the data collection for this AKS Cluster.'
    dataCollectionRuleId: ResourceIdDataCollectionRule
  }
}


output PrincipalIdAgentPool string = resourceAks.properties.identityProfile.kubeletidentity.objectId
output ResourceNameAksCluster string = resourceAks.name
