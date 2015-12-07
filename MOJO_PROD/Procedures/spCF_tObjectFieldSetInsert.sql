CREATE PROCEDURE spCF_tObjectFieldSetInsert
 @FieldSetKey int,
 @oIdentity INT OUTPUT
AS --Encrypt
 IF EXISTS (
  SELECT * 
  FROM 
   tFieldSet (NOLOCK)
  WHERE
   FieldSetKey = @FieldSetKey)
 BEGIN
  INSERT tObjectFieldSet
   (
   FieldSetKey
   )
  VALUES
   (
   @FieldSetKey
   )
 
  SELECT @oIdentity = @@IDENTITY
  RETURN 1
 END
 ELSE
  RETURN -1
 