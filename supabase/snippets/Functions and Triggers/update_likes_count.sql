CREATE OR REPLACE FUNCTION public.update_likes_count()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO public
AS $$
BEGIN
  -- Always update by recounting the actual count, rather than adding or subtracting.
  -- This ensures 100% data integrity.
  UPDATE public.posts
  SET likes_count = (
    SELECT COUNT(*)
    FROM public.likes
    WHERE post_id = COALESCE(NEW.post_id, OLD.post_id)
  )
  WHERE id = COALESCE(NEW.post_id, OLD.post_id);

  RETURN NULL; -- AFTER triggers return NULL because their return value is not important.
END;
$$;

-- COALESCE(NEW.post_id, OLD.post_id) is a smart way 
-- to use NEW.post_id for INSERTs and OLD.post_id for DELETEs.

CREATE OR REPLACE TRIGGER on_like_change_update_post_likes_count
  AFTER INSERT OR DELETE ON public.likes
  FOR EACH ROW EXECUTE PROCEDURE public.update_likes_count();