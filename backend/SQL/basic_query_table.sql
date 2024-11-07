CREATE OR REPLACE FUNCTION fetch_brand_detail(p_id INT)
RETURNS RECORD AS $$
DECLARE
    result RECORD;
BEGIN
    SELECT 
        b.id,
        b.name,
        b.description,
        i.url AS image_url
    INTO result
    FROM 
        brand b
    LEFT JOIN 
        image i ON b.image_id = i.id
    WHERE 
        b.id = p_id;

    RETURN result;
END;
$$ LANGUAGE plpgsql;
