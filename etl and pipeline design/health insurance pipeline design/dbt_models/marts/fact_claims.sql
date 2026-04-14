
SELECT
    c.claim_id,
    c.claim_date,
    c.amount,
    c.fraud_flag,
    m.plan_type,
    p.city AS provider_city
FROM {{ ref('stg_claims') }} c
JOIN {{ ref('stg_members') }} m USING (member_id)
JOIN {{ ref('stg_providers') }} p USING (provider_id);
