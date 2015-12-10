USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spSecurityDeleteRights]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSecurityDeleteRights]
 (
  @EntityType varchar(35),
  @EntityKey  int,
  @RightGroup varchar(35)
 )
AS --Encrypt
 IF @RightGroup IS NULL
 BEGIN
  
  DELETE tRightAssigned
  WHERE  tRightAssigned.EntityType = @EntityType
  AND    tRightAssigned.EntityKey = @EntityKey
  
  IF @@ERROR <> 0
   RETURN -1
  
 END
 
 ELSE
 
 BEGIN
  
  DELETE tRightAssigned
  FROM   tRight r (NOLOCK)
  WHERE  tRightAssigned.EntityType = @EntityType
  AND    tRightAssigned.EntityKey  = @EntityKey
  AND    tRightAssigned.RightKey   = r.RightKey
  AND    UPPER(LTRIM(RTRIM(r.RightGroup))) = UPPER(LTRIM(RTRIM(@RightGroup)))
  IF @@ERROR <> 0
   RETURN -1
  
 END
 
 
 EXEC spSecurityGetRights @EntityType, @EntityKey, @RightGroup
 
 /* set nocount on */
 return 1
GO
