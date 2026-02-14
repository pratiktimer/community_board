CREATE INDEX posts_fts_idx 
ON public.posts 
USING GIN (to_tsvector('pg_catalog.english', title || ' ' || content));