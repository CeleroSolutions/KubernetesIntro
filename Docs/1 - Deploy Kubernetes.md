### Step 1: Install Azure CLI
Make sure you have the Azure CLI installed. You can download it from the [official Azure CLI website](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).


### Step 2: Compile Bicep to ARM
Navigate to [the directory where the Bicep file is located](../Infrastructure/Azure%20Kubernetes%20Resources) and run the following command to compile it to ARM:

```bash
az bicep build --file base.bicep --outdir ./
```

### Step 3: Deploy to Azure

Now, you can deploy the compiled ARM template to Azure using the following command:

```bash
az deployment group create --resource-group your-resource-group-name --template-file ./output/compiled-template.json --parameters TenantId="your-tenant-id" AdminGroupObjectId="your-admin-group-object-id"
```

Replace *your-resource-group-name* with the desired name for your Azure Resource Group, *your-tenant-id* and *your-admin-group-object-id* with your Azure AD Tenant ID and Admin Group Object ID (this admin group can be any group in your tenant; permissions will be assigned to the group to manage Kubernetes.). Additionally, adjust other parameter values as needed from the *base.bicep* file.

Make sure to replace the example values with your actual information.

Note: Before deploying, ensure that you have the necessary permissions and that the Azure CLI is logged in with the appropriate credentials (az login).

These steps assume that you have set up your Azure environment and have the necessary subscriptions and permissions to create resources. If you encounter any issues during deployment, review the error messages provided by the Azure CLI for troubleshooting.