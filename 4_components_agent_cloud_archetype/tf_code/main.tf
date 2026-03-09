# This file contains the main resource definition for the agent_registry_endpoint component.
# The conceptual 'agent_registry_endpoint' is implemented as a Private Service Connect (PSC)
# endpoint that provides secure, private access to the managed Vertex AI service.

data "google_client_config" "current" {}

locals {
  # Determine the project_id to use. Use the variable if provided, otherwise,
  # fall back to the project configured in the provider.
  project_id = var.project_id == null ? data.google_client_config.current.project : var.project_id
  # Determine the region to use. Use the variable if provided, otherwise,
  # fall back to the region configured in the provider.
  region = var.region == null ? data.google_client_config.current.region : var.region
  # The target service attachment for the Vertex AI API service, which hosts the Agent Registry.
  # This follows the standard Google-published service attachment format.
  target_service = "projects/cloud-llm-sa/regions/${local.region}/serviceAttachments/llm-service-attachment"
}

# This resource creates a Private Service Connect (PSC) endpoint, which provides a private and secure
# connection from a consumer VPC to the managed Vertex AI Agent Registry service.
# A PSC endpoint is implemented as a forwarding rule in Google Cloud.
# The resource will only be created if both a network and subnetwork are specified.
resource "google_compute_forwarding_rule" "agent_registry_endpoint" {
  # The resource is created only when network and subnetwork are provided.
  count = var.network != null && var.subnetwork != null ? 1 : 0

  # The project ID where the Private Service Connect endpoint will be created.
  project = local.project_id
  # The name of the Private Service Connect endpoint (forwarding rule).
  name = var.name
  # The GCP region for the Private Service Connect endpoint.
  region = local.region
  # The self-link of the network to which the PSC endpoint will be connected.
  network = var.network
  # The self-link of the subnetwork to which the PSC endpoint will be connected.
  subnetwork = var.subnetwork
  # The published service attachment for the Vertex AI service.
  target = local.target_service
  # The static IP address of the PSC endpoint. If null, an IP is auto-allocated.
  ip_address = var.ip_address
  # A map of labels to apply to the PSC endpoint resource.
  labels = var.labels
  # The load balancing scheme for PSC, which must be 'INTERNAL'.
  load_balancing_scheme = "INTERNAL"
}
