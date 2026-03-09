# This file defines the outputs of the Terraform module.
# Outputs are values that are exposed to the user of the module, which can be used
# in other parts of their Terraform configuration.
output "id" {
  description = "The full ID of the Private Service Connect endpoint (forwarding rule)."
  value       = try(google_compute_forwarding_rule.agent_registry_endpoint[0].id, null)
}

output "ip_address" {
  description = "The IP address of the Private Service Connect endpoint."
  value       = try(google_compute_forwarding_rule.agent_registry_endpoint[0].ip_address, null)
}

output "name" {
  description = "The name of the Private Service Connect endpoint."
  value       = try(google_compute_forwarding_rule.agent_registry_endpoint[0].name, null)
}
