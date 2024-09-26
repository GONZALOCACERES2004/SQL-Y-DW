--3.CREAR TABLA DE ivr_detail.
  
CREATE OR REPLACE TABLE `keepcoding.ivr_detail` AS
SELECT
  CAST(c.ivr_id AS STRING) AS calls_ivr_id,
  c.phone_number AS calls_phone_number,
  c.ivr_result AS calls_ivr_result,
  c.vdn_label AS calls_vdn_label,
  c.start_date AS calls_start_date,
  CAST(FORMAT_DATE('%Y%m%d', c.start_date) AS INT64) AS calls_start_date_id,
  c.end_date AS calls_end_date,
  CAST(FORMAT_DATE('%Y%m%d', c.end_date) AS INT64) AS calls_end_date_id,
  c.total_duration AS calls_total_duration,
  c.customer_segment AS calls_customer_segment,
  c.ivr_language AS calls_ivr_language,
  c.steps_module AS calls_steps_module,
  c.module_aggregation AS calls_module_aggregation,
  m.module_sequece,
  m.module_name,
  m.module_duration,
  m.module_result,
  s.step_sequence,
  s.step_name,
  s.step_result,
  s.step_description_error,
  s.document_type AS step_document_type,
  s.document_identification AS step_document_identification,
  s.customer_phone AS step_customer_phone,
  s.billing_account_id AS step_billing_account_id
FROM 
  `keepcoding.ivr_calls` c
LEFT JOIN 
  `keepcoding.ivr_modules` m ON c.ivr_id = m.ivr_id
LEFT JOIN 
  `keepcoding.ivr_steps` s ON c.ivr_id = s.ivr_id AND m.module_sequece = s.module_sequece;