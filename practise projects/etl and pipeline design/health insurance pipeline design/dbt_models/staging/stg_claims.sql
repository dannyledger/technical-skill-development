
SELECT 
    claim_id,
    member_id,
    provider_id,
    claim_date::DATE AS claim_date,
    amount::NUMERIC,
    diagnosis_code,
    CASE 
        WHEN amount > 4000 OR diagnosis_code IN ('D999','FRAUD01') 
        THEN TRUE ELSE FALSE 
    END AS fraud_flag,
    status
FROM {{ source('raw','claims') }};
