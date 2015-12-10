USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendar454Delete]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendar454Delete]
	@CompanyKey int
	,@CalendarID varchar(50)
	,@CalendarDate smalldatetime

AS --Encrypt

/*
|| When      Who Rel      What
|| 05/01/15  GHL 10.5.9.1 (250963) Creation for Kohls enhancement
*/

	select @CalendarDate = convert(datetime,  convert(varchar(10), @CalendarDate, 101), 101)

	DELETE
	FROM	tCalendar454
	WHERE	CompanyKey = @CompanyKey
	AND		CalendarID = upper(@CalendarID)
	AND     CalendarDate = @CalendarDate	 

	RETURN 1
GO
