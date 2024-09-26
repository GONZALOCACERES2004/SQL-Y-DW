--5 Generar los campos document_type y document_identification
 
--CREATE OR REPLACE TABLE keepcoding.ivr_document_identification AS
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
ORDER BY 
  calls_ivr_id;
