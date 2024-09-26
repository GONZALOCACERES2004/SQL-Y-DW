--10.Generar el campo info_by_dni_lg

--CREATE OR REPLACE TABLE keepcoding.ivr_info_by_dni_lg AS
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
ORDER BY 
  calls_ivr_id;
