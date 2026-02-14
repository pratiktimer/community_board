-- Enable RLS for profiles table
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- SELECT policy
-- Any logged-in user can read anyone else's profile information
CREATE POLICY "Allow authenticated users to read all profile information"
ON public.profiles
FOR SELECT
TO authenticated -- the policy applies to all users who are 'authenticated', i.e., logged in
USING (true);

-- UPDATE Policy
-- Users can only update their own profile.
CREATE POLICY "User can update own profile"
ON public.profiles
FOR UPDATE
TO authenticated
USING ((SELECT auth.uid()) = id)
WITH CHECK ((SELECT auth.uid()) = id);

-- First, revoke all ‘UPDATE’ privileges for the entire table.
REVOKE UPDATE ON public.profiles FROM authenticated;

-- Grant permission to update only the necessary columns again.
GRANT UPDATE (username, avatar_url) ON public.profiles TO authenticated;