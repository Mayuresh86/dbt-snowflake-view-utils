{% macro update_view_ddl(Schema_A) %}

    {% set etl_schema = target.schema %}
    {% set db = target.database %}
    {% do log("Updating view's DDL in "+ Schema_A+" to change table pointer from  " + etl_schema + " to " + Schema_A, info=True) %}

    {% set get_views_sql %}
        SELECT TABLE_NAME, VIEW_DEFINITION
        FROM {{db}}.INFORMATION_SCHEMA.VIEWS
        WHERE TABLE_SCHEMA ilike '{{ etl_schema }}'
        AND TABLE_CATALOG ilike '{{ db }}'
    {% endset %}
    {% set results = run_query(get_views_sql) %}
    
    {% if execute %}
        {% set views_to_repoint = results.rows %}
    {% else %}
        {% set views_to_repoint = [] %}
    {% endif %}

    {% for view in views_to_repoint %}
        {% set view_name = view[0] %}
        {% set view_ddl = view[1] %}
        {% set updated_ddl = view_ddl | replace(db ~ '.' ~ etl_schema ~ '.', db ~ '.' ~ Schema_A ~ '.') %}
        
        {% set create_or_replace_sql %}
        {{ updated_ddl }}
        {% endset %}

        --{% do log("Repointing view: " ~ view_name, info=True) %}
        --{% do log("Original DDL: " ~ view_ddl, info=True) %}
        --{% do log("Updated DDL: " ~ updated_ddl, info=True) %}
        {% do run_query(create_or_replace_sql) %}
    {% endfor %}
{% endmacro %}