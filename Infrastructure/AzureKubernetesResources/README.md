# Azure Infrastructure Deployment Summary

This Bicep template automates the deployment of an Azure infrastructure for a Kubernetes cluster and associated services. Key components and actions include:

- **Virtual Network Setup:** Creates a virtual network with specified address spaces for various subnets.
- **Managed Identity Creation:** Establishes a managed identity for the Kubernetes control plane.
- **Resource Group Permissions:** Sets up permissions for the managed identities in the resource group.
- **Log Analytics and Monitoring:** Deploys Log Analytics and Prometheus for monitoring purposes.
- **Grafana Deployment:** Installs Grafana for visualization, with associated admin permissions.
- **Kubernetes Cluster Configuration:** Sets up a Kubernetes cluster with customizable parameters such as node sizes and counts.

## Instructions for Deployment

Follow the provided instructions in the README [here](../../Docs/1%20-%20Deploy%20Kubernetes.md) to install the Azure CLI, compile the Bicep template, and deploy the infrastructure to Azure.

Note: Ensure you have the required permissions and Azure CLI credentials before initiating the deployment.

This template aims to streamline the deployment of a robust Azure environment for Kubernetes-based applications.