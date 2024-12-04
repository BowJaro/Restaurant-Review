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

--
CREATE OR REPLACE FUNCTION upsert_restaurant(
    p_id INT,
    p_name VARCHAR(255),
    p_restaurant_category_id INT,
    p_brand_id INT,
    p_description TEXT,
    p_hashtag_list TEXT[],
    p_image_urls TEXT[],
    p_avatar_url TEXT,
    p_province VARCHAR(255),
    p_district VARCHAR(255),
    p_ward VARCHAR(255),
    p_street VARCHAR(255),
    p_latitude DOUBLE PRECISION,
    p_longitude DOUBLE PRECISION,
    p_metadata_id INT DEFAULT NULL,
    p_avatar_id INT DEFAULT NULL,
    p_address_id INT DEFAULT NULL,
    p_location_id INT DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
    v_metadata_id INT := p_metadata_id;
    v_address_id INT := p_address_id;
    v_location_id INT := p_location_id;
    v_hashtag_ids INT[];
    v_image_ids INT[];
    v_avatar_image_id INT := p_avatar_id;
BEGIN
    -- Step 1: Upsert Hashtags
    RAISE NOTICE 'Upserting hashtags';
    WITH upserted_hashtags AS (
        INSERT INTO hashtag (name)
        SELECT UNNEST(p_hashtag_list)
        ON CONFLICT (name) DO UPDATE SET name = EXCLUDED.name
        RETURNING id
    )
    SELECT ARRAY_AGG(id) INTO v_hashtag_ids FROM upserted_hashtags;

    -- Step 2: Insert Images if not empty
    RAISE NOTICE 'Inserting images';
    IF p_image_urls IS NOT NULL AND array_length(p_image_urls, 1) > 0 THEN
        WITH inserted_images AS (
            INSERT INTO image (url)
            SELECT url FROM UNNEST(p_image_urls) AS url
            RETURNING id
        )
        SELECT ARRAY_AGG(id) INTO v_image_ids FROM inserted_images;
    END IF;

    -- Step 3: Insert or Update Avatar Image
    RAISE NOTICE 'Inserting or updating avatar image';
    IF p_avatar_url IS NOT NULL AND p_avatar_url <> '' THEN
        IF v_avatar_image_id IS NULL THEN
            INSERT INTO image (url)
            VALUES (p_avatar_url)
            RETURNING id INTO v_avatar_image_id;
        ELSE
            UPDATE image SET url = p_avatar_url WHERE id = v_avatar_image_id;
        END IF;
    END IF;

    -- Step 4: Insert or Update Metadata row
    RAISE NOTICE 'Inserting or updating metadata';
    IF v_metadata_id IS NULL THEN
        INSERT INTO metadata (text, image_list)
        VALUES (p_description, v_image_ids)
        RETURNING id INTO v_metadata_id;
    ELSE
        UPDATE metadata
        SET text = p_description, image_list = v_image_ids
        WHERE id = v_metadata_id;
    END IF;

    -- Step 5: Insert or Update Address row
    RAISE NOTICE 'Inserting or updating address';
    IF v_address_id IS NULL THEN
        INSERT INTO address (province, district, ward, street)
        VALUES (p_province, p_district, p_ward, p_street)
        RETURNING id INTO v_address_id;
    ELSE
        UPDATE address
        SET province = p_province, district = p_district, ward = p_ward, street = p_street
        WHERE id = v_address_id;
    END IF;

    -- Step 6: Insert or Update Location row
    RAISE NOTICE 'Inserting or updating location';
    IF v_location_id IS NULL THEN
        INSERT INTO location (latitude, longitude)
        VALUES (p_latitude, p_longitude)
        RETURNING id INTO v_location_id;
    ELSE
        UPDATE location
        SET latitude = p_latitude, longitude = p_longitude
        WHERE id = v_location_id;
    END IF;

    -- Step 7: Upsert the Restaurant row
    RAISE NOTICE 'Upserting restaurant';
    IF p_id IS NULL THEN
        INSERT INTO restaurant (
            name, restaurant_category_id, brand_id,
            metadata_id, address_id, location_id,
            image_id, hashtag_list
        )
        VALUES (
            p_name, p_restaurant_category_id, p_brand_id,
            v_metadata_id, v_address_id, v_location_id,
            v_avatar_image_id, v_hashtag_ids
        );
    ELSE
        UPDATE restaurant
        SET
            name = p_name,
            restaurant_category_id = p_restaurant_category_id,
            brand_id = p_brand_id,
            metadata_id = v_metadata_id,
            address_id = v_address_id,
            location_id = v_location_id,
            image_id = v_avatar_image_id,
            hashtag_list = v_hashtag_ids
        WHERE id = p_id;
    END IF;

    RETURN TRUE;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error occurred: %', SQLERRM;
        RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION upsert_post(
    p_id INT,
    p_topic_id INT,
    p_name VARCHAR,
    p_metadata_id INT,
    p_content TEXT,
    p_hashtag_list TEXT[],
    p_image_url_list TEXT[],
    p_profile_id UUID,
    p_restaurant_id INT
) RETURNS VOID AS $$
DECLARE
    v_post_id INT;
    v_metadata_id INT;
    v_image_id INT;
    v_image_ids INT[];
    v_hashtag_id INT;
    v_hashtag_ids INT[];
    v_image_url TEXT;
    v_hashtag TEXT;
BEGIN
    -- Insert images and get their ids
    FOREACH v_image_url IN ARRAY p_image_url_list
    LOOP
        INSERT INTO image (url) VALUES (v_image_url)
        RETURNING id INTO v_image_id;
        v_image_ids := array_append(v_image_ids, v_image_id);
    END LOOP;

    -- Upsert metadata
    IF p_metadata_id IS NULL THEN
        INSERT INTO metadata (text, image_list)
        VALUES (p_content, v_image_ids)
        RETURNING id INTO v_metadata_id;
    ELSE
        UPDATE metadata
        SET text = p_content,
            image_list = v_image_ids
        WHERE id = p_metadata_id
        RETURNING id INTO v_metadata_id;
    END IF;

    -- Insert hashtags and get their ids
    FOREACH v_hashtag IN ARRAY p_hashtag_list
    LOOP
        INSERT INTO hashtag (name) VALUES (v_hashtag)
        ON CONFLICT (name) DO UPDATE SET name = EXCLUDED.name
        RETURNING id INTO v_hashtag_id;
        v_hashtag_ids := array_append(v_hashtag_ids, v_hashtag_id);
    END LOOP;

    -- Upsert post
    IF p_id IS NULL THEN
        INSERT INTO post (topic_id, name, metadata_id, hashtag_list, profile_id, restaurant_id)
        VALUES (p_topic_id, p_name, v_metadata_id, v_hashtag_ids, p_profile_id, p_restaurant_id)
        RETURNING id INTO v_post_id;
    ELSE
        UPDATE post
        SET topic_id = p_topic_id,
            name = p_name,
            metadata_id = v_metadata_id,
            hashtag_list = v_hashtag_ids,
            profile_id = p_profile_id,
            restaurant_id = p_restaurant_id
        WHERE id = p_id
        RETURNING id INTO v_post_id;
    END IF;
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION upsert_post_with_rate(
    p_id INT,
    p_topic_id INT,
    p_name VARCHAR,
    p_metadata_id INT,
    p_content TEXT,
    p_hashtag_list TEXT[],
    p_image_url_list TEXT[],
    p_profile_id UUID,
    p_restaurant_id INT,
    p_rate_list JSONB,
    p_rate_id INT
) RETURNS VOID AS $$
DECLARE
    v_post_id INT;
    v_metadata_id INT;
    v_image_id INT;
    v_image_ids INT[];
    v_hashtag_id INT;
    v_hashtag_ids INT[];
    v_image_url TEXT;
    v_hashtag TEXT;
    v_rate_id INT;
    v_average DOUBLE PRECISION;
    v_item JSONB;
    v_total INT = 0;
    v_count INT = 0;
BEGIN
    -- Insert images and get their ids
    FOREACH v_image_url IN ARRAY p_image_url_list
    LOOP
        INSERT INTO image (url) VALUES (v_image_url)
        RETURNING id INTO v_image_id;
        v_image_ids := array_append(v_image_ids, v_image_id);
    END LOOP;

    -- Upsert metadata
    IF p_metadata_id IS NULL THEN
        INSERT INTO metadata (text, image_list)
        VALUES (p_content, v_image_ids)
        RETURNING id INTO v_metadata_id;
    ELSE
        UPDATE metadata
        SET text = p_content,
            image_list = v_image_ids
        WHERE id = p_metadata_id
        RETURNING id INTO v_metadata_id;
    END IF;

    -- Insert hashtags and get their ids
    FOREACH v_hashtag IN ARRAY p_hashtag_list
    LOOP
        INSERT INTO hashtag (name) VALUES (v_hashtag)
        ON CONFLICT (name) DO UPDATE SET name = EXCLUDED.name
        RETURNING id INTO v_hashtag_id;
        v_hashtag_ids := array_append(v_hashtag_ids, v_hashtag_id);
    END LOOP;

    -- Calculate average value from rate list
    IF p_rate_list IS NOT NULL THEN
        FOR v_item IN SELECT * FROM jsonb_array_elements(p_rate_list)
        LOOP
            v_total := v_total + (v_item->>'value')::INT;
            v_count := v_count + 1;
        END LOOP;
        v_average := v_total::DOUBLE PRECISION / v_count;

        -- Upsert rate
        IF p_rate_id IS NULL THEN
            INSERT INTO rate (profile_id, restaurant_id, average)
            VALUES (p_profile_id, p_restaurant_id, v_average)
            RETURNING id INTO v_rate_id;
        ELSE
            UPDATE rate
            SET average = v_average
            WHERE id = p_rate_id;
            v_rate_id := p_rate_id;
        END IF;

        -- Upsert rate content
        FOR v_item IN SELECT * FROM jsonb_array_elements(p_rate_list)
        LOOP
            IF (v_item->>'id') IS NULL THEN
                INSERT INTO rate_content (rate_id, rate_type_id, value)
                VALUES (v_rate_id, (v_item->>'rate_type_id')::INT, (v_item->>'value')::INT);
            ELSE
                UPDATE rate_content
                SET rate_id = v_rate_id,
                    rate_type_id = (v_item->>'rate_type_id')::INT,
                    value = (v_item->>'value')::INT
                WHERE id = (v_item->>'id')::INT;
            END IF;
        END LOOP;
    END IF;

    -- Upsert post
    IF p_id IS NULL THEN
        INSERT INTO post (topic_id, name, metadata_id, hashtag_list, profile_id, restaurant_id, rate_id)
        VALUES (p_topic_id, p_name, v_metadata_id, v_hashtag_ids, p_profile_id, p_restaurant_id, v_rate_id)
        RETURNING id INTO v_post_id;
    ELSE
        UPDATE post
        SET topic_id = p_topic_id,
            name = p_name,
            metadata_id = v_metadata_id,
            hashtag_list = v_hashtag_ids,
            profile_id = p_profile_id,
            restaurant_id = p_restaurant_id,
            rate_id = v_rate_id
        WHERE id = p_id
        RETURNING id INTO v_post_id;
    END IF;
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION insert_report(
    p_source TEXT,
    p_type TEXT,
    p_title TEXT,
    p_description TEXT
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO report (source, type, title, description)
    VALUES (p_source, p_type, p_title, p_description);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION insert_feedback(
    p_title TEXT,
    p_description TEXT
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO feedback (title, description)
    VALUES (p_title, p_description);
END;
$$ LANGUAGE plpgsql;
