USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spForumUpdate]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spForumUpdate]
 @ForumKey int,
 @ForumName varchar(200),
 @Description varchar(1000),
 @AssociatedEntity varchar(50),
 @EntityKey int,
 @Active tinyint
AS --Encrypt
 IF EXISTS (SELECT 1
            FROM   tForum (nolock)
            WHERE  AssociatedEntity = @AssociatedEntity
            AND    EntityKey = @EntityKey
            AND    Active = 1
            AND    UPPER(LTRIM(RTRIM(ForumName))) = UPPER(LTRIM(RTRIM(@ForumName)))
            AND    ForumKey <> @ForumKey
            )    
  RETURN -1
  
 UPDATE
  tForum
 SET
  ForumName = @ForumName,
  Description = @Description,
  AssociatedEntity = @AssociatedEntity,
  EntityKey = @EntityKey,
  Active = @Active
 WHERE
  ForumKey = @ForumKey 
 RETURN 1
GO
