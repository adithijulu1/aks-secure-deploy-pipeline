# Architecture Overview

## Purpose
This pipeline delivers containerized applications to AKS through a
secure, repeatable Azure DevOps workflow, using Puppet to eliminate
configuration drift on the self-hosted build agents that run the
pipeline itself.

## Components

### Infrastructure Layer
- **Terraform** provisions the AKS cluster, VNet/subnet, NSG, and Key
  Vault.
- **ARM Template** (`arm-templates/keyvault.json`) provides an
  alternative declarative path for Key Vault provisioning, useful in
  environments standardized on ARM rather than Terraform.

### Build Agent Configuration Management
- **Puppet** (`puppet/manifests/site.pp`) ensures every self-hosted
  Azure DevOps build agent has consistent tooling (Docker, Azure CLI,
  git) regardless of when it was provisioned, preventing "works on my
  agent" pipeline failures.
- `scripts/provision-agent.sh` ties Puppet apply + Azure DevOps agent
  registration into a single provisioning step for new agent VMs.

### CI/CD Layer
- **Azure DevOps Pipeline** stages: Build (Docker image) -> 
  InfraValidate (Terraform plan) -> Deploy (Terraform apply + kubectl
  apply to AKS).

### Secrets Management
- **Key Vault** stores application secrets (e.g. DB connection
  strings), mounted into pods via the Secrets Store CSI Driver
  (`k8s/secret-provider-class.yaml`) rather than as Kubernetes
  Secrets in etcd.
- `scripts/rotate-keyvault-secret.py` automates periodic secret
  rotation.

### Monitoring Layer
- **Nagios** checks host-level health (CPU, disk) on AKS nodes,
  useful where the org already has Nagios covering VM-based
  infrastructure.
- **Azure Log Analytics** (KQL queries in `monitoring/`) covers
  Kubernetes-native signals: pod restarts, crash loops, and Key Vault
  access auditing.

## Data Flow
1. Developer pushes code -> Azure DevOps pipeline triggers.
2. Docker image builds and pushes to ACR.
3. Terraform validates/plans infrastructure changes.
4. On approval, Terraform applies and `kubectl apply` deploys to AKS.
5. Pods mount secrets from Key Vault via CSI driver at runtime.
6. Nagios and Log Analytics continuously monitor node and pod health.
