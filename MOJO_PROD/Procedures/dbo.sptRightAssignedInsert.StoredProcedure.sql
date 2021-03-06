USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRightAssignedInsert]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRightAssignedInsert]
 @EntityType varchar(35),
 @EntityKey int,
 @RightKey int,
 @oIdentity INT OUTPUT
AS --Encrypt
 INSERT tRightAssigned
  (
  EntityType,
  EntityKey,
  RightKey
  )
 VALUES
  (
  @EntityType,
  @EntityKey,
  @RightKey
  )
 
 SELECT @oIdentity = @@IDENTITY
 RETURN 1
GO
