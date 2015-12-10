USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spForumGetList]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spForumGetList]
 @AssociatedEntity varchar(50)
 ,@EntityKey int
 ,@Active tinyint
AS --Encrypt
  SELECT *
  FROM tForum (nolock)
  WHERE
   AssociatedEntity = @AssociatedEntity
  AND EntityKey = @EntityKey
  AND (Active = @Active OR @Active IS NULL)
  ORDER BY ForumName
  
 RETURN 1
GO
