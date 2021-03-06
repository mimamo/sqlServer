USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tObjectFieldSetInsert]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_tObjectFieldSetInsert]
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
GO
