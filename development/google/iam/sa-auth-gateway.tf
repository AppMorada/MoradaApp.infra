resource "google_service_account" "sa_auth_gateway" {
  account_id    = "sa-auth-gateway-001"
  display_name  = "sa-auth-gateway"
  description   = "Service account dedicated to be used on auth gateway function"
}

resource "google_project_iam_member" "sa_auth_gateway_logging_role" {
  project       = var.google_project_id
  role          = "roles/logging.logWriter"
  member        = "serviceAccount:${google_service_account.sa_auth_gateway.email}"
}

resource "google_project_iam_member" "sa_auth_gateway_service_account_user_role" {
  project       = var.google_project_id
  role          = "roles/iam.serviceAccountUser"
  member        = "serviceAccount:${google_service_account.sa_auth_gateway.email}"
}

resource "google_project_iam_member" "sa_auth_gateway_firestore_role" {
  project     = var.google_project_id
  role        = "roles/datastore.viewer"
  member        = "serviceAccount:${google_service_account.sa_auth_gateway.email}"
}
 
output "sa_auth_gateway" {
  value = google_service_account.sa_auth_gateway
}
