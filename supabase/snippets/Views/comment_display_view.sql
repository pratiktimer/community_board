CREATE OR REPLACE VIEW public.comment_display_view 
with (security_invoker = on) AS
SELECT
  c.id,
  c.post_id,
  c.content,
  c.created_at,
  c.user_id AS author_id,
  p.username AS author_username,
  p.avatar_url AS author_avatar_url
FROM
  public.comments c
  JOIN public.profiles p ON c.user_id = p.id
ORDER BY
  c.created_at DESC; -- Sort by most recent comments