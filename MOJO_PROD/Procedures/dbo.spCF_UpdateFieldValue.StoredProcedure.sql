USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_UpdateFieldValue]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_UpdateFieldValue]
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
GO
