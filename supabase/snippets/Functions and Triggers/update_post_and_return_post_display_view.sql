-- Update a post and return the post display view
CREATE OR REPLACE FUNCTION public.update_post_and_return_post_display_view(
  p_post_id UUID,
  p_title TEXT,
  p_content TEXT,
  p_image_url TEXT
)
RETURNS SETOF public.post_display_view -- Use the post_display_view as the return type.
LANGUAGE plpgsql
SET search_path TO public
AS $$
BEGIN
  -- Update the posts table
  -- The RLS policy will ensure that the user can only update their own posts.
  UPDATE public.posts
  SET
    title = p_title,
    content = p_content,
    image_url = p_image_url
  WHERE id = p_post_id;

  -- Return the updated post from the view
  RETURN QUERY
  SELECT *
  FROM public.post_display_view
  WHERE post_id = p_post_id;
END;
$$;