USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spForumDelete]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spForumDelete]
 @ForumKey int
AS --Encrypt

/*
 IF EXISTS (SELECT 1
            FROM   tMessageForum (NOLOCK)
            WHERE  ForumKey = @ForumKey)
  RETURN -1
*/ 
 
 DELETE
 FROM tMessageForum
 WHERE ForumKey = @ForumKey 
 
 DELETE
 FROM tForum
 WHERE ForumKey = @ForumKey 
 RETURN 1
GO
