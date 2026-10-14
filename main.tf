resource "azurerm_resource_group" "rg" {
  for_each = var.resource_groups

  name     = each.value.name
  location = each.value.location
  tags     = lookup(each.value, "tags", null)
}

resource "azurerm_management_lock" "lock" {
  for_each = var.management_locks

  name       = each.value.name
  scope      = lookup(each.value, "resource_group_key", null) != null ? azurerm_resource_group.rg[each.value.resource_group_key].id : each.value.scope
  lock_level = each.value.lock_level
  notes      = lookup(each.value, "notes", "Managed by Terraform")
}

resource "azurerm_user_assigned_identity" "identity" {
  for_each = var.user_assigned_identities

  name                = each.value.name
  location            = each.value.location
  resource_group_name = lookup(each.value, "resource_group_name", null) != null ? each.value.resource_group_name : azurerm_resource_group.rg[each.value.resource_group_key].name
  tags                = lookup(each.value, "tags", null)
}

resource "azurerm_role_assignment" "role" {
  for_each = var.role_assignments

  # Resolve scope from internal RG reference or explicit resource ID
  scope                = lookup(each.value, "resource_group_key", null) != null ? azurerm_resource_group.rg[each.value.resource_group_key].id : each.value.scope
  role_definition_name = lookup(each.value, "role_definition_name", null)
  role_definition_id   = lookup(each.value, "role_definition_id", null)

  # Support binding to managed identity created in this module or an external principal
  principal_id = lookup(each.value, "identity_key", null) != null ? azurerm_user_assigned_identity.identity[each.value.identity_key].principal_id : each.value.principal_id
}

resource "azurerm_resource_group_policy_assignment" "policy" {
  for_each = var.policy_assignments

  name                 = each.value.name
  resource_group_id    = azurerm_resource_group.rg[each.value.resource_group_key].id
  policy_definition_id = each.value.policy_definition_id
  parameters           = lookup(each.value, "parameters", null)
  description          = lookup(each.value, "description", null)
  display_name         = lookup(each.value, "display_name", null)
}
