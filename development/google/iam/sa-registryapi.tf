resource "google_service_account" "sa_registryapi" {
  account_id    = "sa-registryapi-001"
  display_name  = "sa-registryapi"
  description   = "Service account dedicated to be used on registryapi service"
}

resource "google_project_iam_member" "sa_registryapi_logging_role" {
  project       = var.google_project_id
  role          = "roles/logging.logWriter"
  member        = "serviceAccount:${google_service_account.sa_registryapi.email}"
}

resource "google_project_iam_member" "sa_registryapi_service_account_user_role" {
  project       = var.google_project_id
  role          = "roles/iam.serviceAccountUser"
  member        = "serviceAccount:${google_service_account.sa_registryapi.email}"
}

resource "google_project_iam_member" "sa_registryapi_firestore_role" {
  project     = var.google_project_id
  role        = "roles/datastore.viewer"
  member        = "serviceAccount:${google_service_account.sa_registryapi.email}"
}
 
output "sa_registryapi" {
  value = google_service_account.sa_registryapi
}
