resource "google_secret_manager_secret" "email_pass" {
  secret_id     = "EMAIL_PASS"
  labels = {
    module = "email"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "email_pass_latest" {
  secret      = google_secret_manager_secret.email_pass.id
  secret_data = var.google_dev_email_pass
  deletion_policy = "DELETE"
}

resource "google_secret_manager_secret_iam_member" "email_pass_iam_member" {
  project       = google_secret_manager_secret.email_pass.project
  secret_id     = google_secret_manager_secret.email_pass.id
  role        = "roles/secretmanager.secretAccessor"
  member      = "serviceAccount:${var.sa_registryapi_email}"
}


output "email_pass" {
  value = google_secret_manager_secret.email_pass
}

output "email_pass_name" {
  value = "EMAIL_PASS"
}
