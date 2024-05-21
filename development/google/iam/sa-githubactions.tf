resource "google_service_account" "sa_githubactions" {
  account_id    = "sa-githubactions-001"
  display_name  = "sa-githubactions"
  description   = "Service account dedicated to be used on github actions pipelines"
}

resource "google_project_iam_member" "sa_githubactions_service_account_user_role" {
  project       = var.google_project_id
  role          = "roles/iam.serviceAccountUser"
  member        = "serviceAccount:${google_service_account.sa_githubactions.email}"
}

output "sa_githubactions" {
  value = google_service_account.sa_githubactions
}
