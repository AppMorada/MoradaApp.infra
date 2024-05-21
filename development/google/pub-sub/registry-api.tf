resource "google_pubsub_topic" "delete_condominium" {
  name      = "delete_condominium"

  labels = {
    type = "pub-sub"
    service = "registry-api"
    mode = "development"
  }

  message_retention_duration = "259200s"
}

resource "google_pubsub_topic" "delete_member" {
  name      = "delete_member"

  labels = {
    type = "pub-sub"
    service = "registry-api"
    mode = "development"
  }

  message_retention_duration = "259200s"
}

resource "google_pubsub_topic" "delete_user" {
  name      = "delete_user"

  labels = {
    type = "pub-sub"
    service = "registry-api"
    mode = "development"
  }

  message_retention_duration = "259200s"
}
