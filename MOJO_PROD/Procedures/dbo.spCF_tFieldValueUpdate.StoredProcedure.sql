USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tFieldValueUpdate]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_tFieldValueUpdate]
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
GO
