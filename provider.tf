# Provider configuration
provider "google" {
  credentials = file("/home/angelalvarado/Documents/paper/shining-reality-375617-b787102c87aa.json")
  project     = var.project_id
  region      = var.region
}

variable "project_id" {
  default = "shining-reality-375617"
}
variable "region" {
  default = "us-west1"
}

variable "topic_name" {
  default = "example-topic"
}

variable "dataset_id" {
  default = "example_dataset"
}

variable "table_id" {
  default = "example_table"
}