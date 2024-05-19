resource "google_service_account" "sa_web" {
  account_id      = "sa-web-001"
  display_name    = "sa-web"
  description     = "Service account dedicated to be used on front-end web service"
}

resource "google_project_iam_member" "sa_web_logging_role" {
  project         = var.google_project_id
  role            = "roles/logging.logWriter"
  member          = "serviceAccount:${google_service_account.sa_web.email}"
}

resource "google_project_iam_member" "sa_web_service_account_user_role" {
  project         = var.google_project_id
  role            = "roles/iam.serviceAccountUser"
  member          = "serviceAccount:${google_service_account.sa_web.email}"
}

output "sa_web" {
  value = google_service_account.sa_web
}
