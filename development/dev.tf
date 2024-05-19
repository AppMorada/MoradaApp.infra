module "gcp" {
  source    = "./google"
  registrydb_dev_url = var.registrydb_dev_url
  google_main_region = var.google_main_region
  google_monitor_project_id = var.google_monitor_project_id
  google_dev_project_id = var.google_dev_project_id
  google_dev_project_uid = var.google_dev_project_uid
  google_dev_cookie_key = var.google_dev_cookie_key
  google_dev_email_pass = var.google_dev_email_pass
}
