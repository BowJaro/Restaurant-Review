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
    avatar_url TEXT,
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

