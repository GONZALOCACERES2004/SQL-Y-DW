--6. Generar el campo customer_phone

--CREATE OR REPLACE TABLE keepcoding.ivr_customer_phone AS
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
ORDER BY 
  calls_ivr_id;  
