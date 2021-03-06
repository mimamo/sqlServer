USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spSecurityDeleteRight]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSecurityDeleteRight]
 (
  @EntityType varchar(35),
  @EntityKey  int,
  @RightID varchar(35)
 )
AS --Encrypt
 
  
  DELETE tRightAssigned
  FROM   tRight r (NOLOCK)
  WHERE  tRightAssigned.EntityType = @EntityType
  AND    tRightAssigned.EntityKey  = @EntityKey
  AND    tRightAssigned.RightKey   = r.RightKey
  AND    UPPER(LTRIM(RTRIM(r.RightID))) = UPPER(LTRIM(RTRIM(@RightID)))
  IF @@ERROR <> 0  
   RETURN -1
  
  EXEC spSecurityGetRight @EntityType, @EntityKey, @RightID
 
 /* set nocount on */
 return 1
GO
