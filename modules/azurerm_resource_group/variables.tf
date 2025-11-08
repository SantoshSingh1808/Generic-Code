variable "rg_name" {
  description = "Name of the Resource Group"
  type = map(object({
    name       = string
    location   = string
    managed_by = string
    Environment = optional(string)
    Owner       = optional(string)
  }))
}