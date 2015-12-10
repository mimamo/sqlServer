USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserNotificationInsert]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserNotificationInsert]
	@UserKey int,
	@NotificationID varchar(20),
	@Value int,
	@Value2 int
AS --Encrypt

	INSERT tUserNotification
		(
		UserKey,
		NotificationID,
		Value,
		Value2
		)

	VALUES
		(
		@UserKey,
		@NotificationID,
		@Value,
		@Value2
		)
	

	RETURN 1
GO
