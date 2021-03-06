USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaPremiumDetailUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaPremiumDetailUpdate]
	@MediaPremiumDetailKey int = NULL,
	@MediaPremiumKey int,
	@CompanyMediaKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@AmountType varchar(50),
	@Amount decimal(24, 4),
	@CostBase varchar(50),
	@Commissionable tinyint,
	@Taxable tinyint,
	@Description varchar(MAX),
	@UserKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 07/08/13 MFT 10.570  Created
|| 02/03/14 PLC 10.576  Added date added and updated.
|| 03/11/14 GHL 10.578  Added UserKey param to update AddeBy and UpdatedBy
*/

IF ISNULL(@MediaPremiumDetailKey, 0) > 0
	UPDATE tMediaPremiumDetail
	SET
		MediaPremiumKey = @MediaPremiumKey,
		CompanyMediaKey = @CompanyMediaKey,
		StartDate = @StartDate,
		EndDate = @EndDate,
		AmountType = @AmountType,
		Amount = @Amount,
		CostBase = @CostBase,
		Commissionable = @Commissionable,
		Taxable = @Taxable,
		Description = @Description,
		-- below are system or default fields 
		DateUpdated = GETUTCDATE(),
		UpdatedBy = @UserKey
	WHERE
		MediaPremiumDetailKey = @MediaPremiumDetailKey
ELSE
	BEGIN
		INSERT INTO tMediaPremiumDetail
		(
			MediaPremiumKey,
			CompanyMediaKey,
			StartDate,
			EndDate,
			AmountType,
			Amount,
			CostBase,
			Commissionable,
			Taxable,
			Description,
			-- below are system or default fields 
			DateAdded,
			AddedBy
		)
		VALUES
		(
			@MediaPremiumKey,
			@CompanyMediaKey,
			@StartDate,
			@EndDate,
			@AmountType,
			@Amount,
			@CostBase,
			@Commissionable,
			@Taxable,
			@Description,
			-- below are system or default fields 
			GETUTCDATE(),
			@UserKey
		)
		
		SELECT @MediaPremiumDetailKey = SCOPE_IDENTITY()
	END
	
RETURN @MediaPremiumDetailKey
GO
