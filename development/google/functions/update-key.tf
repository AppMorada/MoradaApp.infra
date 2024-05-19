resource "google_cloudfunctions_function" "update_key_fnc" {
  name                    = "updateKeyFunc"
  description             = "A function dedicated to update keys"
  service_account_email   = var.sa_key_manager_email
  runtime                 = "nodejs20"
  region                  = var.google_main_region

  available_memory_mb     = 128
  source_archive_bucket   = var.bucket_name
  source_archive_object   = "keyFunc-001/keyFunc.zip"
  trigger_http            = true
  https_trigger_security_level  = "SECURE_ALWAYS"
  timeout                       = 20
  max_instances                 = 1
  entry_point                   = "updateKeyFnc"
  ingress_settings              = "ALLOW_INTERNAL_ONLY"


  labels = {
    type = "cloud-function",
    service = "update-key-fnc",
    mode = "development"
  }

  environment_variables = {
    FIRESTORE_DATABASE_ID = var.firestore_key_db_name
    NODE_OPTIONS = "--enable-source-maps"
  }
}

resource "google_cloudfunctions_function_iam_member" "update_key_fnc_invoker" {
  project         = google_cloudfunctions_function.update_key_fnc.project
  region          = google_cloudfunctions_function.update_key_fnc.region
  cloud_function  = google_cloudfunctions_function.update_key_fnc.name
  role            = "roles/cloudfunctions.invoker"
  member          = "allUsers"
}

output "update_key_fnc" {
  value = google_cloudfunctions_function.update_key_fnc
}
