USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceGetMobile]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceGetMobile]
	@CompanyKey int
AS --Encrypt

/*
|| When     Who Rel     What
*/


	SELECT	tPreference.*
			,tTimeOption.ShowServicesOnGrid
			,tTimeOption.ReqProjectOnTime
			,tTimeOption.ReqServiceOnTime
			,tTimeOption.TimeSheetPeriod
			,tTimeOption.StartTimeOn
			,tTimeOption.AllowOverlap
			,tTimeOption.PrintAsGrid
			,tTimeOption.AllowCustomDates
	FROM	tPreference (NOLOCK) 
	left outer join tTimeOption (nolock) on tPreference.CompanyKey = tTimeOption.CompanyKey
	WHERE	tPreference.CompanyKey = @CompanyKey

 RETURN 1
GO
