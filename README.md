# 🏛️ Terraform Azure Governance Module (Pillar 1)

Production-ready, enterprise-grade Terraform child module to manage core Azure foundational governance, resource lifecycles, managed identities, and access policies.

---

## 🌟 Managed Resources

This module encapsulates 5 foundational Azure governance resources:

1. **[`azurerm_resource_group`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)**: Core logical container for resource boundaries.
2. **[`azurerm_management_lock`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock)**: Accidental deletion prevention (`CanNotDelete` / `ReadOnly`).
3. **[`azurerm_user_assigned_identity`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity)**: Standalone managed identities for secure workload authentication.
4. **[`azurerm_role_assignment`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment)**: Azure RBAC role assignments across resource groups and identities.
5. **[`azurerm_resource_group_policy_assignment`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_assignment)**: Azure Policy compliance enforcement at the resource group level.

---

## 🔐 Azure RBAC Compatibility Guide

| Resource | Contributor Role | Owner / User Access Admin | Note |
| :--- | :---: | :---: | :--- |
| **`azurerm_resource_group`** | ✅ Supported | ✅ Supported | Default baseline |
| **`azurerm_user_assigned_identity`** | ✅ Supported | ✅ Supported | `Microsoft.ManagedIdentity/*` allowed |
| **`azurerm_management_lock`** | ❌ Blocked | ✅ Supported | Requires `Microsoft.Authorization/locks/*` |
| **`azurerm_role_assignment`** | ❌ Blocked | ✅ Supported | Requires `Microsoft.Authorization/roleAssignments/*` |
| **`azurerm_resource_group_policy_assignment`** | ❌ Blocked | ✅ Supported | Requires `Resource Policy Contributor` or `Owner` |

> [!NOTE]
> All resources in this module are optional (`for_each`). If you only provide `resource_groups` and `user_assigned_identities`, the module runs smoothly with standard **Contributor** rights!

---

## 🚀 Consumption in Root Modules (`Rally-tech-infra`)

```hcl
module "governance" {
  source = "git::https://dev.azure.com/satyam-cicd-org/DevOpsOrbit/_git/terraform-azure-governance?ref=v1.0.0"

  resource_groups = {
    "rg-dev" = {
      name     = "rg-rally-dev-centralindia"
      location = "centralindia"
      tags = {
        Environment = "dev"
        Project     = "rally-tech"
        ManagedBy   = "Terraform"
      }
    }
  }

  user_assigned_identities = {
    "id-app" = {
      name               = "uai-rally-dev-app"
      location           = "centralindia"
      resource_group_key = "rg-dev"
    }
  }
}
```

---

## 📥 Inputs

| Name | Type | Description | Default | Required |
| :--- | :--- | :--- | :---: | :---: |
| `resource_groups` | `map(object)` | Map of Azure Resource Groups to create | `{}` | No |
| `user_assigned_identities` | `map(object)` | Map of User Assigned Managed Identities to provision | `{}` | No |
| `management_locks` | `map(object)` | Map of management locks to protect resources | `{}` | No |
| `role_assignments` | `map(object)` | Map of RBAC role assignments | `{}` | No |
| `policy_assignments` | `map(object)` | Map of Azure Policy assignments at RG scope | `{}` | No |

---

## 📤 Outputs

| Name | Description |
| :--- | :--- |
| `resource_groups` | Complete map of created Resource Group objects |
| `resource_group_ids` | Map of Resource Group IDs keyed by module input key |
| `resource_group_names` | Map of Resource Group names |
| `user_assigned_identities` | Complete map of User Assigned Identity objects |
| `user_assigned_identity_ids` | Map of User Assigned Identity resource IDs |
| `user_assigned_identity_principal_ids` | Map of Identity Principal (Object) IDs for RBAC |
| `user_assigned_identity_client_ids` | Map of Identity Client IDs for apps |
| `management_locks` | Map of created Management Lock objects |
| `role_assignments` | Map of created Role Assignment objects |
| `policy_assignments` | Map of created Policy Assignment objects |
