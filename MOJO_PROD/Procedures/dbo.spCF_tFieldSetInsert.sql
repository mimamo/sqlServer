USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tFieldSetInsert]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_tFieldSetInsert]
 @OwnerEntityKey int,
 @AssociatedEntity varchar(50),
 @FieldSetName varchar(75),
 @Active tinyint = 1,
 @UserKey int = null,
 @oIdentity INT OUTPUT
AS --Encrypt
 INSERT tFieldSet
  (
  OwnerEntityKey,
  AssociatedEntity,
  FieldSetName,
  Active,
  CreatedByKey,
  CreatedByDate,
  UpdatedByKey,
  DateUpdated
  )
 VALUES
  (
  @OwnerEntityKey,
  @AssociatedEntity,
  @FieldSetName,
  @Active,
  @UserKey,
  GETUTCDATE(),
  @UserKey,
  GETUTCDATE()
  )
 
 SELECT @oIdentity = @@IDENTITY
 RETURN 1
GO
