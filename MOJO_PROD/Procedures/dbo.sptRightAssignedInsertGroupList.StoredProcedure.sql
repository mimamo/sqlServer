USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRightAssignedInsertGroupList]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptRightAssignedInsertGroupList]
 (
  @RightGroup varchar(35),
  @EntityType varchar(35),
  @EntityKey varchar(35)
 )
AS --Encrypt
 -- Assume in VB code 
 /*
 CREATE TABLE #tAssigned 
  (RightKey        int NULL)
 */
 
 BEGIN TRANSACTION
 
 DELETE tRightAssigned
 FROM   tRight                  r (NOLOCK)
 WHERE  tRightAssigned.RightKey  = r.RightKey
 AND    r.RightGroup            = @RightGroup
 AND    tRightAssigned.EntityType = @EntityType
 AND    tRightAssigned.EntityKey = @EntityKey
 
 IF @@ERROR <> 0
 BEGIN
  ROLLBACK TRANSACTION
  RETURN  -1
 END
 
 DELETE #tAssigned
 FROM   tRight                  r (NOLOCK)
 WHERE  #tAssigned.RightKey     = r.RightKey
 AND    r.RightGroup           <> @RightGroup 
 IF @@ERROR <> 0
 BEGIN
  ROLLBACK TRANSACTION
  RETURN  -1
 END
 INSERT tRightAssigned (EntityType, EntityKey, RightKey)
 SELECT  @EntityType
        ,@EntityKey
        ,#tAssigned.RightKey
 FROM   #tAssigned
  
 IF @@ERROR <> 0
 BEGIN
  ROLLBACK TRANSACTION
  RETURN  -1
 END
 
 COMMIT TRANSACTION
  
 /* set nocount on */
 return 1
GO
