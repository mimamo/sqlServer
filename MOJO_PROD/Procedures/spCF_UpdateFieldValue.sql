use mojo_prod
go

alter PROCEDURE spCF_UpdateFieldValue
 @CustomFieldKey int,
 @FieldName varchar(75),
 @FieldValue varchar(8000)
AS --Encrypt
Declare @FieldValueKey as uniqueidentifier, @FieldDefKey int
  
Select @FieldDefKey = MIN(fd.FieldDefKey)
From 
	tFieldDef fd (nolock)
	inner join tFieldSetField fsf (nolock) 
		on fd.FieldDefKey = fsf.FieldDefKey
	inner join tObjectFieldSet ofs (nolock) 
		on ofs.FieldSetKey = fsf.FieldSetKey
Where
	fd.FieldName = @FieldName and
	ofs.ObjectFieldSetKey = @CustomFieldKey
  
  if ISNULL(@FieldDefKey, 0) = 0 
	return -1
  
  SELECT 
   @FieldValueKey = FieldValueKey
  FROM 
   tFieldValue (NOLOCK)
  WHERE 
   FieldDefKey = @FieldDefKey AND
   ObjectFieldSetKey = @CustomFieldKey
   
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
   @CustomFieldKey,
   @FieldValue
   ) 
 ELSE
  UPDATE
   tFieldValue
  SET
   FieldValue = @FieldValue
  WHERE
   FieldValueKey = @FieldValueKey 
  RETURN 1