-- Function to get all posts by a specific author with pagination
CREATE OR REPLACE FUNCTION public.get_my_posts(p_author_id UUID, p_limit INT, p_offset INT)
RETURNS SETOF public.post_display_view
LANGUAGE plpgsql
SET search_path TO public
AS $$
BEGIN
  RETURN QUERY
  SELECT *
  FROM public.post_display_view
  WHERE author_id = p_author_id
  ORDER BY post_created_at DESC
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;