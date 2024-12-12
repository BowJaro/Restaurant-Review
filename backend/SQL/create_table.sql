-- Create the Image table
CREATE TABLE image (
    id SERIAL PRIMARY KEY,
    url TEXT
);

-- Create the Profiles table with additional fields
CREATE TABLE profiles (
    id UUID REFERENCES auth.users NOT NULL PRIMARY KEY,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    username TEXT UNIQUE CHECK (char_length(username) >= 3),
    full_name TEXT DEFAULT '',
    email TEXT UNIQUE,
    phone TEXT DEFAULT '',
    address TEXT DEFAULT '',
    biography TEXT DEFAULT '',
    rank TEXT DEFAULT '',
    website TEXT,
    join_date TIMESTAMPTZ DEFAULT NOW(),
    quota INTEGER DEFAULT 100,
    status TEXT DEFAULT 'active',
    permission TEXT DEFAULT 'user',
    image_id INTEGER REFERENCES image (id) ON DELETE SET NULL
);

-- Enable Row Level Security (RLS)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Define policies for Row Level Security
CREATE POLICY "Public profiles are viewable by everyone." ON profiles
    FOR SELECT USING (true);

CREATE POLICY "Users can insert their own profile." ON profiles
    FOR INSERT WITH CHECK ((SELECT auth.uid()) = id);

CREATE POLICY "Users can update own profile." ON profiles
    FOR UPDATE USING ((SELECT auth.uid()) = id);

-- Trigger function to handle profile creation when a new user signs up
CREATE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SET search_path = ''
AS $$
BEGIN
    INSERT INTO public.profiles (id, email, username, full_name, avatar_url, join_date)
    VALUES (NEW.id, NEW.email, NEW.email, NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'avatar_url', NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger to automatically insert a new profile when a user is created
CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Create Topic
CREATE TABLE topic (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT
);

-- Create Restaurant Category
CREATE TABLE restaurant_category (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) DEFAULT '',
    description TEXT DEFAULT ''
);

-- Create Brand
CREATE TABLE brand (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) DEFAULT '',
    description TEXT DEFAULT '',
    image_id INT REFERENCES image(id) ON DELETE SET NULL
);

-- Create Metadata
CREATE TABLE metadata (
    id SERIAL PRIMARY KEY,
    text TEXT DEFAULT '',
    image_list INT[] DEFAULT '{}'
);

-- Create Address
CREATE TABLE address (
    id SERIAL PRIMARY KEY,
    street VARCHAR(255) DEFAULT '',
    province VARCHAR(255) DEFAULT '',
    district VARCHAR(255) DEFAULT '',
    ward VARCHAR(255) DEFAULT ''
);

-- Create Location
CREATE TABLE location (
    id SERIAL PRIMARY KEY,
    longitude DOUBLE PRECISION DEFAULT 0,
    latitude DOUBLE PRECISION DEFAULT 0
);

-- Create Hashtag
create table hashtag (
    id serial primary key,
    name varchar(255) unique not null,
    description text default ''
);

-- Create Restaurant
create table restaurant (
    id serial primary key,
    brand_id int references brand(id) on delete set null,
    restaurant_category_id int references restaurant_category(id) on delete set null,
    address_id int references address(id) on delete set null,
    location_id int references location(id) on delete set null,
    image_id int references image(id) on delete set null,
    metadata_id int references metadata(id) on delete set null,
    name varchar(255) not null default '',
    rate_total double precision default 0,
    rate_quantity int default 0,
    status varchar(50) default 'active',
    hashtag_list int[] -- Array of integers to store hashtag IDs
);

-- Create Rate
CREATE TABLE rate (
    id SERIAL PRIMARY KEY,
    profile_id UUID REFERENCES profiles(id),
    restaurant_id INT REFERENCES restaurant(id),
    created_at TIMESTAMPTZ DEFAULT now(),
    average DOUBLE PRECISION DEFAULT 0
);

-- Create RateType
CREATE TABLE rate_type (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) DEFAULT '',
    description TEXT DEFAULT ''
);

-- Create RateContent
CREATE TABLE rate_content (
    id SERIAL PRIMARY KEY,
    rate_id INT REFERENCES rate(id),
    rate_type_id INT REFERENCES rate_type(id),
    value INT CHECK (value >= 1 AND value <= 5) DEFAULT 5
);

CREATE OR REPLACE FUNCTION update_restaurant_rate()
RETURNS TRIGGER AS $$
BEGIN
    -- Handle insert
    IF TG_OP = 'INSERT' THEN
        UPDATE restaurant
        SET rate_quantity = rate_quantity + 1,
            rate_total = rate_total + NEW.average
        WHERE id = NEW.restaurant_id;
    -- Handle delete
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE restaurant
        SET rate_quantity = GREATEST(rate_quantity - 1, 0),
            rate_total = GREATEST(rate_total - OLD.average, 0)
        WHERE id = OLD.restaurant_id;
    -- Handle update
    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE restaurant
        SET rate_total = GREATEST(rate_total + NEW.average - OLD.average, 0)
        WHERE id = NEW.restaurant_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER rate_changes
AFTER INSERT OR DELETE OR UPDATE ON rate
FOR EACH ROW EXECUTE FUNCTION update_restaurant_rate();


-- Create Post
CREATE TABLE post (
    id SERIAL PRIMARY KEY,
    topic_id INT REFERENCES topic(id),
    name VARCHAR(255) DEFAULT '',
    metadata_id INT REFERENCES metadata(id),
    created_at TIMESTAMPTZ DEFAULT now(),
    hashtag_list INT[],
    status VARCHAR(50) DEFAULT 'published',
    view_count INT DEFAULT 0,
    profile_id UUID REFERENCES profiles(id),
    rate_id INT REFERENCES rate(id) ON DELETE SET NULL
);

-- Create Reaction Table
CREATE TABLE reaction (
    id SERIAL PRIMARY KEY,
    profile_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    content VARCHAR(255) NOT NULL,
    source INT NOT NULL,
    type VARCHAR(255) NOT NULL
);

-- Create Comment Table
CREATE TABLE comment (
    id SERIAL PRIMARY KEY,
    profile_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    content TEXT DEFAULT '',
    source INT NOT NULL,
    type VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE following (
    id SERIAL PRIMARY KEY,
    profile_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    source TEXT DEFAULT '',
    type VARCHAR(255) NOT NULL
);


CREATE TABLE report (
    id SERIAL PRIMARY KEY,
    source TEXT NOT NULL,
    type TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT
);


CREATE TABLE feedback (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT
);


CREATE TABLE permission_request (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    address_id INT REFERENCES address(id) ON DELETE SET NULL,
    profile_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    image_list INT[] DEFAULT '{}',
    permission TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now(),
    status TEXT DEFAULT 'pending'
);


CREATE TABLE menu_item (
    id SERIAL PRIMARY KEY,
    restaurant_id INT REFERENCES restaurant(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL DEFAULT '',
    description TEXT,
    price DECIMAL(10,2) DEFAULT 0,
    image_id INT REFERENCES image(id) ON DELETE SET NULL DEFAULT NULL
);