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



CREATE OR REPLACE FUNCTION get_comments_and_replies(
    p_post_id INT,
    p_user_id UUID
)
RETURNS TABLE (
    comment_id INT,
    profile_id UUID,
    content TEXT,
    created_at TIMESTAMPTZ,
    avatar_url TEXT,
    full_name TEXT,
    my_reaction JSONB,
    replies JSONB,
    reaction_list JSONB
) AS $$
BEGIN
    RETURN QUERY WITH RECURSIVE comment_tree AS (
        -- Select the top-level comments for the post
        SELECT
            c.id AS tree_comment_id,
            c.profile_id AS tree_profile_id,
            c.content AS tree_content,
            c.created_at AS tree_created_at,
            i.url AS tree_avatar_url,
            p.full_name AS tree_full_name,
            r.id AS tree_reaction_id,
            r.content AS tree_reaction_content,
            NULL::JSONB AS tree_replies
        FROM comment c
        LEFT JOIN profiles p ON c.profile_id = p.id
        LEFT JOIN image i ON p.image_id = i.id
        LEFT JOIN reaction r ON r.profile_id = p_user_id AND r.source = c.id AND r.type = 'comment'
        WHERE c.source = p_post_id AND c.type = 'post' -- Filter for top-level comments only

        UNION ALL

        -- Recursively get the replies to the comments
        SELECT
            c.id AS tree_comment_id,
            c.profile_id AS tree_profile_id,
            c.content AS tree_content,
            c.created_at AS tree_created_at,
            i.url AS tree_avatar_url,
            p.full_name AS tree_full_name,
            r.id AS tree_reaction_id,
            r.content AS tree_reaction_content,
            NULL::JSONB AS tree_replies
        FROM comment c
        JOIN comment_tree ct ON c.source = ct.tree_comment_id AND c.type = 'comment'
        LEFT JOIN profiles p ON c.profile_id = p.id
        LEFT JOIN image i ON p.image_id = i.id
        LEFT JOIN reaction r ON r.profile_id = p_user_id AND r.source = c.id AND r.type = 'comment'
    ),
    reaction_counts AS (
        -- Compute the reaction counts for each comment
        SELECT 
            source AS reaction_source,
            jsonb_agg(
                jsonb_build_object(
                    'name', subquery.content,
                    'number', count
                )
            ) AS reaction_list
        FROM (
            SELECT 
                rr.source,
                rr.content,
                COUNT(*) AS count
            FROM reaction rr
            WHERE type = 'comment'
            GROUP BY rr.source, rr.content
        ) AS subquery
        GROUP BY source
    ),
    -- Aggregate replies into JSONB arrays
    aggregated_comments AS (
        SELECT
            ct.tree_comment_id AS agg_comment_id,
            ct.tree_profile_id AS agg_profile_id,
            ct.tree_content AS agg_content,
            ct.tree_created_at AS agg_created_at,
            ct.tree_avatar_url AS agg_avatar_url,
            ct.tree_full_name AS agg_full_name,
            CASE
                WHEN ct.tree_reaction_id IS NULL THEN NULL
                ELSE jsonb_build_object(
                    'reaction_id', ct.tree_reaction_id,
                    'content', ct.tree_reaction_content
                )
            END AS agg_my_reaction,
            COALESCE(
                jsonb_agg(
                    jsonb_build_object(
                        'comment_id', replies.tree_comment_id,
                        'profile_id', replies.tree_profile_id,
                        'content', replies.tree_content,
                        'created_at', replies.tree_created_at,
                        'avatar_url', replies.tree_avatar_url,
                        'full_name', replies.tree_full_name,
                        'my_reaction', CASE
                            WHEN replies.tree_reaction_id IS NULL THEN NULL
                            ELSE jsonb_build_object(
                                'reaction_id', replies.tree_reaction_id,
                                'content', replies.tree_reaction_content
                            )
                        END,
                        'reaction_list', replies.reaction_list -- FIXED: Use the correct alias here
                    )
                ) FILTER (WHERE replies.tree_comment_id IS NOT NULL),
                '[]'
            ) AS agg_replies,
            rc.reaction_list AS agg_reaction_list
        FROM comment_tree ct
        LEFT JOIN LATERAL (
            SELECT
                c.id AS tree_comment_id,
                c.profile_id AS tree_profile_id,
                c.content AS tree_content,
                c.created_at AS tree_created_at,
                i.url AS tree_avatar_url,
                p.full_name AS tree_full_name,
                r.id AS tree_reaction_id,
                r.content AS tree_reaction_content,
                rc.reaction_list -- FIXED: Use `reaction_counts` for reactions on replies
            FROM comment c
            LEFT JOIN profiles p ON c.profile_id = p.id
            LEFT JOIN image i ON p.image_id = i.id
            LEFT JOIN reaction r ON r.profile_id = p_user_id AND r.source = c.id AND r.type = 'comment'
            LEFT JOIN reaction_counts rc ON c.id = rc.reaction_source
            WHERE c.source = ct.tree_comment_id AND c.type = 'comment'
        ) replies ON TRUE
        LEFT JOIN reaction_counts rc ON ct.tree_comment_id = rc.reaction_source
        GROUP BY ct.tree_comment_id, ct.tree_profile_id, ct.tree_content, ct.tree_created_at, ct.tree_avatar_url, ct.tree_full_name, ct.tree_reaction_id, ct.tree_reaction_content, rc.reaction_list
    )
    SELECT
        agg_comment_id AS comment_id,
        agg_profile_id AS profile_id,
        agg_content AS content,
        agg_created_at AS created_at,
        agg_avatar_url AS avatar_url,
        agg_full_name AS full_name,
        agg_my_reaction AS my_reaction,
        agg_replies AS replies,
        agg_reaction_list AS reaction_list
    FROM aggregated_comments
    WHERE NOT EXISTS ( -- Ensure only top-level comments
        SELECT 1
        FROM comment c
        WHERE c.id = aggregated_comments.agg_comment_id AND c.type != 'post'
    );
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_brand_page(p_brand_id INT, p_profile_id UUID)
RETURNS JSON AS $$
BEGIN
    RETURN (
        SELECT json_build_object(
            'name', b.name,
            'description', b.description,
            'image_url', i.url,
            'restaurant_list', (
                SELECT json_agg(
                    json_build_object(
                        'id', r.id,
                        'province_id', a.province,
                        'district_id', a.district,
                        'ward_id', a.ward,
                        'street', a.street,
                        'rate_average', r.rate_total / NULLIF(r.rate_quantity, 0),
                        'name', r.name,
                        'image_url', (SELECT i2.url FROM image i2 WHERE i2.id = m.image_list[1]),
                        'hashtag_list', (
                            SELECT array_agg(h.name)
                            FROM hashtag h
                            WHERE h.id = ANY(r.hashtag_list)
                        ),
                        'is_followed', EXISTS(
                            SELECT 1
                            FROM following f
                            WHERE f.profile_id = p_profile_id
                              AND f.source::text = r.id::text
                              AND f.type = 'restaurant'
                        )
                    )
                )
                FROM restaurant r
                JOIN address a ON a.id = r.address_id
                JOIN metadata m ON m.id = r.metadata_id
                LEFT JOIN image i2 ON i2.id = m.image_list[1]
                WHERE r.brand_id = p_brand_id
            )
        )
        FROM brand b
        LEFT JOIN image i ON i.id = b.image_id
        WHERE b.id = p_brand_id
    );
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_following(p_profile_id UUID)
RETURNS JSON AS $$
BEGIN
    RETURN (
        SELECT json_build_object(
            'restaurants', (
                SELECT json_agg(
                    json_build_object(
                        'id', f.source,
                        'image_url', i.url,
                        'name', r.name,
                        'rate_average', r.rate_total / NULLIF(r.rate_quantity, 0),
                        'province_id', a.province,
                        'district_id', a.district,
                        'ward_id', a.ward,
                        'street', a.street,
                        'category', rc.name
                    )
                )
                FROM following f
                JOIN restaurant r ON r.id = f.source::INT
                JOIN address a ON a.id = r.address_id
                JOIN image i ON i.id = r.image_id
                JOIN restaurant_category rc ON rc.id = r.restaurant_category_id
                WHERE f.profile_id = p_profile_id AND f.type = 'restaurant'
            ),
            'users', (
                SELECT json_agg(
                    json_build_object(
                        'id', f.source,
                        'image_url', i.url,
                        'name', p.full_name,
                        'username', p.username,
                        'join_date', p.join_date
                    )
                )
                FROM following f
                JOIN profiles p ON p.id = f.source::UUID
                LEFT JOIN image i ON i.id = p.image_id
                WHERE f.profile_id = p_profile_id AND f.type = 'user'
            ),
            'posts', (
                SELECT json_agg(
                    json_build_object(
                        'id', f.source,
                        'name', p.name,
                        'image_url', (SELECT i.url FROM image i WHERE i.id = m.image_list[1]),
                        'author', prof.full_name,
                        'view_count', p.view_count,
                        'topic', t.name
                    )
                )
                FROM following f
                JOIN post p ON p.id = f.source::INT
                JOIN metadata m ON m.id = p.metadata_id
                JOIN profiles prof ON prof.id = p.profile_id
                JOIN topic t ON t.id = p.topic_id
                WHERE f.profile_id = p_profile_id AND f.type = 'post'
            )
        )
    );
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_user_and_posts(
    p_target_profile_id UUID,
    p_my_profile_id UUID
)
RETURNS JSON AS $$
BEGIN
    RETURN (
        SELECT json_build_object(
            'user', (
                SELECT json_build_object(
                    'id', p.id,
                    'name', p.full_name,
                    'username', p.username,
                    'permission', p.permission,
                    'avatar_url', i.url,
                    'biography', p.biography,
                    'join_date', p.join_date,
                    'is_followed', EXISTS (
                        SELECT 1
                        FROM following f
                        WHERE f.profile_id = p_my_profile_id
                          AND f.source = p_target_profile_id::TEXT
                    ),
                    'followers', (
                        SELECT COUNT(*)
                        FROM following f
                        WHERE f.source = p_target_profile_id::TEXT
                    )
                )
                FROM profiles p
                LEFT JOIN image i ON i.id = p.image_id
                WHERE p.id = p_target_profile_id
            ),
            'post_list', (
                SELECT json_agg(
                    json_build_object(
                        'id', post.id,
                        'name', post.name,
                        'created_at', post.created_at,
                        'view_count', post.view_count,
                        'image_url', (
                            SELECT i.url
                            FROM image i
                            WHERE i.id = (
                                SELECT unnest(m.image_list)
                                FROM metadata m
                                WHERE m.id = post.metadata_id
                                LIMIT 1
                            )
                        ),
                        'topic', t.name
                    )
                )
                FROM post
                JOIN topic t ON t.id = post.topic_id
                WHERE post.profile_id = p_target_profile_id
            )
        )
    );
END;
$$ LANGUAGE plpgsql;
