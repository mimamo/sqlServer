USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spSecuritySetRights]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSecuritySetRights]
 (
  @EntityType varchar(35),
  @EntityKey  int,
  @RightGroup varchar(35)
 )
AS --Encrypt
 IF @RightGroup IS NULL
 BEGIN
  BEGIN TRANSACTION
  
  DELETE tRightAssigned
  WHERE  tRightAssigned.EntityType = @EntityType
  AND    tRightAssigned.EntityKey = @EntityKey
  
  IF @@ERROR <> 0
  BEGIN
   ROLLBACK TRANSACTION
   RETURN -1
  END
  
  INSERT tRightAssigned (EntityType, EntityKey, RightKey)
  SELECT DefaultType, DefaultKey, RightKey
  FROM   tRightDefaults (nolock)
  WHERE  DefaultType = @EntityType
  AND    DefaultKey  = @EntityKey
  
  IF @@ERROR <> 0
  BEGIN
   ROLLBACK TRANSACTION
   RETURN -1
  END
  COMMIT TRANSACTION
  
 END
 
 ELSE
 
 BEGIN
  BEGIN TRANSACTION
  
  DELETE tRightAssigned
  FROM   tRight r (NOLOCK)
  WHERE  tRightAssigned.EntityType = @EntityType
  AND    tRightAssigned.EntityKey  = @EntityKey
  AND    tRightAssigned.RightKey   = r.RightKey
  AND    UPPER(LTRIM(RTRIM(r.RightGroup))) = UPPER(LTRIM(RTRIM(@RightGroup)))
  IF @@ERROR <> 0
  BEGIN
   ROLLBACK TRANSACTION
   RETURN -1
  END
  
  INSERT tRightAssigned (EntityType, EntityKey, RightKey)
  SELECT rd.DefaultType, rd.DefaultKey, rd.RightKey
  FROM   tRightDefaults rd (NOLOCK)
        ,tRight         r  (NOLOCK)
  WHERE  rd.DefaultType = @EntityType
  AND    rd.DefaultKey  = @EntityKey
  AND    rd.RightKey    = r.RightKey
  AND    UPPER(LTRIM(RTRIM(r.RightGroup))) = UPPER(LTRIM(RTRIM(@RightGroup)))
  IF @@ERROR <> 0
  BEGIN
   ROLLBACK TRANSACTION
   RETURN -1
  END
  COMMIT TRANSACTION
  
 END
 
 EXEC spSecurityGetRights @EntityType, @EntityKey, @RightGroup
 /* set nocount on */
 return 1
GO
