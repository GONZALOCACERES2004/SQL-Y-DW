--12. CREAR TABLA DE ivr_summary con tablas intermedias

CREATE OR REPLACE TABLE keepcoding.ivr_summary AS
SELECT
  d.calls_ivr_id AS ivr_id,
  d.calls_phone_number AS phone_number,
  d.calls_ivr_result AS ivr_result,
  va.vdn_aggregation,
  MIN(d.calls_start_date) AS start_date,
  MAX(d.calls_end_date) AS end_date,
  MAX(d.calls_total_duration) AS total_duration,
  MAX(d.calls_customer_segment) AS customer_segment,
  MAX(d.calls_ivr_language) AS ivr_language,
  COUNT(DISTINCT d.module_sequece) AS steps_module,
  STRING_AGG(DISTINCT d.module_name, ', ' ORDER BY d.module_name) AS module_aggregation,
  di.document_type,
  di.document_identification,
  cp.customer_phone,
  ba.billing_account_id,
  m.masiva_lg,
  ip.info_by_phone_lg,
  id.info_by_dni_lg,
  p24.repeated_phone_24H,
  p24.cause_recall_phone_24H
FROM 
  keepcoding.ivr_detail d
LEFT JOIN 
  keepcoding.ivr_vdn_aggregation va ON d.calls_ivr_id = va.calls_ivr_id
LEFT JOIN 
  keepcoding.ivr_document_identification di ON d.calls_ivr_id = di.calls_ivr_id
LEFT JOIN 
  keepcoding.ivr_customer_phone cp ON d.calls_ivr_id = cp.calls_ivr_id
LEFT JOIN 
  keepcoding.ivr_billing_account_id ba ON d.calls_ivr_id = ba.calls_ivr_id
LEFT JOIN 
  keepcoding.ivr_masiva_lg m ON d.calls_ivr_id = m.calls_ivr_id
LEFT JOIN 
  keepcoding.ivr_info_by_phone_lg ip ON d.calls_ivr_id = ip.calls_ivr_id
LEFT JOIN 
  keepcoding.ivr_info_by_dni_lg id ON d.calls_ivr_id = id.calls_ivr_id
LEFT JOIN 
  keepcoding.ivr_phone_24h p24 ON d.calls_ivr_id = p24.calls_ivr_id
GROUP BY
  d.calls_ivr_id,
  d.calls_phone_number,
  d.calls_ivr_result,
  va.vdn_aggregation,
  di.document_type,
  di.document_identification,
  cp.customer_phone,
  ba.billing_account_id,
  m.masiva_lg,
  ip.info_by_phone_lg,
  id.info_by_dni_lg,
  p24.repeated_phone_24H,
  p24.cause_recall_phone_24H
ORDER BY
  d.calls_ivr_id;