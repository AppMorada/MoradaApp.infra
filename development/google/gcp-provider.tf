provider "google" {
  project     = var.google_dev_project_id
  region      = var.google_main_region
}

module "iam" {
  source                          = "./iam"
  google_project_id               = var.google_dev_project_id
  google_observer_project_id      = var.google_monitor_project_id
}

module "secret_manager" {
  source                        = "./secret-manager"
  registrydb_dev_url            = var.registrydb_dev_url
  sa_function_manager_email     = module.iam.sa_auth_gateway.email
  sa_registryapi_email          = module.iam.sa_registryapi.email
  region                        = var.google_main_region
  sa_observer_agent_key         = module.iam.sa_observer_agent_key
  google_dev_email_pass         = var.google_dev_email_pass
  google_dev_cookie_key         = var.google_dev_cookie_key

  depends_on = [ 
    module.iam
  ]
}

module "network" {
  source  = "./network"
}

module "storages" {
  source  = "./storages"
}

module "firestore" {
  source              = "./firestore"
  google_project_id   = var.google_dev_project_id
  google_main_region  = var.google_main_region
}

module "functions" {
  source                      = "./functions"
  firestore_key_db_name       = module.firestore.key_db.name
  bucket_name                 = module.storages.cloud_functions_bucket.name
  google_main_region          = var.google_main_region
  google_monitor_project_id   = var.google_monitor_project_id
  google_project_uid          = var.google_dev_project_uid
  google_project_id           = var.google_dev_project_id
  sa_auth_gateway_email       = module.iam.sa_auth_gateway.email
  sa_key_manager_email        = module.iam.sa_key_manager.email 
  database_url                = module.secret_manager.registrydb_dev_url.secret_id
  observer_agent              = module.secret_manager.observer_agent.secret_id
  depends_on =  [
    module.storages,
    module.network,
    module.secret_manager,
    module.iam,
    module.firestore
  ]
}

module "schedulers" {
  source                = "./schedulers"
  update_key_url        = module.functions.update_key_fnc.https_trigger_url
  update_key_region     = module.functions.update_key_fnc.region
  depends_on            = [ module.functions ]
}

module "cloudrun" {
  source                              = "./cloud-run"
  location                            = var.google_main_region
  google_project_id                   = var.google_dev_project_id
  google_observer_project_id          = var.google_monitor_project_id
  google_observer_secret_name         = module.secret_manager.observer_agent_name
  google_email_pass_secret_name       = module.secret_manager.email_pass_name
  google_cookie_key_secret_name       = module.secret_manager.cookie_key_name
  google_database_url_secret_name     = module.secret_manager.registrydb_dev_url_name
  firestore_key_db_name               = module.firestore.key_db.name
  sa_registryapi_email                = module.iam.sa_registryapi.email
  sa_web_email                        = module.iam.sa_web.email
  depends_on                          = [ module.iam, module.secret_manager ]
}

module "cloudbuild" {
  source                        = "./cloud-build"
  sa_function_manager_id        = module.iam.sa_function_manager.id
  sa_cloud_run_manager_id       = module.iam.sa_cloudrun_manager.id
  google_project_id             = var.google_dev_project_id
  google_main_region            = var.google_main_region
  registryapi_lts_image_url     = module.cloudrun.registryapi_lts_image_url
  web_lts_image_url             = module.cloudrun.web_lts_image_url

  depends_on = [ 
    module.iam,
    module.cloudrun
  ]
}
