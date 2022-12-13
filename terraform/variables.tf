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

variable "extra_tags" {
  description = "Extra tags to set on each created resource."
  type        = map(string)
  default     = {}
}
