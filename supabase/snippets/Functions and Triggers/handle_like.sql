CREATE OR REPLACE FUNCTION public.handle_like(p_post_id UUID)
RETURNS JSON
LANGUAGE plpgsql
SET search_path TO public
AS $$
DECLARE
  current_user_id UUID := auth.uid();
  like_exists BOOLEAN;
  final_likes_count INT;
BEGIN
  -- Check if the current user has already liked it
  SELECT EXISTS (
    SELECT 1 FROM public.likes
    WHERE post_id = p_post_id AND user_id = current_user_id
  ) INTO like_exists;

  IF like_exists THEN
    -- If you have already liked it, delete it (unlike it)
    DELETE FROM public.likes
    WHERE post_id = p_post_id AND user_id = current_user_id;
  ELSE
    -- If you haven't liked it, add it
    INSERT INTO public.likes (post_id, user_id)
    VALUES (p_post_id, current_user_id);
  END IF;

  -- ✨ IMPORTANT: After the trigger completes all calculations,
  -- the final values ​​to be returned to the client are read back from the posts table.
  SELECT likes_count INTO final_likes_count
  FROM public.posts
  WHERE id = p_post_id;

  RETURN json_build_object(
    'liked', NOT like_exists, -- New Like Status
    'likes_count', final_likes_count
  );
END;
$$;