USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarTypeGet]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarTypeGet]
	@CalendarTypeKey int

AS --Encrypt

		SELECT *
		FROM tCalendarType (nolock)
		WHERE
			CalendarTypeKey = @CalendarTypeKey

	RETURN 1
GO
