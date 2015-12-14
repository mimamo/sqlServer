USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserNotificationUpdate]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserNotificationUpdate]
	@UserKey int,
	@NotificationID varchar(20),
	@Value int,
	@Value2 int,
	@Selected tinyint

AS --Encrypt

if @Selected = 1
BEGIN
	IF EXISTS(
		SELECT 1 FROM tUserNotification (NOLOCK)
		WHERE UserKey = @UserKey AND NotificationID = @NotificationID)

		UPDATE
			tUserNotification
		SET
			Value = @Value,
			Value2 = @Value2
		WHERE
			UserKey = @UserKey AND NotificationID = @NotificationID
	ELSE
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
END
ELSE
BEGIN

	DELETE tUserNotification WHERE UserKey = @UserKey AND NotificationID = @NotificationID

END

RETURN 1
GO
