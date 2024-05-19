resource "google_secret_manager_secret" "cookie_key" {
  secret_id     = "COOKIE_KEY"
  labels = {
    module = "registry"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "cookie_key_latest" {
  secret      = google_secret_manager_secret.cookie_key.id
  secret_data = var.google_dev_cookie_key
  deletion_policy = "DELETE"
}

resource "google_secret_manager_secret_iam_member" "cookie_key_sa_registryapi_iam_member" {
  project     = google_secret_manager_secret.cookie_key.project
  secret_id   = google_secret_manager_secret.cookie_key.id 
  role        = "roles/secretmanager.secretAccessor"
  member      = "serviceAccount:${var.sa_registryapi_email}"
}

output "cookie_key" {
  value = google_secret_manager_secret.cookie_key
}

output "cookie_key_name" {
  value = "COOKIE_KEY"
}
