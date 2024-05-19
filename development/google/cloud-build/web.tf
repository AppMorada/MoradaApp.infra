resource "google_cloudbuild_trigger" "web_trigger" {
  name        = "trigger-web-trigger-001"
  location    = "global"
  description = "Trigger dedicated to deploy the front-end web service"

  github {
    owner = "AppMorada"
    name  = "MoradaApp.Front"

    push {
      branch = "main"
    }
  }

  service_account = var.sa_cloud_run_manager_id
  ignored_files   = [".gitignore"] 

  build {
    step {
      name = "gcr.io/cloud-builders/docker"
      args = [
        "build", "-t", var.web_lts_image_url,
        "-f", "./Dockerfile", "."
      ]
      env = ["DOCKER_BUILDKIT=1"]
    }

    step {
      name = "gcr.io/cloud-builders/gsutil"
      entrypoint = "gcloud"
      args = [
        "run", "deploy", "web",
        "--region=${var.google_main_region}",
        "--image=${var.web_lts_image_url}"
      ]
    }

    images = [var.web_lts_image_url]
    options {
      logging = "CLOUD_LOGGING_ONLY"
    }
  }

  approval_config {
    approval_required = true
  }
}
