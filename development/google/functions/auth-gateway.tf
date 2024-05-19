resource "google_cloudfunctions_function" "auth_gateway_fnc" {
  name                    = "authGatewayFunc"
  description             = "A gateway dedicated to authorized users"
  service_account_email   = var.sa_auth_gateway_email 
  runtime                 = "nodejs20"
  region                  = var.google_main_region

  available_memory_mb           = 512
  source_archive_bucket         = var.bucket_name
  source_archive_object         = "authgateway-001/authgateway.zip"
  trigger_http                  = true
  https_trigger_security_level  = "SECURE_ALWAYS"
  timeout                       = 20
  max_instances                 = 5
  entry_point                   = "authGatewayFnc"
  ingress_settings              = "ALLOW_ALL"

  labels = {
    type = "cloud-function",
    service = "auth-gateway-fnc",
    mode = "development"
  } 

  environment_variables = {
    NODE_ENV                = "production",
    LOGGING_PROJECT         = var.google_monitor_project_id,
    FIRESTORE_GCP_PROJECT   = var.google_project_id,
    SERVICE_NAME            = "auth-gateway",
    DATABASE_SSL            = "true",
    FIRESTORE_DATABASE_ID   = var.firestore_key_db_name
    NODE_OPTIONS            = "--enable-source-maps"
  }

  secret_environment_variables {
    key = var.database_url
    project_id = var.google_project_uid
    secret = var.database_url
    version = "latest"
  }

  secret_environment_variables {
    key = var.observer_agent
    project_id = var.google_project_uid
    secret = var.observer_agent
    version = "latest"
  }
}

resource "google_cloudfunctions_function_iam_member" "auth_gateway_fnc_invoker" {
  project         = google_cloudfunctions_function.auth_gateway_fnc.project
  region          = google_cloudfunctions_function.auth_gateway_fnc.region
  cloud_function  = google_cloudfunctions_function.auth_gateway_fnc.name
  role            = "roles/cloudfunctions.invoker"
  member          = "allUsers"

  depends_on = [ google_cloudfunctions_function.create_key_fnc ]
}
