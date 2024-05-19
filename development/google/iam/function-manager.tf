resource "google_service_account" "sa_function_manager" {
  account_id    = "sa-function-manager-001"
  display_name  = "sa-function-manager"
  description   = "Service account dedicated to deploy and manage cloud functions" 
}

resource "google_project_iam_member" "sa_function_manager_function_role" {
  project       = var.google_project_id
  role          = "roles/cloudfunctions.admin"
  member        = "serviceAccount:${google_service_account.sa_function_manager.email}"
}

resource "google_project_iam_member" "sa_function_manager_storage_role" {
  project       = var.google_project_id
  role          = "roles/storage.objectAdmin"
  member        = "serviceAccount:${google_service_account.sa_function_manager.email}"
}

resource "google_project_iam_member" "sa_function_manager_logging_role" {
  project       = var.google_project_id
  role          = "roles/logging.logWriter"
  member        = "serviceAccount:${google_service_account.sa_function_manager.email}"
}

resource "google_project_iam_member" "sa_function_manager_service_account_user_role" {
  project       = var.google_project_id
  role          = "roles/iam.serviceAccountUser"
  member        = "serviceAccount:${google_service_account.sa_function_manager.email}"
}

output "sa_function_manager" {
  value = google_service_account.sa_function_manager
}
