variable "google_project_id" {
  type  = string
}

variable "google_main_region" {
  type  = string
}

resource "google_firestore_database" "key_db" {
  project           = var.google_project_id
  name              = "firestoredb-key-001"
  location_id       = var.google_main_region
  type              = "FIRESTORE_NATIVE"
  concurrency_mode  = "PESSIMISTIC"
  delete_protection_state   = "DELETE_PROTECTION_ENABLED"
  deletion_policy   = "DELETE" 
}

resource "google_firestore_backup_schedule" "weekly-backup" {
  depends_on        = [ google_firestore_database.key_db ]
  project           = var.google_project_id
  database          = google_firestore_database.key_db.name
  retention         = "8467200s"

  weekly_recurrence {
    day = "SUNDAY"
  }
}


output "key_db" {
  value = google_firestore_database.key_db
}
