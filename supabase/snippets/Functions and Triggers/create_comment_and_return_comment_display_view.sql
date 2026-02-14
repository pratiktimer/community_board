-- Create a new comment and return the comment display view
CREATE OR REPLACE FUNCTION public.create_comment_and_return_comment_display_view(
  p_post_id UUID,
  p_content TEXT
)
RETURNS SETOF public.comment_display_view
LANGUAGE plpgsql
SET search_path TO public
AS $$
DECLARE
  new_comment_id UUID;
BEGIN
  -- Insert the new comment and get its ID
  INSERT INTO public.comments (post_id, user_id, content)
  VALUES (p_post_id, auth.uid(), p_content)
  RETURNING id INTO new_comment_id;

  -- The 'update_comments_count' trigger will automatically increment the comments_count.

  -- Return the newly created comment from the view
  RETURN QUERY
  SELECT *
  FROM public.comment_display_view
  WHERE id = new_comment_id;
END;
$$;