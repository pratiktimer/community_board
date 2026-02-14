CREATE OR REPLACE FUNCTION public.get_user_role(p_user_id UUID)
RETURNS TEXT
LANGUAGE sql
STABLE -- STABLE because it only searches without changing data
SECURITY INVOKER -- Run with the caller's privileges (requires SELECT permission on the profiles table)
SET search_path TO public
AS $$
  SELECT role FROM public.profiles WHERE id = p_user_id;
$$;