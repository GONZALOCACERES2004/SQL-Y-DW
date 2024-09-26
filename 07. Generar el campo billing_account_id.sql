--7. Generar el campo billing_account_id

--CREATE OR REPLACE TABLE keepcoding.ivr_billing_account_id AS
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
ORDER BY 
  calls_ivr_id;
