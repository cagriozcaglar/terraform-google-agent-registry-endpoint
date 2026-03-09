# Vertex AI Agent Registry PSC Endpoint Terraform Module

This module provisions a Private Service Connect (PSC) endpoint to provide secure, private access to the managed Vertex AI Agent Registry service.

The core component of this module is a `google_compute_forwarding_rule` resource, which acts as the PSC endpoint, connecting a consumer VPC network to the Vertex AI service producer. This allows resources within your VPC or connected on-premises networks to communicate with the Vertex AI Agent Registry using private IP addresses.

## Usage

Below is a basic example of how to use this module. The endpoint will only be created if both the `network` and `subnetwork` variables are provided.

**Note:** You must have an existing VPC Network and a Subnetwork with `purpose` set to `PRIVATE_SERVICE_CONNECT`.

```hcl
# A VPC network is required to host the PSC endpoint.
resource "google_compute_network" "vpc_network" {
  project                 = "your-gcp-project-id"
  name                    = "my-vpc-network"
  auto_create_subnetworks = false
}

# A subnetwork with purpose=PRIVATE_SERVICE_CONNECT is required.
resource "google_compute_subnetwork" "psc_subnetwork" {
  project                  = google_compute_network.vpc_network.project
  name                     = "my-psc-subnetwork"
  ip_cidr_range            = "10.10.0.0/24"
  region                   = "us-central1"
  network                  = google_compute_network.vpc_network.id
  purpose                  = "PRIVATE_SERVICE_CONNECT"
}

module "agent_registry_endpoint" {
  source  = "path/to/this/module"

  project_id = "your-gcp-project-id"
  region     = "us-central1"
  name       = "my-vertex-agent-registry-endpoint"
  network    = google_compute_network.vpc_network.self_link
  subnetwork = google_compute_subnetwork.psc_subnetwork.self_link

  labels = {
    environment = "dev"
  }
}
```

## Requirements

The following requirements are needed to use this module:

- Terraform `v1.0+`
- Terraform Provider for Google Cloud Platform `v4.50.0+`

### APIs

The project where the PSC endpoint is created must have the following APIs enabled:

- `compute.googleapis.com`

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | The name of the Private Service Connect endpoint. | `string` | `"agent-registry-psc-endpoint"` | no |
| `network` | The self-link of the network to which the PSC endpoint will be connected. If not provided, no endpoint will be created. | `string` | `null` | yes |
| `subnetwork` | The self-link of the subnetwork to which the PSC endpoint will be connected. The subnetwork must have purpose `PRIVATE_SERVICE_CONNECT`. If not provided, no endpoint will be created. | `string` | `null` | yes |
| `project_id` | The project ID where the Private Service Connect endpoint will be created. If not provided, the provider project will be used. | `string` | `null` | no |
| `region` | The GCP region for the Private Service Connect endpoint. If not provided, the provider region will be used. | `string` | `null` | no |
| `ip_address` | The IP address of the PSC endpoint. If empty, an IP address will be automatically allocated from the subnetwork. | `string` | `null` | no |
| `labels` | A map of labels to apply to the PSC endpoint. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The full ID of the Private Service Connect endpoint (forwarding rule). Will be `null` if the endpoint is not created. |
| `ip_address` | The IP address of the Private Service Connect endpoint. Will be `null` if the endpoint is not created. |
| `name` | The name of the Private Service Connect endpoint. Will be `null` if the endpoint is not created. |
