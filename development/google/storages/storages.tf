resource "google_storage_bucket" "cloud_functions_bucket" {
  name                      = "cloud-functions-bucket-001"
  location                  = "us-east1"
  public_access_prevention  = "enforced"
  storage_class             = "STANDARD"
  labels = {
    type = "bucket",
    service = "cloud-functions-bucket",
    mode = "development"
  }

  soft_delete_policy {
    retention_duration_seconds = 604800
  }

  versioning {
    enabled     = true
  }
}

output "cloud_functions_bucket" {
  value = google_storage_bucket.cloud_functions_bucket
}
