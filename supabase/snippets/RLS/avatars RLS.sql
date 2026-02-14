-- public/userId/avatar/uuid.ext
-- 1. SELECT policy
CREATE POLICY "Allow authenticated users to list avatars"
ON storage.objects FOR SELECT
TO authenticated
USING ( bucket_id = 'avatars' );

-- 2. INSERT policy
CREATE POLICY "Allow users to upload their own avatar"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'avatars' AND
  auth.uid()::text = (storage.foldername(name))[2]
);

-- 3. UPDATE policy
CREATE POLICY "Allow users to update their own avatar"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'avatars' AND
  auth.uid()::text = (storage.foldername(name))[2]
);

-- 4. DELETE policy
CREATE POLICY "Allow users to delete their own avatar"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'avatars' AND
  auth.uid()::text = (storage.foldername(name))[2]
);