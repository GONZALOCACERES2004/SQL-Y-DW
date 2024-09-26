--4.Generar el campo vdn_aggregation

--CREATE OR REPLACE TABLE keepcoding.ivr_vdn_aggregation AS
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
ORDER BY 
  calls_ivr_id;  
