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

# variable "subnet_id" {
#   type = string
# }
