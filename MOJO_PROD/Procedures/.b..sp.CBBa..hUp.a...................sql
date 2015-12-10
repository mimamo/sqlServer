USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCBBatchUpdate]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCBBatchUpdate]
	@CBBatchKey int,
	@CompanyKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@AccountingDate smalldatetime,
	@Type smallint,
	@LaborRateSheetKey int,
	@ExpRateSheetKey int,
	@Adjusted tinyint

AS --Encrypt

	UPDATE
		tCBBatch
	SET
		CompanyKey = @CompanyKey,
		StartDate = @StartDate,
		EndDate = @EndDate,
		AccountingDate = @AccountingDate,
		Type = @Type,
		LaborRateSheetKey = @LaborRateSheetKey,
		ExpRateSheetKey = @ExpRateSheetKey,
		Adjusted = @Adjusted
	WHERE
		CBBatchKey = @CBBatchKey 

	RETURN 1
GO
