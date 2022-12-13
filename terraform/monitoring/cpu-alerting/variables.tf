variable "location" {
  description = "Azure location"
  type        = string
}

variable "environment" {
  description = "Project environment"
  type        = string
}

variable "stack" {
  description = "Project stack name"
  type        = string
}

variable "client" {
  description = "Project client"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to deploy to"
  type        = string
}

variable "vm_id" {
  description = "monitored vm id"
  type        = string
}

variable "threshold" {
  description = "cpu alert threshold"
  type        = number
  default     = 90
}

variable "metric_description" {
  description = "metric description"
  type        = string
  default     = ""
}
