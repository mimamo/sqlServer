USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaContractUpdate]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaContractUpdate]
	@CompanyMediaContractKey int = NULL,
	@CompanyKey int,
	@ContractID varchar(50),
	@ContractName varchar(500),
	@CompanyMediaKey int,
	@MediaUnitTypeKey int,
	@CostBase tinyint,
	@StartDate smalldatetime,
	@EndDate smalldatetime
	
AS --Encrypt

/*
|| When     Who Rel     What
|| 06/17/13 MFT 10.569  Created
*/

IF EXISTS(
	SELECT *
	FROM tCompanyMediaContract (nolock)
	WHERE
		CompanyKey = @CompanyKey AND
		ContractID = @ContractID AND
		(
			ISNULL(@CompanyMediaContractKey, 0) = 0 OR
			CompanyMediaContractKey <> ISNULL(@CompanyMediaContractKey, 0)
		)
	) RETURN -1

IF ISNULL(@CompanyMediaContractKey, 0) > 0
	UPDATE
		tCompanyMediaContract
	SET
		CompanyKey = @CompanyKey,
		ContractID = @ContractID,
		ContractName = @ContractName,
		CompanyMediaKey = @CompanyMediaKey,
		MediaUnitTypeKey = @MediaUnitTypeKey,
		CostBase = @CostBase,
		StartDate = @StartDate,
		EndDate = @EndDate
	WHERE
		CompanyMediaContractKey = @CompanyMediaContractKey
ELSE
	BEGIN
		INSERT tCompanyMediaContract
		(
			CompanyKey,
			ContractID,
			ContractName,
			CompanyMediaKey,
			MediaUnitTypeKey,
			CostBase,
			StartDate,
			EndDate
		)
		VALUES
		(
			@CompanyKey,
			@ContractID,
			@ContractName,
			@CompanyMediaKey,
			@MediaUnitTypeKey,
			@CostBase,
			@StartDate,
			@EndDate
		)
		
		SELECT @CompanyMediaContractKey = SCOPE_IDENTITY()
	END

RETURN @CompanyMediaContractKey
GO
