USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spForumInsert]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spForumInsert]
 @ForumName varchar(200),
 @Description varchar(1000),
 @AssociatedEntity varchar(50),
 @EntityKey int,
 @Active tinyint,
 @oIdentity INT OUTPUT
AS --Encrypt
 IF @Active IS NULL
  SELECT @Active = 1
 IF EXISTS (SELECT 1
            FROM   tForum (nolock)
            WHERE  AssociatedEntity = @AssociatedEntity
            AND    EntityKey = @EntityKey
            AND    Active = 1
            AND    UPPER(LTRIM(RTRIM(ForumName))) = UPPER(LTRIM(RTRIM(@ForumName)))
            )    
  RETURN -1
  
 INSERT tForum
  (
  ForumName,
  Description,
  AssociatedEntity,
  EntityKey,
  Active
  )
 VALUES
  (
  @ForumName,
  @Description,
  @AssociatedEntity,
  @EntityKey,
  @Active
  )
 
 SELECT @oIdentity = @@IDENTITY
 RETURN 1
GO
