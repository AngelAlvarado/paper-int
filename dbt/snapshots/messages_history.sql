{% snapshot messages_history %}

{{
    config(
        target_schema = 'silver_example',
        unique_key = 'id',
        strategy = 'check',
        check_cols = ['message']
    )
}}

SELECT
    id,
    message,
    timestamp
FROM
    {{ ref('latest_messages') }}

{% endsnapshot %}
