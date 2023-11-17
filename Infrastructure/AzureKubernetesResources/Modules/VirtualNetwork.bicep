param VnetAddressSpace string

param Environment string

param Location string

param Tags object

param SubnetAddressSpaceSystemNode string
param SubnetAddressSpaceSystemPod string
param SubnetAddressSpaceDemoNode string
param SubnetAddressSpaceDemoPod string
param SubnetAddressSpaceIngress string

var resourceNameVnet = 'VNET-KubernetesDemo-${Environment}'

var resourceNameSubnetSystemNode = 'SNET-KubernetesSystemNode-${Environment}'
var resourceNameSubnetSystemPod = 'SNET-KubernetesSystemPod-${Environment}'
var resourceNameSubnetDemoNode = 'SNET-KubernetesDemoNode-${Environment}'
var resourceNameSubnetDemoPod = 'SNET-KubernetesDemoPod-${Environment}'
var resourceNameSubnetIngress = 'SNET-KubernetesIngress-${Environment}'

var resourceNameNsgSystemNode = 'NSG-KubernetesSystemNode-${Environment}'
var resourceNameNsgSystemPod = 'NSG-KubernetesSystemPod-${Environment}'
var resourceNameNsgDemoNode = 'NSG-KubernetesDemoNode-${Environment}'
var resourceNameNsgDemoPod = 'NSG-KubernetesDemoPod-${Environment}'
var resourceNameNsgIngress = 'NSG-KubernetesIngress-${Environment}'

resource resourceVnet 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: resourceNameVnet
  location: Location
  tags: Tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        VnetAddressSpace
      ]
    }
    subnets: [
      {
        name: resourceNameSubnetSystemNode
        properties: {
          addressPrefix: SubnetAddressSpaceSystemNode
          networkSecurityGroup: {
            id: resourceNsgSystemNode.id
          }
        }
      }
      {
        name: resourceNameSubnetSystemPod
        properties: {
          addressPrefix: SubnetAddressSpaceSystemPod
          networkSecurityGroup: {
            id: resourceNsgSystemPod.id
          }
          delegations: [
            {
              name: 'Microsoft.ContainerService/managedClusters'
              properties: {
                serviceName: 'Microsoft.ContainerService/managedClusters'
              }
            }
          ]
        }
      }
      {
        name: resourceNameSubnetDemoNode
        properties: {
          addressPrefix: SubnetAddressSpaceDemoNode
          networkSecurityGroup: {
            id: resourceNsgDemoNode.id
          }
        }
      }
      {
        name: resourceNameSubnetDemoPod
        properties: {
          addressPrefix: SubnetAddressSpaceDemoPod
          networkSecurityGroup: {
            id: resourceNsgDemoPod.id
          }
          delegations: [
            {
              name: 'Microsoft.ContainerService/managedClusters'
              properties: {
                serviceName: 'Microsoft.ContainerService/managedClusters'
              }
            }
          ]
        }
      }
      {
        name: resourceNameSubnetIngress
        properties: {
          addressPrefix: SubnetAddressSpaceIngress
          networkSecurityGroup: {
            id: resourceNsgIngress.id
          }
        }
      }
    ]
  }
}

resource resourceNsgSystemNode 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: resourceNameNsgSystemNode
  location: Location
  tags: Tags
  properties: {
    securityRules: []
  }
}

resource resourceNsgSystemPod 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: resourceNameNsgSystemPod
  location: Location
  tags: Tags
  properties: {
    securityRules: []
  }
}

resource resourceNsgDemoNode 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: resourceNameNsgDemoNode
  location: Location
  tags: Tags
  properties: {
    securityRules: []
  }
}

resource resourceNsgDemoPod 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: resourceNameNsgDemoPod
  location: Location
  tags: Tags
  properties: {
    securityRules: []
  }
}

resource resourceNsgIngress 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: resourceNameNsgIngress
  location: Location
  tags: Tags
  properties: {
    securityRules: []
  }
}

output ResourceNameVirtualNetwork string = resourceNameVnet
output ResourceIdVirtualNetwork string = resourceVnet.id

output ResourceNameSubnetSystemNode string = resourceNameSubnetSystemNode
output ResourceNameSubnetSystemPod string = resourceNameSubnetSystemPod
output ResourceNameSubnetDemoNode string = resourceNameSubnetDemoNode
output ResourceNameSubnetDemoPod string = resourceNameSubnetDemoPod
output ResourceNameSubnetIngress string = resourceNameSubnetIngress
