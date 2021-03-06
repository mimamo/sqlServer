USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendar454Update]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendar454Update]
	@CompanyKey int
	,@CalendarID varchar(50)
	,@CalendarDate smalldatetime
	,@FiscalYear int
	,@FiscalQuarter smallint
	,@FiscalMonth smallint
	,@FiscalWeek smallint

AS --Encrypt

/*
|| When      Who Rel      What
|| 05/01/15  GHL 10.5.9.1 (250963) Creation for Kohls enhancement
*/

	select @CalendarDate = convert(datetime,  convert(varchar(10), @CalendarDate, 101), 101)
	select @CalendarID = upper(@CalendarID)

	update tCalendar454
	set    FiscalYear = @FiscalYear
	      ,FiscalQuarter = @FiscalQuarter	 
		  ,FiscalMonth = @FiscalMonth	 
		  ,FiscalWeek = @FiscalWeek	 
	where  CompanyKey = @CompanyKey
	and    CalendarID = @CalendarID
	and    CalendarDate = @CalendarDate

	if @@ROWCOUNT = 0
		insert tCalendar454 (CompanyKey, CalendarID, CalendarDate, FiscalYear, FiscalQuarter, FiscalMonth, FiscalWeek)
		values (@CompanyKey, @CalendarID, @CalendarDate,@FiscalYear, @FiscalQuarter, @FiscalMonth, @FiscalWeek) 


	RETURN 1
GO
