-- Trigger function that sets the updated_at column to the current time
CREATE OR REPLACE FUNCTION public.trigger_set_timestamp()
RETURNS TRIGGER 
LANGUAGE plpgsql
SET search_path TO public
AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

-- Applying the updated_at trigger to the profiles table
CREATE OR REPLACE TRIGGER set_profiles_updated_at
BEFORE UPDATE ON public.profiles
FOR EACH ROW
EXECUTE PROCEDURE public.trigger_set_timestamp();

-- Applying the updated_at trigger to the posts table
CREATE OR REPLACE TRIGGER set_posts_updated_at
BEFORE UPDATE ON public.posts
FOR EACH ROW
EXECUTE PROCEDURE public.trigger_set_timestamp();

-- Applying the updated_at trigger to the comments table
CREATE OR REPLACE TRIGGER set_comments_updated_at
BEFORE UPDATE ON public.comments
FOR EACH ROW
EXECUTE PROCEDURE public.trigger_set_timestamp();