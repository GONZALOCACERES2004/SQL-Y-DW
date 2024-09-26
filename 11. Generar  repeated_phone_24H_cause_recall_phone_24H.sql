--11.Generar los campos repeated_phone_24H, cause_recall_phone_24H

--CREATE OR REPLACE TABLE keepcoding.ivr_phone_24h AS
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
  d.calls_phone_number,
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
ORDER BY 
  d.calls_ivr_id;
