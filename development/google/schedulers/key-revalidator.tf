variable "update_key_url" {
  type = string
}

variable "update_key_region" {
  type = string
}

resource "google_cloud_scheduler_job" "key_revalidator_sch" {
  name          = "keyRevalidatorSch"
  description   = "Scheduler dedicated on update keys in registry module"
  schedule      = "0 * * * *"
  time_zone     = "America/Sao_Paulo"
  region        = var.update_key_region

  http_target {
    http_method = "PATCH"
    uri = var.update_key_url
  }

  retry_config {
    max_retry_duration = "0s"
    min_backoff_duration = "5s"
    max_backoff_duration = "3600s"
    max_doublings = 5
    retry_count = 5
  }

  attempt_deadline = "180s"
}
