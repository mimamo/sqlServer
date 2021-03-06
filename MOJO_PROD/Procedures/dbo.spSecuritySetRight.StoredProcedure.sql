USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spSecuritySetRight]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSecuritySetRight]
 (
  @EntityType varchar(35),
  @EntityKey  int,
  @RightID varchar(35)
 )
AS --Encrypt
 
  BEGIN TRANSACTION
  
  DELETE tRightAssigned
  FROM   tRight r (NOLOCK)
  WHERE  tRightAssigned.EntityType = @EntityType
  AND    tRightAssigned.EntityKey  = @EntityKey
  AND    tRightAssigned.RightKey   = r.RightKey
  AND    UPPER(LTRIM(RTRIM(r.RightID))) = UPPER(LTRIM(RTRIM(@RightID)))
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
  AND    UPPER(LTRIM(RTRIM(r.RightID))) = UPPER(LTRIM(RTRIM(@RightID)))
  IF @@ERROR <> 0
  BEGIN
   ROLLBACK TRANSACTION
   RETURN -1
  END
  COMMIT TRANSACTION
  
  EXEC spSecurityGetRight @EntityType, @EntityKey, @RightID
 
 /* set nocount on */
 return 1
GO
