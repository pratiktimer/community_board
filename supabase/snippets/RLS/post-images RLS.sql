-- 1. SELECT Policy
CREATE POLICY "Allow authenticated users to list post images"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'post-images'
);

-- 2. INSERT Policy
CREATE POLICY "Allow admin to upload post images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'post-images' AND
  public.get_user_role(auth.uid()) = 'admin'
);

-- 3. UPDATE Policy
CREATE POLICY "Allow admin to update own post images"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'post-images' AND
  owner_id::uuid = (select auth.uid()) AND
  public.get_user_role(auth.uid()) = 'admin'
);

-- 4. DELETE Policy
CREATE POLICY "Allow admin to delete own post images"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'post-images' AND
  owner_id::uuid = (select auth.uid()) AND
  public.get_user_role(auth.uid()) = 'admin'
);