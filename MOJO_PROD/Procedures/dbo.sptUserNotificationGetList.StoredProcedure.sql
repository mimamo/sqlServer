USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserNotificationGetList]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserNotificationGetList]

	@UserKey int


AS --Encrypt

		SELECT 
			n.*,
			(Select un.Value from tUserNotification un (nolock) Where UserKey = @UserKey and NotificationID = n.NotificationID) as Value,
			(Select un.Value2 from tUserNotification un (nolock) Where UserKey = @UserKey and NotificationID = n.NotificationID) as Value2,
			(Select un2.UserKey from tUserNotification un2 (nolock) Where UserKey = @UserKey and NotificationID = n.NotificationID) as UserKey
		FROM 
			tNotification n (nolock)
		Order By DisplayGroup, DisplayOrder
GO
