{{
    config(
        schema = 'silver_example',
        materialized='table',
    )
}}

WITH ranked_messages AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY timestamp DESC) as rn
    FROM
        {{ source('example_dataset','example_table') }}
)

SELECT
    id,
    message,
    timestamp
FROM
    ranked_messages
WHERE
    rn = 1
