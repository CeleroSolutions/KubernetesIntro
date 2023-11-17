# Deploy Load Generator to AKS

Follow these steps to deploy the Load Generator to AKS.

## Step 1: Add application in ArgoCD

From the ArgoCD homepage (see [step 2](./2%20-%20Connect%20to%20AKS%20and%20Install%20ArgoCD.md) for directions), select *Create Application*:

![ArgoCD Create Application](Resources/ArgoCdCreateApplication.png)

Fill in the following sections and click *Create*. Leave all other sections blank:


**General Settings:**

- Application Name:   load-generator
- Project Name:       default
- Sync Policy:        Automatic
- Prune Resources:    Checked
- Self Heal:          Checked

![ArgoCD Create Application General Settings](Resources/ArgoCdCreateApplicationGeneralSettings.png)


**Destination Settings:**

- Cluster URL:        https://kubernetes.default.svc
- Namespace:          argocd

![ArgoCD Create Application Destination Settings](Resources/ArgoCdCreateApplicationDestinationSettings.png)


**Source Settings:**

- Repository URL:     https://github.com/CeleroSolutions/KubernetesDemos.git
- Path:               Infrastructure/KubernetesServices/LoadGenerator

![ArgoCD Create Application Source Settings](Resources/ArgoCdCreateApplicationSourceSettings.png)

You should see the application created on the ArgoCD home page:

