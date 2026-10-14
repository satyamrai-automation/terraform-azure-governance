variable "resource_groups" {
  description = "Map of Azure Resource Groups to create"
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(string))
  }))
  default = {}
}

variable "management_locks" {
  description = "Map of management locks to apply to resource groups or resources (Requires Owner/User Access Administrator)"
  type = map(object({
    name               = string
    resource_group_key = optional(string)
    scope              = optional(string)
    lock_level         = string # "CanNotDelete" or "ReadOnly"
    notes              = optional(string)
  }))
  default = {}
}

variable "user_assigned_identities" {
  description = "Map of User Assigned Managed Identities to provision"
  type = map(object({
    name                = string
    location            = string
    resource_group_key  = optional(string)
    resource_group_name = optional(string)
    tags                = optional(map(string))
  }))
  default = {}
}

variable "role_assignments" {
  description = "Map of RBAC role assignments (Requires Owner/User Access Administrator)"
  type = map(object({
    resource_group_key   = optional(string)
    scope                = optional(string)
    role_definition_name = optional(string)
    role_definition_id   = optional(string)
    identity_key         = optional(string)
    principal_id         = optional(string)
  }))
  default = {}
}

variable "policy_assignments" {
  description = "Map of Azure Policy assignments at resource group scope (Requires Resource Policy Contributor/Owner)"
  type = map(object({
    name                 = string
    resource_group_key   = string
    policy_definition_id = string
    parameters           = optional(string)
    description          = optional(string)
    display_name         = optional(string)
  }))
  default = {}
}
