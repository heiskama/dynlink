variable "dashboard_name" {
  type        = string
  description = "Name of the dashboard."
}

variable "config" {
  type        = map(string)
  description = "Config for the dashboard."
}
