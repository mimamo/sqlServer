USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSubscriptionDelete]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSubscriptionDelete]
 @FolderKey uniqueidentifier,
 @UserKey int
AS --Encrypt
 DELETE
 FROM tSubscription
 WHERE FolderKey = @FolderKey
          AND UserKey = @UserKey
 RETURN 1
GO
