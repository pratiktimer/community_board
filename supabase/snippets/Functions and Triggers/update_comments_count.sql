CREATE OR REPLACE FUNCTION public.update_comments_count()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER -- Need permission to modify posts table
SET search_path TO public
AS $$
BEGIN
  UPDATE public.posts
  SET comments_count = (
    SELECT COUNT(*)
    FROM public.comments
    WHERE post_id = COALESCE(NEW.post_id, OLD.post_id)
  )
  WHERE id = COALESCE(NEW.post_id, OLD.post_id);

  RETURN NULL;
END;
$$;

CREATE OR REPLACE TRIGGER on_comment_change_update_post_comments_count
  AFTER INSERT OR DELETE ON public.comments
  FOR EACH ROW EXECUTE PROCEDURE public.update_comments_count();