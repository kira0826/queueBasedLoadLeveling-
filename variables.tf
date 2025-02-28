# -------------------- Global vars --------------------

variable "ingesoft5-location" {

  type        = string
  description = "Name of ingesoft 5 location for resources."
}

# -------------------- Resource vars --------------------

# Resource group

variable "ingesoft5-rg-name" {

  type        = string
  description = "Name of the resource group for ingesoft 5 practice."
}

# Service bus   

variable "ingesoft5-service-bus-name" {

  type        = string
  description = "Name of the service bus for ingesoft 5 practice."
}

variable "ingesoft5-queue-name" {

  type        = string
  description = "Name of the service bus for ingesoft 5 practice."
}

variable "ingesoft5-queue-rule-name" {

  type        = string
  description = "Name of the queue rule for bus on ingesoft 5 practice."
}

# Function staff

variable "name_function" {
  type        = string
  description = "Name Function"
}

# Storage account

variable "storage_name" {
  type        = string
  description = "Storage account name"
}

variable "plan_name" {
  type        = string
  description = "Storage account name"
}

variable "wfa_name" {
  type        = string
  description = "WFA name"
}
