USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRightAssignedUpdate]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRightAssignedUpdate]
 @RightAssignedKey int,
 @EntityType varchar(35),
 @EntityKey int,
 @RightKey int
AS --Encrypt
 UPDATE
  tRightAssigned
 SET
  EntityType = @EntityType,
  EntityKey = @EntityKey,
  RightKey = @RightKey
 WHERE
  RightAssignedKey = @RightAssignedKey 
 RETURN 1
GO
