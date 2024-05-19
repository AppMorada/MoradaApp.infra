resource "google_secret_manager_secret" "observer_agent" {
  secret_id   = "OBSERVER_AGENT"
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

resource "google_secret_manager_secret_version" "observer_agent_latest" {
  secret            = google_secret_manager_secret.observer_agent.id
  secret_data       = var.sa_observer_agent_key 
  deletion_policy   = "DELETE" 
}

resource "google_secret_manager_secret_iam_member" "observer_agent_sa_fm_iam_member" {
  project     = google_secret_manager_secret.observer_agent.project
  secret_id   = google_secret_manager_secret.observer_agent.id
  role        = "roles/secretmanager.secretAccessor"
  member      = "serviceAccount:${var.sa_function_manager_email}"
}

resource "google_secret_manager_secret_iam_member" "observer_agent_sa_registryapi_iam_member" {
  project     = google_secret_manager_secret.observer_agent.project
  secret_id   = google_secret_manager_secret.observer_agent.id
  role        = "roles/secretmanager.secretAccessor"
  member      = "serviceAccount:${var.sa_registryapi_email}"
}

output "observer_agent" {
  value = google_secret_manager_secret.observer_agent
}

output "observer_agent_name" {
  value = "OBSERVER_AGENT"
}
