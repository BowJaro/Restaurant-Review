CREATE OR REPLACE FUNCTION get_data_for_new_restaurant()
RETURNS JSONB AS $$
DECLARE
    result JSONB;
BEGIN
    SELECT jsonb_build_object(
        'restaurant_category', (
            SELECT jsonb_agg(jsonb_build_object('id', rc.id, 'name', rc.name))
            FROM restaurant_category rc
        ),
        'brand', (
            SELECT jsonb_agg(jsonb_build_object('id', b.id, 'name', b.name))
            FROM brand b
        )
    ) INTO result;

    RETURN result;
END;
$$ LANGUAGE plpgsql;


--
CREATE OR REPLACE FUNCTION get_restaurant_details(p_id INT)
RETURNS JSONB AS $$
DECLARE
    restaurant_details JSONB;
BEGIN
    -- Fetch restaurant details
    SELECT JSONB_BUILD_OBJECT(
        'id', r.id,
        'name', r.name,
        'brand_id', r.brand_id,
        'restaurant_category_id', r.restaurant_category_id,
        'description', m.text,
        'hashtag_list', (
            SELECT COALESCE(JSONB_AGG(h.name), '[]'::JSONB)
            FROM hashtag h
            WHERE h.id = ANY(r.hashtag_list)
        ),
        'image_list', (
            SELECT COALESCE(JSONB_AGG(i.url), '[]'::JSONB)
            FROM image i
            WHERE i.id = ANY(m.image_list)
        ),
        'avatar', (SELECT i.url FROM image i WHERE i.id = r.image_id),
        'province', a.province,
        'district', a.district,
        'ward', a.ward,
        'street', a.street,
        'latitude', l.latitude,
        'longitude', l.longitude,
        'brand_list', (
            SELECT JSONB_AGG(JSONB_BUILD_OBJECT(
                'id', b.id,
                'name', b.name
            ))
            FROM brand b
        ),
        'restaurant_category_list', (
            SELECT JSONB_AGG(JSONB_BUILD_OBJECT(
                'id', rc.id,
                'name', rc.name
            ))
            FROM restaurant_category rc
        )
    )
    INTO restaurant_details
    FROM restaurant r
    LEFT JOIN metadata m ON r.metadata_id = m.id
    LEFT JOIN address a ON r.address_id = a.id
    LEFT JOIN location l ON r.location_id = l.id
    WHERE r.id = p_id;

    -- Check if restaurant details were found
    IF restaurant_details IS NULL THEN
        RAISE EXCEPTION 'Restaurant with ID % not found', p_id;
    END IF;

    RETURN restaurant_details;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error occurred: %', SQLERRM;
        RETURN NULL;
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION get_data_for_new_post()
RETURNS JSONB AS $$
DECLARE
    topics JSONB;
    restaurants JSONB;
    rate_types JSONB;
    result JSONB;
BEGIN
    -- Fetch all rows from the topic table
    SELECT jsonb_agg(jsonb_build_object('id', t.id, 'name', t.name))
    INTO topics
    FROM topic t;

    -- Fetch all rows from the restaurant table
    SELECT jsonb_agg(jsonb_build_object('id', r.id, 'name', r.name))
    INTO restaurants
    FROM restaurant r;

    -- Fetch all rows from the rate_type table
    SELECT jsonb_agg(jsonb_build_object('rate_type_id', rt.id, 'name', rt.name))
    INTO rate_types
    FROM rate_type rt;

    -- Build the final JSON object
    result := jsonb_build_object(
        'topic', topics,
        'restaurant', restaurants,
        'rate', rate_types
    );

    RETURN result;
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION fetch_data_for_post_edit(p_id INT) RETURNS JSONB AS $$
DECLARE
    v_post_name VARCHAR;
    v_topic_id INT;
    v_restaurant_id INT;
    v_rate_id INT;
    v_metadata_id INT;
    v_topic JSONB;
    v_restaurant JSONB;
    v_rate_list JSONB;
    v_hashtag_list TEXT[];
    v_image_url_list TEXT[];
    v_content TEXT;
BEGIN
    -- Fetch post details
    SELECT name, topic_id, restaurant_id, rate_id, metadata_id 
    INTO v_post_name, v_topic_id, v_restaurant_id, v_rate_id, v_metadata_id
    FROM post WHERE id = p_id;

    -- Fetch topics
    v_topic := (SELECT jsonb_agg(jsonb_build_object('id', id, 'name', name))
                FROM topic);

    -- Fetch restaurants
    v_restaurant := (SELECT jsonb_agg(jsonb_build_object('id', id, 'name', name))
                     FROM restaurant);

    -- Fetch rate list
    IF v_rate_id IS NULL THEN
        v_rate_list := (SELECT jsonb_agg(jsonb_build_object(
                                            'id', id,
                                            'rate_type_id', id,
                                            'name', name,
                                            'value', 5))
                        FROM rate_type);
    ELSE
        v_rate_list := (SELECT jsonb_agg(jsonb_build_object(
                                            'id', rc.id,
                                            'rate_type_id', rc.rate_type_id,
                                            'name', rt.name,
                                            'value', rc.value))
                        FROM rate_content rc
                        JOIN rate_type rt ON rc.rate_type_id = rt.id
                        WHERE rc.rate_id = v_rate_id);
    END IF;

    -- Fetch hashtag list
    SELECT array_agg(h.name) INTO v_hashtag_list
    FROM hashtag h
    WHERE h.id = ANY (ARRAY(SELECT unnest(hashtag_list) FROM post WHERE id = p_id));

    -- Fetch image URLs and content
    IF v_metadata_id IS NOT NULL THEN
        SELECT m.text, array_agg(i.url) INTO v_content, v_image_url_list
        FROM metadata m
        LEFT JOIN image i ON i.id = ANY (m.image_list)
        WHERE m.id = v_metadata_id
        GROUP BY m.text;
    END IF;

    -- Return JSON object with all gathered data
    RETURN jsonb_build_object(
        'id', p_id,
        'name', v_post_name,
        'topic_id', v_topic_id,
        'restaurant_id', v_restaurant_id,
        'rate_id', v_rate_id,
        'metadata_id', v_metadata_id,
        'topic', v_topic,
        'restaurant', v_restaurant,
        'rate', v_rate_list,
        'hashtag_list', v_hashtag_list,
        'image_url_list', v_image_url_list,
        'content', v_content
    );
END;
$$ LANGUAGE plpgsql;
