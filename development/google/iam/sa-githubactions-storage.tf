resource "google_service_account" "sa_githubactions_storage" {
  account_id      = "sa-githubactions-oas-001"
  display_name    = "sa-githubactions-oas"
  description     = "Service account dedicated to be used on github actions to manipulate buckets"
}

resource "google_project_iam_member" "sa_githubactions_storage_role" {
  project       = var.google_project_id
  role          = "roles/storage.objectUser"
  member        = "serviceAccount:${google_service_account.sa_githubactions_storage.email}"
}

resource "google_project_iam_member" "sa_githubactions_storage_service_account_user_role" {
  project     = var.google_project_id
  role        = "roles/iam.serviceAccountUser"
  member      = "serviceAccount:${google_service_account.sa_githubactions_storage.email}"
}

output "sa_githubactions_storage" {
  value = google_service_account.sa_githubactions_storage
}
