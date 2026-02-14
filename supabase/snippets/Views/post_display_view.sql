-- Create a post_display_view view
CREATE OR REPLACE VIEW public.post_display_view 
with (security_invoker = on) AS
SELECT
  p.id AS post_id,
  p.title,
  p.content,
  p.image_url,
  p.created_at AS post_created_at,
  p.updated_at AS post_updated_at,
  p.author_id,
  u.username AS author_username,
  u.avatar_url AS author_avatar_url,
  u.role AS author_role,
  p.likes_count,
  p.comments_count,
  EXISTS(
    SELECT 1
    FROM public.likes l
    WHERE l.post_id = p.id AND l.user_id = auth.uid()
  ) AS current_user_liked
FROM
  public.posts p
JOIN
  public.profiles u ON p.author_id = u.id;