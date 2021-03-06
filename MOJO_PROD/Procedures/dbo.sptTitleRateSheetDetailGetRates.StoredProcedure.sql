USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTitleRateSheetDetailGetRates]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTitleRateSheetDetailGetRates]
 (
  @CompanyKey int,
  @TitleRateSheetKey int
 )
AS --Encrypt

/*
|| When       Who Rel      What
|| 09/17/2014 WDF 10.5.8.4 New
*/ 

Select
	 t.TitleKey
	,t.TitleID
	,t.TitleName
	,ISNULL(trs.HourlyRate, isnull(t.HourlyRate, 0)) as HourlyRate
From
	tTitle t (nolock)
	Left outer join 
		(Select * from tTitleRateSheetDetail (NOLOCK) Where TitleRateSheetKey = @TitleRateSheetKey) as trs on t.TitleKey = trs.TitleKey
	Where
		t.CompanyKey = @CompanyKey and t.Active = 1

Order by t.TitleID	

return 1
GO
