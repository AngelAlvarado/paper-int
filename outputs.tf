output "pubsub_topic_name" {
  value       = google_pubsub_topic.example_topic.name
  description = "The name of the Pub/Sub topic."
}

output "bigquery_dataset_id" {
  value       = google_bigquery_dataset.example_dataset.dataset_id
  description = "The ID of the BigQuery dataset."
}

output "bigquery_table_id" {
  value       = google_bigquery_table.example_table.table_id
  description = "The ID of the BigQuery table."
}

output "cloud_function_name" {
  value       = google_cloudfunctions_function.function.name
  description = "The name of the deployed Google Cloud Function."
}

output "cloud_function_url" {
  value       = google_cloudfunctions_function.function.https_trigger_url
  description = "The HTTPS trigger URL for the deployed Google Cloud Function."
}

output "cloud_function_service_account_email" {
  value       = google_cloudfunctions_function.function.service_account_email
  description = "The service account email associated with the Google Cloud Function."
}
