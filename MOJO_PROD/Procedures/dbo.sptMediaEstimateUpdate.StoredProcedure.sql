USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaEstimateUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaEstimateUpdate]
	@MediaEstimateKey int,
	@CompanyKey int,
	@ClientKey int,
	@EstimateID varchar(50),
	@EstimateName varchar(200),
	@CampaignKey int,
	@ProjectKey int,
	@TaskKey int,
	@ClientDivisionKey int,
	@ClientProductKey int,
	@Description text,
	@FlightStartDate smalldatetime,
	@FlightEndDate smalldatetime,
	@FlightInterval tinyint,
	@Active tinyint,
	@IOOrderDisplayMode smallint,
	@BCOrderDisplayMode smallint,
	@ClassKey int,
	@GLCompanyKey int,
	@OfficeKey int,
	@IOBillAt smallint,
	@BCBillAt smallint

AS --Encrypt

/*
|| When     Who Rel     What
|| 11/16/06 CRG 8.3571  Added ClassKey parameter.
|| 08/27/07 BSH 8.5		Added GLCompanyKey and OfficeKey parameters. 
|| 02/26/13 GHL 10.565  (165725) Added IOBillAt and BCBillAt
*/

	If exists(Select 1 from tMediaEstimate (nolock) Where EstimateID = @EstimateID and CompanyKey = @CompanyKey and MediaEstimateKey <> @MediaEstimateKey)
		Return -1

	UPDATE
		tMediaEstimate
	SET
		CompanyKey = @CompanyKey,
		ClientKey = @ClientKey,
		EstimateID = @EstimateID,
		EstimateName = @EstimateName,
		CampaignKey = @CampaignKey,
		ProjectKey = @ProjectKey,
		TaskKey = @TaskKey,
		ClientDivisionKey = @ClientDivisionKey,
		ClientProductKey = @ClientProductKey,
		Description = @Description,
		FlightStartDate = @FlightStartDate,
		FlightEndDate = @FlightEndDate,
		FlightInterval = @FlightInterval,
		Active = @Active,
		IOOrderDisplayMode = @IOOrderDisplayMode,
		BCOrderDisplayMode = @BCOrderDisplayMode,
		ClassKey = @ClassKey,
		GLCompanyKey = @GLCompanyKey,
		OfficeKey = @OfficeKey,
		IOBillAt = @IOBillAt,
		BCBillAt = @BCBillAt
	WHERE
		MediaEstimateKey = @MediaEstimateKey 

	RETURN 1
GO
