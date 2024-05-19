variable "registrydb_dev_url" {
  type  = string
  sensitive = true
}

variable "sa_function_manager_email" {
  type  = string
  sensitive = true
}

variable "sa_registryapi_email" {
  type  = string
  sensitive = true
}

variable "region" {
  type  = string
  sensitive = true
}

variable "sa_observer_agent_key" {
  type = string
  sensitive = true
}

variable "google_dev_email_pass" {
  type  = string
  sensitive = true
}

variable "google_dev_cookie_key" {
  type  = string
  sensitive = true
}
