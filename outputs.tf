output "resource_groups" {
  description = "Resource Group objects"
  value       = azurerm_resource_group.rg
}

output "resource_group_ids" {
  description = "Map of Resource Group IDs keyed by module input key"
  value       = { for k, v in azurerm_resource_group.rg : k => v.id }
}

output "resource_group_names" {
  description = "Map of Resource Group names keyed by module input key"
  value       = { for k, v in azurerm_resource_group.rg : k => v.name }
}

output "resource_group_locations" {
  description = "Map of Resource Group locations keyed by module input key"
  value       = { for k, v in azurerm_resource_group.rg : k => v.location }
}

output "user_assigned_identities" {
  description = "User Assigned Managed Identity objects"
  value       = azurerm_user_assigned_identity.identity
}

output "user_assigned_identity_ids" {
  description = "Map of User Assigned Identity resource IDs"
  value       = { for k, v in azurerm_user_assigned_identity.identity : k => v.id }
}

output "user_assigned_identity_principal_ids" {
  description = "Map of Identity Principal IDs for RBAC role assignments"
  value       = { for k, v in azurerm_user_assigned_identity.identity : k => v.principal_id }
}

output "user_assigned_identity_client_ids" {
  description = "Map of Identity Client IDs for application authentication"
  value       = { for k, v in azurerm_user_assigned_identity.identity : k => v.client_id }
}

output "management_locks" {
  description = "Created management locks"
  value       = azurerm_management_lock.lock
}

output "role_assignments" {
  description = "Created role assignments"
  value       = azurerm_role_assignment.role
}

output "policy_assignments" {
  description = "Created policy assignments"
  value       = azurerm_resource_group_policy_assignment.policy
}
