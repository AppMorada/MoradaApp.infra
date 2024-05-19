resource "google_cloudbuild_trigger" "key-manager-trigger" {
  name      = "trigger-key-manager-001"
  location  = "global"
  description = "Trigger dedicated to deploy createKeyFnc and updateKeyFnc function"

  github {
    owner = "AppMorada"
    name  = "MoradaApp.keyManager"

    push {
      branch  = "release/*"
    }
  }

  service_account = var.sa_function_manager_id
  ignored_files   = [".gitignore"]

  build {
    step {
      name = "node:lts-bullseye-slim"
      entrypoint = "bash"
      args = ["-c", "./build-project.sh"]
    }

    step {
      name = "gcr.io/cloud-builders/gsutil"
      entrypoint = "bash"
      args = ["-c", "./push-to-storage.sh keyFunc 001"]
      env = ["BUCKET_PATH=gs://cloud-functions-bucket-001"]
      timeout = "120s"
    }

    step {
      name = "gcr.io/google.com/cloudsdktool/cloud-sdk:alpine"
      entrypoint = "gcloud"
      args = [
        "functions", "deploy", "createKeyFunc",
        "--project=${var.google_project_id}",
        "--trigger-http",
        "--runtime=nodejs20",
        "--region=${var.google_main_region}",
        "--security-level=secure-always"
      ]
    }

    step {
      name = "gcr.io/google.com/cloudsdktool/cloud-sdk:alpine"
      entrypoint = "gcloud"
      args = [
        "functions", "deploy", "updateKeyFunc",
        "--project=${var.google_project_id}",
        "--trigger-http",
        "--runtime=nodejs20",
        "--region=${var.google_main_region}",
        "--security-level=secure-always"
      ]
    }

    options {
      logging = "CLOUD_LOGGING_ONLY"
    }
  }

  approval_config {
    approval_required = true
  }
}

