USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spForumGetAccountList]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spForumGetAccountList]
 (
  @AccountID int
 )
AS --Encrypt
 SELECT 
  ForumTable.AccountID, ForumTable.ForumID, MsgTable.MsgTitle
 FROM 
  ForumTable (nolock) INNER JOIN
  MsgTable (nolock) ON 
  ForumTable.ForumID = MsgTable.ForumID
 WHERE 
  (ForumTable.AccountID = @AccountID) AND 
  (MsgTable.MsgColumn = 0) AND (MsgTable.MsgNode = 0)
GO
