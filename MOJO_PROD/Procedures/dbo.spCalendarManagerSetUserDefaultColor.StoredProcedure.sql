USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerSetUserDefaultColor]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerSetUserDefaultColor]
	@UserKey int,
	@DefaultCalendarColor varchar(50)
AS

/*
|| When      Who Rel      What
|| 12/22/08  CRG 10.5.0.0 Created for the calendar manager to update the default color for a user
*/

	UPDATE	tUser
	SET		DefaultCalendarColor = @DefaultCalendarColor
	WHERE	UserKey = @UserKey
GO
