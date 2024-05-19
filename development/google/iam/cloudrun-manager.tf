resource "google_service_account" "sa_cloudrun_manager" {
  account_id    = "sa-cloudrun-manager-001"
  display_name  = "sa-cloudrun-manager"
  description   = "Service account dedicated to deploy and manage cloud run services" 
}

resource "google_project_iam_member" "sa_cloudrun_manager_function_role" {
  project       = var.google_project_id
  role          = "roles/run.admin"
  member        = "serviceAccount:${google_service_account.sa_cloudrun_manager.email}"
}

resource "google_project_iam_member" "sa_cloudrun_manager_storage_role" {
  project       = var.google_project_id
  role          = "roles/storage.objectAdmin"
  member        = "serviceAccount:${google_service_account.sa_cloudrun_manager.email}"
}

resource "google_project_iam_member" "sa_cloudrun_manager_logging_role" {
  project       = var.google_project_id
  role          = "roles/logging.logWriter"
  member        = "serviceAccount:${google_service_account.sa_cloudrun_manager.email}"
}

resource "google_project_iam_member" "sa_cloudrun_manager_service_account_user_role" {
  project       = var.google_project_id
  role          = "roles/iam.serviceAccountUser"
  member        = "serviceAccount:${google_service_account.sa_cloudrun_manager.email}"
}

resource "google_project_iam_member" "sa_cloudrun_manager_artifact_registry_role" {
  project       = var.google_project_id
  role          = "roles/artifactregistry.writer"
  member        = "serviceAccount:${google_service_account.sa_cloudrun_manager.email}"
}

output "sa_cloudrun_manager" {
  value = google_service_account.sa_cloudrun_manager
}
