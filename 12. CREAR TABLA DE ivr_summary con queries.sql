
--12. CREAR TABLA DE ivr_summary con consultas

CREATE OR REPLACE TABLE keepcoding.ivr_summary AS
WITH vdn_aggregation AS (
  SELECT 
    calls_ivr_id,
    CASE
      WHEN STARTS_WITH(calls_vdn_label, 'ATC') THEN 'FRONT'
      WHEN STARTS_WITH(calls_vdn_label, 'TECH') THEN 'TECH'
      WHEN calls_vdn_label = 'ABSORPTION' THEN 'ABSORPTION'
      ELSE 'RESTO'
    END AS vdn_aggregation
  FROM 
    keepcoding.ivr_detail
  QUALIFY 
    ROW_NUMBER() OVER (
      PARTITION BY calls_ivr_id 
      ORDER BY 
        CASE WHEN calls_vdn_label IS NOT NULL THEN 0 ELSE 1 END,
        step_sequence DESC
    ) = 1
),
document_identification AS (
  SELECT 
    calls_ivr_id,
    step_document_type AS document_type,
    step_document_identification AS document_identification
  FROM 
    keepcoding.ivr_detail
  QUALIFY 
    ROW_NUMBER() OVER (
      PARTITION BY calls_ivr_id 
      ORDER BY 
        CASE 
          WHEN step_document_type NOT IN ('UNKNOWN', 'DESCONOCIDO') THEN 0 
          ELSE 1 
        END,
        CASE 
          WHEN step_document_identification NOT IN ('UNKNOWN', 'DESCONOCIDO') THEN 0 
          ELSE 1 
        END,
        step_sequence DESC
    ) = 1
),
customer_phone AS (
  SELECT 
    calls_ivr_id,
    step_customer_phone AS customer_phone
  FROM 
    keepcoding.ivr_detail
  QUALIFY 
    ROW_NUMBER() OVER (
      PARTITION BY calls_ivr_id 
      ORDER BY 
        CASE 
          WHEN step_customer_phone NOT IN ('UNKNOWN', 'DESCONOCIDO') THEN 0 
          ELSE 1 
        END,      
        step_sequence DESC
    ) = 1
),
billing_account_id AS (
  SELECT 
    calls_ivr_id,
    step_billing_account_id AS billing_account_id  
  FROM 
    keepcoding.ivr_detail
  QUALIFY 
    ROW_NUMBER() OVER (
      PARTITION BY calls_ivr_id 
      ORDER BY 
        CASE 
          WHEN step_billing_account_id NOT IN ('UNKNOWN', 'DESCONOCIDO') THEN 0 
          ELSE 1 
        END,      
        step_sequence DESC
    ) = 1
),
masiva_lg AS (
  SELECT 
    calls_ivr_id,
    MAX(CASE WHEN module_name = 'AVERIA_MASIVA' THEN 1 ELSE 0 END) AS masiva_lg
  FROM 
    keepcoding.ivr_detail
  GROUP BY 
    calls_ivr_id
),
info_by_phone_lg AS (
  SELECT 
    calls_ivr_id,
    MAX(CASE 
      WHEN step_name = 'CUSTOMERINFOBYPHONE.TX' 
       AND step_description_error = 'UNKNOWN'
      THEN 1 
      ELSE 0 
    END) AS info_by_phone_lg
  FROM 
    keepcoding.ivr_detail
  GROUP BY 
    calls_ivr_id
),
info_by_dni_lg AS (
  SELECT 
    calls_ivr_id,
    MAX(CASE 
      WHEN step_name = 'CUSTOMERINFOBYDNI.TX' 
       AND step_description_error = 'UNKNOWN'
      THEN 1 
      ELSE 0 
    END) AS info_by_dni_lg
  FROM 
    keepcoding.ivr_detail
  GROUP BY 
    calls_ivr_id
),
phone_24h AS (
  WITH call_times AS (
    SELECT 
      calls_ivr_id,
      calls_phone_number,
      calls_start_date,
      LAG(calls_start_date) OVER (PARTITION BY calls_phone_number ORDER BY calls_start_date) AS prev_call,
      LEAD(calls_start_date) OVER (PARTITION BY calls_phone_number ORDER BY calls_start_date) AS next_call
    FROM 
      keepcoding.ivr_detail
    GROUP BY 
      calls_ivr_id, calls_phone_number, calls_start_date
  )
  SELECT 
    d.calls_ivr_id,
    CASE 
      WHEN d.calls_phone_number = 'UNKNOWN' THEN 0
      ELSE MAX(CASE 
        WHEN TIMESTAMP_DIFF(ct.calls_start_date, ct.prev_call, HOUR) <= 24 
        THEN 1 
        ELSE 0 
      END)
    END AS repeated_phone_24H,
    CASE 
      WHEN d.calls_phone_number = 'UNKNOWN' THEN 0
      ELSE MAX(CASE 
        WHEN TIMESTAMP_DIFF(ct.next_call, ct.calls_start_date, HOUR) <= 24 
        THEN 1 
        ELSE 0 
      END)
    END AS cause_recall_phone_24H
  FROM 
    keepcoding.ivr_detail d
  LEFT JOIN 
    call_times ct ON d.calls_ivr_id = ct.calls_ivr_id
  GROUP BY 
    d.calls_ivr_id, d.calls_phone_number
)
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
  vdn_aggregation va ON d.calls_ivr_id = va.calls_ivr_id
LEFT JOIN 
  document_identification di ON d.calls_ivr_id = di.calls_ivr_id
LEFT JOIN 
  customer_phone cp ON d.calls_ivr_id = cp.calls_ivr_id
LEFT JOIN 
  billing_account_id ba ON d.calls_ivr_id = ba.calls_ivr_id
LEFT JOIN 
  masiva_lg m ON d.calls_ivr_id = m.calls_ivr_id
LEFT JOIN 
  info_by_phone_lg ip ON d.calls_ivr_id = ip.calls_ivr_id
LEFT JOIN 
  info_by_dni_lg id ON d.calls_ivr_id = id.calls_ivr_id
LEFT JOIN 
  phone_24h p24 ON d.calls_ivr_id = p24.calls_ivr_id
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
