{% macro test_messages(custom_schema_name, node) -%}
    { setup_data_messages() }
    set sql = 'select count(*) from ..messages into ... '
    sql.run_query()

    sql.results == 2
    { delete_data_messages() }
{%- endmacro %}

{% macro setup_data_messages(custom_schema_name, node) -%}
    set sql = 'insert into ... 2 records'
    sql.run_query()
{%- endmacro %}

{% macro delete_data_messages(custom_schema_name, node) -%}
    set sql = 'delete from messages'
    sql.run_query()
{%- endmacro %}
