
CREATE PROCEDURE spCF_tFieldValueUpdate
 @FieldDefKey int,
 @ObjectFieldSetKey int,
 @FieldValue varchar(8000)
AS --Encrypt
Declare @FieldValueKey as uniqueidentifier
  
  SELECT 
   @FieldValueKey = FieldValueKey
  FROM 
   tFieldValue (NOLOCK)
  WHERE 
   FieldDefKey = @FieldDefKey AND
   ObjectFieldSetKey = @ObjectFieldSetKey
   
 IF @FieldValueKey IS NULL
  INSERT tFieldValue
   (
   FieldValueKey,
   FieldDefKey,
   ObjectFieldSetKey,
   FieldValue
   )
  VALUES
   (
   NEWID(),
   @FieldDefKey,
   @ObjectFieldSetKey,
   @FieldValue
   ) 
 ELSE
  UPDATE
   tFieldValue
  SET
   FieldDefKey = @FieldDefKey,
   ObjectFieldSetKey = @ObjectFieldSetKey,
   FieldValue = @FieldValue
  WHERE
   FieldValueKey = @FieldValueKey 
  RETURN 1

