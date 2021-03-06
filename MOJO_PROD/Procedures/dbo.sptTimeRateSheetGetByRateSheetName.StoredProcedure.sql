USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeRateSheetGetByRateSheetName]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeRateSheetGetByRateSheetName]
	@CompanyKey Int,
	@RateSheetName varchar(200)

AS --Encrypt

/*
  || When     Who Rel		What
  || 01/5/11  RLB 10.340   (98389) Created
*/
	SELECT *
	FROM tTimeRateSheet (NOLOCK)
	WHERE
		CompanyKey = @CompanyKey 
		And ltrim(rtrim(upper(RateSheetName))) = ltrim(rtrim(upper(@RateSheetName)))
GO
