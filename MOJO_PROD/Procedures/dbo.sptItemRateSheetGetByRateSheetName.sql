USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemRateSheetGetByRateSheetName]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptItemRateSheetGetByRateSheetName]
	@CompanyKey Int,
	@RateSheetName varchar(200)

AS --Encrypt

/*
  || When     Who Rel		What
  || 04/28/09 MAS 10.5		Created
*/
	SELECT *
	FROM tItemRateSheet (NOLOCK)
	WHERE
		CompanyKey = @CompanyKey 
		And ltrim(rtrim(upper(RateSheetName))) = ltrim(rtrim(upper(@RateSheetName)))
GO
