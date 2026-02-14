-- Create a new post and return the post display view
CREATE OR REPLACE FUNCTION public.create_post_and_return_post_display_view(
  p_post_id UUID,
  p_title TEXT,
  p_content TEXT,
  p_image_url TEXT
)
RETURNS SETOF public.post_display_view -- Use the post_display_view as the return type.
LANGUAGE plpgsql
SET search_path TO public
AS $$
DECLARE
  current_user_id UUID := auth.uid();
BEGIN
  -- Insert the new post
  INSERT INTO public.posts (id, author_id, title, content, image_url)
  VALUES (p_post_id, current_user_id, p_title, p_content, p_image_url);

  -- Return the newly created post from the view
  RETURN QUERY
  SELECT *
  FROM public.post_display_view
  WHERE post_id = p_post_id;
END;
$$;