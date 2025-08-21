{{
    config(
        materialized='table'
    )
}}
SELECT
    TRIM(name_raw) AS Name,
    TRIM(REGEXP_REPLACE(address_raw,'\\s+',' ')) as Address,
    INITCAP(TRIM(t.city_raw)) AS City,
    CONCAT(TRIM(name_raw), ' ', INITCAP(TRIM(t.city_raw))) AS FullName,
    see.state_raw AS State,
    postal_code_raw AS PostalCode,
    lower(email_raw) AS Email_ID,
    REGEXP_REPLACE(phone_raw,'[^0-9+]','') AS Phone,    --Remove spaces, dashes, brackets, etc
    CASE
    -- Normalize the number (remove all non-digits except +)
    WHEN REGEXP_LIKE(REGEXP_REPLACE(phone_raw, '[^0-9]', ''), '^91[0-9]{10}$') THEN
        '+91-' || RIGHT(REGEXP_REPLACE(phone_raw, '[^0-9]', ''), 10)

    WHEN LENGTH(REGEXP_REPLACE(phone_raw, '[^0-9]', '')) = 10 THEN
        '+91-' || REGEXP_REPLACE(phone_raw, '[^0-9]', '')
    ELSE 'Not Indian Number'
END AS Contact_Number,
    sku_raw,
    description_raw,
    notes_raw,
    notes_raw_b64,
    tags_csv,
    json_profile,
    code_mixed,
    LTRIM(padded_left_raw) As Padded_Left,
    RTRIM(padded_right_raw) AS Padded_Right,
    multilingual_raw,
    amount,
    quantity,
    discount_pct
from {{ ref('ing_data') }} t
join {{ ref('state_mapping') }} see
on t.city_raw = see.city_raw