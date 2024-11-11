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
