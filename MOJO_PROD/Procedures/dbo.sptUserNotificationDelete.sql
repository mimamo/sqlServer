USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserNotificationDelete]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserNotificationDelete]
	@UserKey int

AS --Encrypt

	DELETE
	FROM tUserNotification
	WHERE
		UserKey = @UserKey 

	RETURN 1
GO
