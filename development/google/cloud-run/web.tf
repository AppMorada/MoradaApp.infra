resource "google_artifact_registry_repository" "web_repo" {
  location                = var.location
  mode                    = "STANDARD_REPOSITORY"
  repository_id           = "web"
  description             = "Repository of front-end web"
  format                  = "DOCKER"

  cleanup_policy_dry_run  = false 
  labels = {
    type = "artifact-registry"
    service = "web-repo"
    mode = "development"
  }
}

resource "google_cloud_run_service" "web" {
  name          = "web"
  location      = var.location

  depends_on = [ google_artifact_registry_repository.web_repo ]
  traffic {
    percent = 100
    latest_revision = true
  }

  template {
    metadata {
      labels = {
        type = "cloud-run"
        service = "web"
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
      service_account_name = var.sa_web_email
      timeout_seconds = 12
      container_concurrency = 20

      containers {
        image = "${var.location}-docker.pkg.dev/${var.google_project_id}/${google_artifact_registry_repository.web_repo.repository_id}/${google_artifact_registry_repository.web_repo.repository_id}:latest"
        ports {
          container_port = 8080
        }

        resources {
          limits = {
            cpu = "1"
            memory = "512Mi"
          }
        }
      }
    }
  }
}

resource "google_cloud_run_service_iam_member" "web_invoker" {
  location = var.location
  project = google_artifact_registry_repository.web_repo.project
  service = google_artifact_registry_repository.web_repo.name
  role = "roles/run.invoker"
  member = "allUsers"
  depends_on = [ google_artifact_registry_repository.web_repo ]
}

output "web_lts_image_url" {
  value = "${var.location}-docker.pkg.dev/${var.google_project_id}/${google_artifact_registry_repository.web_repo.repository_id}/${google_artifact_registry_repository.web_repo.repository_id}:latest"
}
