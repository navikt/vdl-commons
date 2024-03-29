{% macro create_masking_policy_mask_raw_variant(node_database,node_schema) %}

CREATE MASKING POLICY IF NOT EXISTS  {{node_database}}.{{node_schema}}.mask_raw_variant AS (val VARIANT) 
  RETURNS VARIANT ->
      CASE WHEN CURRENT_ROLE() IN ('commons_transformer','commons_loader' ) THEN val 
      ELSE NULL
      END 

{% endmacro %}
