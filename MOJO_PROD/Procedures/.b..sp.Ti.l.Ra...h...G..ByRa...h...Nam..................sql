USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTitleRateSheetGetByRateSheetName]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTitleRateSheetGetByRateSheetName]
	@CompanyKey Int,
	@RateSheetName varchar(200)

AS --Encrypt

/*
  || When     Who Rel		What
  || 02/18/15 GHL 10.589   Created to validate title rate sheets for Abelson Taylor Imports
*/
	SELECT *
	FROM tTitleRateSheet (NOLOCK)
	WHERE
		CompanyKey = @CompanyKey 
		And ltrim(rtrim(upper(RateSheetName))) = ltrim(rtrim(upper(@RateSheetName)))
GO
