# This file defines the input variables for the Terraform module.
# These variables allow users to customize the resources created by the module.
variable "ip_address" {
  description = "The IP address of the PSC endpoint. If empty, an IP address will be automatically allocated from the subnetwork."
  type        = string
  default     = null
}

variable "labels" {
  description = "A map of labels to apply to the PSC endpoint."
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "The name of the Private Service Connect endpoint."
  type        = string
  default     = "agent-registry-psc-endpoint"
}

variable "network" {
  description = "The self-link of the network to which the PSC endpoint will be connected. If not provided, no endpoint will be created."
  type        = string
  default     = null
}

variable "project_id" {
  description = "The project ID where the Private Service Connect endpoint will be created. If not provided, the provider project will be used."
  type        = string
  default     = null
}

variable "region" {
  description = "The GCP region for the Private Service Connect endpoint. If not provided, the provider region will be used."
  type        = string
  default     = null
}

variable "subnetwork" {
  description = "The self-link of the subnetwork to which the PSC endpoint will be connected. The subnetwork must have purpose `PRIVATE_SERVICE_CONNECT`. If not provided, no endpoint will be created."
  type        = string
  default     = null
}
