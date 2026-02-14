-- Enable RLS on the comments table
ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;

-- SELECT Policy
-- Authenticated users can view all comments.
CREATE POLICY "Allow authenticated users to read all comments"
ON public.comments
FOR SELECT
TO authenticated -- Applies to the ‘authenticated’ role
USING (true);

-- INSERT Policy
-- Authenticated users can create comments, and the user_id must be their own.
CREATE POLICY "Allow authenticated users to create comments"
ON public.comments
FOR INSERT
TO authenticated -- Roles that can attempt INSERT (authenticated users)
WITH CHECK (user_id = (SELECT auth.uid()));

-- UPDATE Policy
-- Users can only edit their own comments.
CREATE POLICY "Allow users to update their own comments"
ON public.comments
FOR UPDATE
TO authenticated -- Roles that can attempt UPDATE
USING (user_id = (SELECT auth.uid()))
WITH CHECK (user_id = (SELECT auth.uid()));

-- DELETE Policy
-- Users can delete their own comments.
CREATE POLICY "Allow users to delete their own comments"
ON public.comments
FOR DELETE
TO authenticated -- Roles that can attempt DELETE
USING (user_id = (SELECT auth.uid()));

-- Administrators can delete all comments.
CREATE POLICY "Allow admin to delete any comments"
ON public.comments
FOR DELETE
TO authenticated -- Roles that can attempt DELETE (administrators are also authenticated users)
USING (public.get_user_role((SELECT auth.uid())) = 'admin');