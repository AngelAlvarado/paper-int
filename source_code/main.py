import base64
import json
from google.cloud import bigquery

def pubsub_to_bigquery(event, context):
    """Background Cloud Function to be triggered by Pub/Sub.
    Args:
        event (dict): The dictionary with data specific to this type of event.
        context (google.cloud.functions.Context): Metadata for the event.
    """
    pubsub_message = base64.b64decode(event['data']).decode('utf-8')
    message_dict = json.loads(pubsub_message)

    # Create a BigQuery client
    client = bigquery.Client()

    # Configured via environment variables or directly in the code
    dataset_id = 'example_dataset'  # Actual dataset ID
    table_id = 'example_table'      # Actual table ID
    table_ref = client.dataset(dataset_id).table(table_id)
    table = client.get_table(table_ref)  # Make an API request.

    # The row to insert, matching the BigQuery schema
    row_to_insert = [{
        "id": message_dict.get("id"),
        "message": message_dict.get("message"),
        "timestamp": message_dict.get("timestamp")
    }]

    errors = client.insert_rows_json(table, row_to_insert)  # Make an API request.
    if errors == []:
        print("New rows have been added.")
    else:
        print("Encountered errors while inserting rows:", errors)