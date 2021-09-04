variable "prefix" {
  type        = string
  default     = "tf"
  description = "Prefixs are used to assist with naming conventions."
}

variable "tags" {
  type        = map(any)
  description = "Add some tags to allow us to track cloud infrastructure. Required: Owner's name and dept/billing code"
  default = {
    "Owner" = "Sr. Dev",
    "Dept." = "Finance"
  }
}