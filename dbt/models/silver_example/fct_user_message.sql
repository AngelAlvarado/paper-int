{{
    config(
        schema = 'silver_example',
        materialized = 'table'
    )
}}

WITH ranked_messages AS (
    SELECT
        message_id,
        user.user_id,
        direction,
        ROW_NUMBER() OVER (PARTITION BY user.user_id ORDER BY timestamp DESC) as rn
    FROM
        {{ source('example_dataset', 'bronze_user_messages') }}
)

SELECT
    message_id,
    user_id,
    direction
FROM
    ranked_messages
WHERE
    rn = 1
