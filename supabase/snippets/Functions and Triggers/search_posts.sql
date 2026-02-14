CREATE OR REPLACE FUNCTION public.search_posts(p_search_query TEXT)
RETURNS SETOF public.post_display_view
LANGUAGE plpgsql
SET search_path TO public
AS $$
BEGIN
  RETURN QUERY
  SELECT *
  FROM public.post_display_view
  WHERE
    -- PostgreSQL Full-Text Search 사용 (language: english)
    -- pg_catalog.english is the English text search configuration built into PostgreSQL.
    to_tsvector('pg_catalog.english', title || ' ' || content) @@ plainto_tsquery('pg_catalog.english', p_search_query)
  ORDER BY post_created_at DESC LIMIT 20;
END;
$$;