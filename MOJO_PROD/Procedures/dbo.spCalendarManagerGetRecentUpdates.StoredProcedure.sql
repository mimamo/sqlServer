USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerGetRecentUpdates]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerGetRecentUpdates]
	@CompanyKey int,
	@CheckTime smalldatetime --must be UTC
AS

/*
|| When      Who Rel      What
|| 7/19/12   CRG 10.5.5.8 Created
*/

	SELECT DISTINCT	CalendarKey
	FROM	tCalendarUpdateLog (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		ActionDate >= @CheckTime
GO
