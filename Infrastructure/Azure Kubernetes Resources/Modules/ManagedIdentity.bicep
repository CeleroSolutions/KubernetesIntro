param ManagedIdentityDescription string

param Environment string

param Location string

param Tags object


var resourceNameManagedIdentity = 'MI-${ManagedIdentityDescription}-${Environment}'

resource resourceManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: resourceNameManagedIdentity
  location: Location
  tags: Tags
}


output ResourceIdManagedIdentity string = resourceManagedIdentity.id
output PrincipalIdManagedIdentity string = resourceManagedIdentity.properties.principalId
