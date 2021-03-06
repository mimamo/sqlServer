USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaEstimateInsert]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaEstimateInsert]
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
	@BCBillAt smallint,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel     What
|| 11/16/06 CRG 8.3571  Added ClassKey parameter.
|| 08/27/07 BSH 8.5		Added GLCompanyKey and OfficeKey parameters.
|| 02/26/13 GHL 10.565  (165725) Added IOBillAt and BCBillAt
*/

	If exists(Select 1 from tMediaEstimate (nolock) Where EstimateID = @EstimateID and CompanyKey = @CompanyKey)
		Return -1

	INSERT tMediaEstimate
		(
		CompanyKey,
		ClientKey,
		EstimateID,
		EstimateName,
		CampaignKey,
		ProjectKey,
		TaskKey,
		ClientDivisionKey,
		ClientProductKey,
		Description,
		FlightStartDate,
		FlightEndDate,
		FlightInterval,
		Active,
		IOOrderDisplayMode,
		BCOrderDisplayMode,
		ClassKey,
		GLCompanyKey,
		OfficeKey,
		IOBillAt,
		BCBillAt
		)

	VALUES
		(
		@CompanyKey,
		@ClientKey,
		@EstimateID,
		@EstimateName,
		@CampaignKey,
		@ProjectKey,
		@TaskKey,
		@ClientDivisionKey,
		@ClientProductKey,
		@Description,
		@FlightStartDate,
		@FlightEndDate,
		@FlightInterval,
		@Active,
		@IOOrderDisplayMode,
		@BCOrderDisplayMode,
		@ClassKey,
		@GLCompanyKey,
		@OfficeKey,
		@IOBillAt,
		@BCBillAt
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
