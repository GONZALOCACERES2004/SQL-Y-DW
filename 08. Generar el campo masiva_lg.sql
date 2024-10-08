--8. Generar el campo masiva_lg        

--CREATE OR REPLACE TABLE keepcoding.ivr_masiva_lg AS
SELECT 
  calls_ivr_id,
  MAX(CASE WHEN module_name = 'AVERIA_MASIVA' THEN 1 ELSE 0 END) AS masiva_lg
FROM 
  keepcoding.ivr_detail
GROUP BY 
  calls_ivr_id
ORDER BY 
  calls_ivr_id;
