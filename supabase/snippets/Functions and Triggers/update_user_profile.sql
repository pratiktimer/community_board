CREATE OR REPLACE FUNCTION public.update_user_profile(
  new_username TEXT,
  new_avatar_url TEXT
)
RETURNS SETOF public.profiles -- Returns a set of updated profile records
LANGUAGE plpgsql
-- SECURITY DEFINER: This function runs with the privileges of the owner 
-- who created the function (usually an administrator).
-- This privilege is required to modify the auth.users table.
SECURITY DEFINER
SET search_path TO public
AS $$
BEGIN
  -- 1. Update the public.profiles table
  -- Use auth.uid() in the WHERE clause 
  -- to restrict users to modifying only their own profile.
  UPDATE public.profiles
  SET
    username = new_username,
    avatar_url = new_avatar_url,
    updated_at = NOW() 
  WHERE id = auth.uid();

  -- 2. Update user_metadata in the auth.users table
  -- Use the jsonb || operator to overwrite existing metadata with new values
  UPDATE auth.users
  SET
    raw_user_meta_data = raw_user_meta_data || jsonb_build_object('username', new_username, 'avatar_url', new_avatar_url)
  WHERE id = auth.uid();

  -- 3. Returns the most recent updated profile information
  RETURN QUERY
  SELECT * FROM public.profiles WHERE id = auth.uid();
END;
$$;