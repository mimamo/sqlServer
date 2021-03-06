USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tFieldSetUpdate]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_tFieldSetUpdate]
 @FieldSetKey int,
 @OwnerEntityKey int,
 @AssociatedEntity varchar(50),
 @FieldSetName varchar(75),
 @Active tinyint = 1,
 @UserKey int = null
 
AS --Encrypt
 UPDATE
  tFieldSet
 SET
  OwnerEntityKey = @OwnerEntityKey,
  AssociatedEntity = @AssociatedEntity,
  FieldSetName = @FieldSetName,
  Active = @Active,
  UpdatedByKey = @UserKey,
  DateUpdated = GETUTCDATE()
 WHERE
  FieldSetKey = @FieldSetKey 
 RETURN 1
GO
