resource "google_artifact_registry_repository" "registry_api_repo" {
  location            = var.location
  mode                = "STANDARD_REPOSITORY"
  repository_id       = "registry-api"
  description         = "Repository of registry api"
  format              = "DOCKER"
 
  cleanup_policy_dry_run  = false 
  labels = {
    type = "artifact-registry",
    service = "registry-api-repo",
    mode = "development"
  }
}

output "registryapi_lts_image_url" {
  value = "${var.location}-docker.pkg.dev/${var.google_project_id}/${google_artifact_registry_repository.registry_api_repo.repository_id}/${google_artifact_registry_repository.registry_api_repo.repository_id}:latest"
}

resource "google_cloud_run_service" "registry_api" {
  name      = "registry-api"
  location  = var.location

  depends_on = [ google_artifact_registry_repository.registry_api_repo ]

  traffic {
    percent = 100
    latest_revision = true
  }

  template {
    metadata {
      labels = {
        type = "cloud-run"
        service = "registry-api"
        mode = "development"
      }
      annotations = {
        "autoscaling.knative.dev/minScale" = "0"
        "autoscaling.knative.dev/maxScale" = "1"
        "run.googleapis.com/startup-cpu-boost" = "true"
        "run.googleapis.com/cpu-throttling" = "true"
      }
    }
    spec {
      service_account_name = var.sa_registryapi_email
      timeout_seconds = 12
      container_concurrency = 20 
     
      containers {
        image = "${var.location}-docker.pkg.dev/${var.google_project_id}/${google_artifact_registry_repository.registry_api_repo.repository_id}/${google_artifact_registry_repository.registry_api_repo.repository_id}:latest"
        ports {
          container_port = 8080
        }

        resources {
          limits = {
            cpu = "1"
            memory = "1Gi"
          }
        }

        env {
          name = "OBSERVER_AGENT"
          value_from {
            secret_key_ref {
              name = var.google_observer_secret_name
              key = "latest"
            }
          }
        }

        env {
          name = "FIRESTORE_DATABASE_ID"
          value = var.firestore_key_db_name
        }

        env {
          name = "PASS_SENDER"
          value_from {
            secret_key_ref {
              name = var.google_email_pass_secret_name
              key = "latest"
            }
          }
        }

        env {
          name = "COOKIE_KEY"
          value_from {
            secret_key_ref {
              name = var.google_cookie_key_secret_name
              key = "latest"
            }
          }
        }

        env {
          name = "DATABASE_URL"
          value_from {
            secret_key_ref {
              name = var.google_database_url_secret_name
              key = "latest"
            }
          }
        }

        env {
          name = "NODE_ENV"
          value = "production"
        }

        env {
          name = "EMAIL_SENDER"
          value = "nicolascbvbot@gmail.com"
        }

        env {
          name = "PROJECT_NAME"
          value = "MoradaApp"
        }

        env {
          name = "FRONT_END_INVITE_URL" 
          value = "https://localhost:3001/invite/"
        }

        env {
          name = "FRONT_END_AUTH_URL"
          value = "https://localhost:3001/auth/"
        }

        env {
          name = "SIGNATURE_TYPE"
          value = "dynamic"
        }

        env {
          name = "HOST_SENDER"
          value = "smtp.gmail.com"
        }

        env {
          name = "HOST_PORT_SENDER"
          value = 587
        }

        env {
          name = "NAME_SENDER"
          value = "MoradaApp"
        }

        env {
          name = "FIRESTORE_GCP_PROJECT"
          value = var.google_project_id
        }

        env {
          name = "MAX_MEMORY_HEAP"
          value = 157286400
        }

        env {
          name = "MAX_MEMORY_RSS"
          value = 283115520
        }

        env {
          name = "INVITE_COMPLEXITY_CODE"
          value = 7
        }

        env {
          name = "SERVICE_NAME"
          value = "registry-api"
        }

        env {
          name = "SERVICE_VERSION"
          value = "0.0.0-experimental"
        }

        env {
          name = "LOGGING_PROJECT"
          value = var.google_observer_project_id
        }

        env {
          name = "TYPEORM_TIMEOUT"
          value = 3000
        }

        env {
          name = "PING_URL"
          value = "https://github.com/AppMorada/MoradaApp.registryApi"
        }

        env {
          name = "NODE_OPTIONS"
          value = "--enable-source-maps"
        }
      }
    }
  }
}

resource "google_cloud_run_service_iam_member" "registry_api_invoker" {
  location = var.location
  project = google_cloud_run_service.registry_api.project
  service = google_cloud_run_service.registry_api.name
  role = "roles/run.invoker"
  member = "allUsers"
  depends_on = [ google_cloud_run_service.registry_api ]
}
