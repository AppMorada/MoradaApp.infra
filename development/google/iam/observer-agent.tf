resource "google_service_account" "sa_observer_agent" {
  account_id      = "sa-observer-agent-001"
  display_name    = "sa-observer-agent"
  description     = "Service account dedicated to be used on logs, error reporting and traces"
}

resource "google_project_iam_member" "sa_observer_agent_trace_role" {
  project       = var.google_observer_project_id
  role          = "roles/cloudtrace.agent"
  member          = "serviceAccount:${google_service_account.sa_observer_agent.email}"
}

resource "google_project_iam_member" "sa_observer_agent_errorreporting_role" {
  project       = var.google_observer_project_id
  role          = "roles/errorreporting.writer"
  member          = "serviceAccount:${google_service_account.sa_observer_agent.email}"
}

resource "google_service_account_key" "sa_observer_agent_key" {
  service_account_id      =   google_service_account.sa_observer_agent.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

output "sa_observer_agent" {
  value = google_service_account.sa_observer_agent
}

output "sa_observer_agent_key" {
  value = base64decode(google_service_account_key.sa_observer_agent_key.private_key)
}
