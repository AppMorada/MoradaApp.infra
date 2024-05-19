resource "google_cloudbuild_trigger" "registry-api-trigger" {
  name      = "trigger-registry-api-001"
  location  = "global"
  description = "Trigger dedicated to deploy the registry api images"

  github {
    owner = "AppMorada"
    name = "MoradaApp.registryApi"

    push {
      branch = "release/*"
    }
  }

  service_account = var.sa_cloud_run_manager_id
  ignored_files   = [".gitignore"]

  build {
    step {
     name = "gcr.io/cloud-builders/docker"
     args = [
       "build", "-t", var.registryapi_lts_image_url,
       "-f", "./Dockerfile.prod", "."
     ]
     env = ["DOCKER_BUILDKIT=1"]
    }

    step {
      name = "gcr.io/cloud-builders/gsutil"
      entrypoint = "gcloud"
      args = [
        "run", "deploy", "registry-api",
        "--region=${var.google_main_region}",
        "--image=${var.registryapi_lts_image_url}"
      ]
    }

    images = [var.registryapi_lts_image_url]
    options {
      logging = "CLOUD_LOGGING_ONLY"
    }
  }

  approval_config {
    approval_required = true
  }
}
