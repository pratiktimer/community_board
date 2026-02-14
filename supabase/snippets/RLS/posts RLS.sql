-- Enable RLS on the posts table
ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;

-- SELECT Policy
-- Allow authenticated users to read all posts
CREATE POLICY "Allow authenticated users to read all posts"
ON public.posts
FOR SELECT
TO authenticated
USING (true);

-- INSERT Policy
-- Only administrators are allowed to create posts.
CREATE POLICY "Allow admin to create posts"
ON public.posts
FOR INSERT
TO authenticated
WITH CHECK (
  public.get_user_role((SELECT auth.uid())) = 'admin' AND
  author_id = (SELECT auth.uid())
);

-- UPDATE Policy
-- Only administrators are allowed to update own posts.
CREATE POLICY "Allow admin to update own posts"
ON public.posts
FOR UPDATE
TO authenticated 
USING ((SELECT auth.uid()) = author_id AND public.get_user_role((SELECT auth.uid())) = 'admin')
WITH CHECK ((SELECT auth.uid()) = author_id AND public.get_user_role((SELECT auth.uid())) = 'admin');

-- DELETE Policy
-- Only administrators are allowed to delete own posts.
CREATE POLICY "Allow admin to delete own posts"
ON public.posts
FOR DELETE
TO authenticated 
USING ((SELECT auth.uid()) = author_id AND public.get_user_role((SELECT auth.uid())) = 'admin');