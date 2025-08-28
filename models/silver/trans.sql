{{ config(materialized="table") }}

SELECT

    -- Trim leading and trailing spaces from the 'name_raw' field
    TRIM(name_raw) AS Name,

    -- Concatenate trimmed name_raw, a space, and capitalized city_raw to form FullName
    CONCAT(TRIM(name_raw), ' ', INITCAP(TRIM(t.city_raw))) AS FullName,

    -- Replace multiple whitespace characters with a single space, then trim leading/trailing whitespace from address_raw
    TRIM(REGEXP_REPLACE(address_raw, '\\s+', ' ')) AS Address,

    -- Trim city_raw and capitalize the first letter of each word in the city
    INITCAP(TRIM(t.city_raw)) AS City,

    -- Calculate the character count of the trimmed city_raw field
    LENGTH(TRIM(T.city_raw)) AS character_Count,

    -- Get the state from the joined state_mapping table based on city name
    see.state_raw AS State,

    -- Select postal code, converting to a number (validating that it's numeric)
    TO_NUMBER(postal_code_raw) AS Postal_Code,

    -- Extract first 3 digits of postal_code_raw as the postal area
    SUBSTR(postal_code_raw,1,3) AS Postal_Area,

    -- Convert email_raw to lowercase for standardization
    LOWER(email_raw) AS Email_ID,
    MD5(email_raw) AS Email_Hash,

    -- Find '@' position in email_raw to slice the local part from the domain
    lower(SUBSTR(email_raw,1,POSITION('@' IN email_raw)-1)) AS LocalPart,

    -- Extract the domain part of the email
    SUBSTR(email_raw,POSITION('@' IN email_raw)+1) AS DomainPart,

    -- Normalize phone number to Indian format if possible, else mark as 'Not Indian Number'
    CASE
        WHEN REGEXP_LIKE(REGEXP_REPLACE(phone_raw, '[^0-9]', ''), '^91[0-9]{10}$') THEN
            '+91-' || RIGHT(REGEXP_REPLACE(phone_raw, '[^0-9]', ''), 10)
        WHEN LENGTH(REGEXP_REPLACE(phone_raw, '[^0-9]', '')) = 10 THEN
            '+91-' || REGEXP_REPLACE(phone_raw, '[^0-9]', '')
        ELSE 'Not Indian Number'
    END AS Contact_Number,

    -- Remove all characters except '0' and '+' from sku_raw, then trim '*' characters from both ends
    UPPER(REGEXP_REPLACE(sku_raw, '\\*', '')) AS SkuCode,

    -- Select description_raw as is (no transformation)
    description_raw AS Description,

    -- Select notes_raw as is
    notes_raw AS Notes,
    
    -- Decode the Base64 encoded notes_raw_b64 and return as binary data
    BASE64_DECODE_BINARY(notes_raw_b64) AS Decoded_Notes,

    -- Select tags in CSV format as is (no transformation)
    tags_csv,

    -- Count the number of commas in tags_csv and add 1 to determine the number of tags
    REGEXP_COUNT(tags_csv, ',') + 1 AS Tag_Count,

    -- Split tags_csv into an array of tags
    SPLIT(tags_csv, ',') AS Tags_Array,

    -- Get the second tag from the tags array, remove any escape characters (\"), and capitalize it
    INITCAP(REGEXP_REPLACE(SPLIT(tags_csv, ',')[1], '\\"', '')) AS Second_Tag,

    -- Select JSON profile data as is
    json_profile,

    -- Select mixed code data as is
    TRANSLATE(code_mixed,'AEIOUaeiou','12345') AS Code_Mixed,

    -- Remove leading whitespace from padded_left_raw
    LTRIM(padded_left_raw) AS Padded_Left,

    -- Remove trailing whitespace from padded_right_raw
    RTRIM(padded_right_raw) AS Padded_Right,

    -- Select multilingual_raw as is
    multilingual_raw,

    -- Select amount as is (no transformation)
    amount,

    -- Select quantity as is (no transformation)
    quantity,

    -- Select discount percentage as is (no transformation)
    discount_pct

FROM {{ ref('ing_data') }} t

-- Join with state_mapping table on city name to get the state
JOIN {{ ref('state_mapping') }} see
ON t.city_raw = see.city_raw