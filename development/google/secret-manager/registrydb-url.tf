resource "google_secret_manager_secret" "registrydb_dev_url" {
  secret_id       = "REGISTRYDB_DEV_URL"
  labels  = {
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

resource "google_secret_manager_secret_version" "registrydb_dev_url_latest" {
  secret            = google_secret_manager_secret.registrydb_dev_url.id
  secret_data       = var.registrydb_dev_url
  deletion_policy   = "DELETE"
}

resource "google_secret_manager_secret_iam_member" "registrydb_dev_url_sa_fm_iam_member" {
  project     = google_secret_manager_secret.registrydb_dev_url.project
  secret_id   = google_secret_manager_secret.registrydb_dev_url.id
  role        = "roles/secretmanager.secretAccessor"
  member      = "serviceAccount:${var.sa_function_manager_email}"
}

resource "google_secret_manager_secret_iam_member" "registrydb_dev_url_sa_registryapi_iam_member" {
  project     = google_secret_manager_secret.registrydb_dev_url.project
  secret_id   = google_secret_manager_secret.registrydb_dev_url.id
  role        = "roles/secretmanager.secretAccessor"
  member      = "serviceAccount:${var.sa_registryapi_email}"
}

output "registrydb_dev_url" {
  value = google_secret_manager_secret.registrydb_dev_url
}

output "registrydb_dev_url_name" {
  value = "REGISTRYDB_DEV_URL"
}
