USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSubscriptionGet]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSubscriptionGet]
 @FolderKey uniqueidentifier,
 @UserKey int
AS --Encrypt
 if exists (SELECT *
   FROM tSubscription (NOLOCK) 
  WHERE FolderKey = @FolderKey
       AND UserKey = @UserKey)
  return 1
 else
  return 0
GO
