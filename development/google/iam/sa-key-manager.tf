resource "google_service_account" "sa_key_manager" {
  account_id    = "sa-key-manager-001"
  display_name  = "sa-auth-gateway"
  description   = "Service account dedicated to be used on auth gateway function"
}

resource "google_project_iam_member" "sa_key_manager_logging_role" {
  project       = var.google_project_id
  role          = "roles/logging.logWriter"
  member        = "serviceAccount:${google_service_account.sa_key_manager.email}"
}

resource "google_project_iam_member" "sa_key_manager_service_account_user_role" {
  project       = var.google_project_id
  role          = "roles/iam.serviceAccountUser"
  member        = "serviceAccount:${google_service_account.sa_key_manager.email}"
}

resource "google_project_iam_member" "sa_key_manager_firestore_role" {
  project     = var.google_project_id
  role        = "roles/datastore.user"
  member        = "serviceAccount:${google_service_account.sa_key_manager.email}"
}
 
output "sa_key_manager" {
  value = google_service_account.sa_key_manager
}
