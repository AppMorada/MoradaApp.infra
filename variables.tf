variable "google_dev_project_id" {
  type      = string 
}

variable "google_dev_project_uid" {
  type      = string 
}

variable "google_monitor_project_id" {
  type      = string
}

variable "google_main_region" {
  type      = string
}

variable "registrydb_dev_url" {
  type  = string
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
