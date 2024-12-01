CREATE OR REPLACE FUNCTION remove_following(
    p_profile_id UUID,
    p_source TEXT,
    p_type VARCHAR(255)
)
RETURNS VOID AS $$
BEGIN
    DELETE FROM following
    WHERE profile_id = p_profile_id
      AND source = p_source
      AND type = p_type;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION remove_comment(p_id INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM comment WHERE id = p_id;
END;
$$ LANGUAGE plpgsql;
