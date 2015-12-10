USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCBBatchInsert]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCBBatchInsert]
	@CompanyKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@AccountingDate smalldatetime,
	@Type smallint,
	@LaborRateSheetKey int,
	@ExpRateSheetKey int,
	@Adjusted tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tCBBatch
		(
		CompanyKey,
		StartDate,
		EndDate,
		AccountingDate,
		Type,
		LaborRateSheetKey,
		ExpRateSheetKey,
		Adjusted
		)

	VALUES
		(
		@CompanyKey,
		@StartDate,
		@EndDate,
		@AccountingDate,
		@Type,
		@LaborRateSheetKey,
		@ExpRateSheetKey,
		@Adjusted
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
