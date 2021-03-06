USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeRateSheetDetailGetRates]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTimeRateSheetDetailGetRates]
 (
  @CompanyKey int,
  @TimeRateSheetKey int
 )
AS --Encrypt

/*
|| When     Who Rel      What
|| 03/16/08 MAS 10.5.2   (76968)Added the Order By clause (ServiceCode)
*/ 
Select
	s.ServiceKey,
	s.ServiceCode,
	s.Description,
	ISNULL(srs.HourlyRate1, isnull(s.HourlyRate1, 0)) as Rate1,
	ISNULL(srs.HourlyRate2, isnull(s.HourlyRate2, 0)) as Rate2,
	ISNULL(srs.HourlyRate3, isnull(s.HourlyRate3, 0)) as Rate3,
	ISNULL(srs.HourlyRate4, isnull(s.HourlyRate4, 0)) as Rate4,
	ISNULL(srs.HourlyRate5, isnull(s.HourlyRate5, 0)) as Rate5
	
From
	tService s (nolock)
	Left outer join 
		(Select * from tTimeRateSheetDetail (NOLOCK) Where TimeRateSheetKey = @TimeRateSheetKey) as srs on s.ServiceKey = srs.ServiceKey
	Where
		s.CompanyKey = @CompanyKey and s.Active = 1

Order by s.ServiceCode	
return 1
GO
