-- Update a comment and return the comment display view
CREATE OR REPLACE FUNCTION public.update_comment_and_return_comment_display_view(
  p_comment_id UUID,
  p_new_content TEXT
)
RETURNS SETOF public.comment_display_view -- Use the comment_display_view as the return type.
LANGUAGE plpgsql
SET search_path TO public
AS $$
BEGIN
  -- Update the comments table
  -- The RLS policy will ensure the user can only update their own comment.
  -- The trigger 'set_comments_updated_at' will automatically update the 'updated_at' field.
  UPDATE public.comments
  SET
    content = p_new_content
  WHERE id = p_comment_id;

  -- Return the updated comment from the view
  RETURN QUERY
  SELECT *
  FROM public.comment_display_view
  WHERE id = p_comment_id;
END;
$$;