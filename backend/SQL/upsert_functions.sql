CREATE OR REPLACE FUNCTION upsert_brand(
    p_id INT,
    p_name VARCHAR,
    p_description TEXT,
    p_image_url TEXT
)
RETURNS BOOLEAN AS $$
DECLARE
    new_image_id INT;
BEGIN
    -- Insert image URL and get image ID
    INSERT INTO image (url) VALUES (p_image_url) RETURNING id INTO new_image_id;

    -- Upsert brand data with the new image ID
    IF p_id IS NULL THEN
        -- Insert new record
        INSERT INTO brand (name, description, image_id)
        VALUES (p_name, p_description, new_image_id);
    ELSE
        -- Update existing record or insert if it doesn't exist
        INSERT INTO brand (id, name, description, image_id)
        VALUES (p_id, p_name, p_description, new_image_id)
        ON CONFLICT (id) DO UPDATE
        SET name = EXCLUDED.name,
            description = EXCLUDED.description,
            image_id = EXCLUDED.image_id;
    END IF;

    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END;
$$ LANGUAGE plpgsql;
