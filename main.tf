resource "google_pubsub_topic" "example_topic" {
  name = "example-topic"
}

resource "google_bigquery_dataset" "silver_example_dataset" {
  dataset_id                  = "silver_example"
  location                    = "US"
  delete_contents_on_destroy  = false
}

resource "google_bigquery_dataset" "example_dataset" {
  dataset_id                  = "example_dataset"
  location                    = "US"
  delete_contents_on_destroy  = false
}

resource "google_bigquery_table" "example_table" {
  dataset_id = google_bigquery_dataset.example_dataset.dataset_id
  table_id   = "example_table"

  schema = jsonencode([
    {
        "name": "id",
        "type": "STRING",
        "mode": "REQUIRED"
    },
    {
        "name": "message",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "timestamp",
        "type": "TIMESTAMP",
        "mode": "NULLABLE"
    }
    ])
}

resource "google_storage_bucket" "bucket" {
  name          = "${var.project_id}-functions"
  location      = var.region
  force_destroy = true
}

resource "google_storage_bucket_object" "function_code" {
  name   = "cloud-function-code.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./source_code/cloud-function-code.zip"
}

resource "google_cloudfunctions_function" "function" {
  name                  = "pubsub-to-bigquery"
  description           = "Processes messages from Pub/Sub and writes to BigQuery."
  runtime               = "python39"
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.function_code.name
  entry_point           = "pubsub_to_bigquery"
  timeout               = 61
  project               = var.project_id
  region                = var.region
  
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.example_topic.id
  }

  environment_variables = {
    BIGQUERY_DATASET = var.dataset_id
    BIGQUERY_TABLE   = var.table_id
  }
}

resource "google_project_iam_member" "function_pubsub_subscriber" {
  role    = "roles/pubsub.subscriber"
  member  = "serviceAccount:${google_cloudfunctions_function.function.service_account_email}"
  project = var.project_id
}

resource "google_project_iam_member" "function_bigquery_dataEditor" {
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_cloudfunctions_function.function.service_account_email}"
  project = var.project_id
}
