USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignUpdate]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignUpdate]
	@CampaignKey int,
	@UserKey int,
	@CompanyKey int,
	@CampaignID varchar(50),
	@CampaignName varchar(200),
	@ClientKey int,
	@Description varchar(4000),
	@Objective text,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@AEKey int,
	@Active tinyint,
	@CustomFieldKey int,
	@GetActualsBy smallint,
	@LayoutKey int = null,
	@MultipleSegments tinyint = null,
	@BillBy smallint = null,
	@OneLinePer smallint = null,
	@ContactKey int = null,
	@GLCompanyKey int = null,
	@ClientDivisionKey int = null,
	@ClientProductKey int = null,
	@NextProjectNum int = 1,
	@CurrencyID varchar(10) = null

AS --Encrypt

/*
|| When      Who Rel      What
|| 5/23/07   CRG 8.4.3    (9293) Added GetActualsBy
|| 12/15/09  CRG 10.5.1.5 Added insert logic
|| 1/19/10   CRG 10.5.1.7 Added @MultipleSegments parameter.  Also made @MultipleSegments and @LayoutKey optional for compatability with CMP and old WMJ screens.
|| 2/3/10    CRG 10.5.1.8 Added optional parameter @BillBy
|| 2/25/10   GWG 10.5.2.0 Added One line per optional param
|| 4/6/10    GHL 10.5.2.1 Added ContactKey param
|| 11/2/10   CRG 10.5.3.7 (92555) Now if MultipleSegments is turned off, we are setting the CampaignSegmentKey to NULL in tProject and deleting the Campaign Segments.
|| 03/02/11  GHL 10.5.4.1 (103729) Added logic to get a campaign id/number for enhancement
|| 04/25/12  GHL 10.5.5.5 Added GLCompanyKey param, the logic for the validation of the GLCompanyKey will be
||                        If GLCompanyKey is null, all projects must have a null GLCompanyKey
||                        If GLCompanyKey is >0, all projects must have the same GLCompanyKey Or 
||                        tGLCompanyMap.TargetGLCompanyKey where SourceGLCompanyKey = GLCompanyKey
|| 11/6/12   WDF 10.5.6.2 (157606) Added ClientDivisionKey and ClientProductKey parameters.
|| 01/22/13  MAS 10.5.6.4 Added UserKey parameters and logging when the active flag is changed
|| 06/18/13  GHL 10.5.6.9 (181721) Added next project number for new project numbers by campaign
|| 07/25/13  GHL 10.5.7.0 Error out if CampaignID is null
|| 10/07/13  GHL 10.5.7.3 Added currency ID to support multi currency
|| 11/07/13  WDF 10.5.7.4 (195877) Error Out if BillBy = 2 and Project Clients not equal Campaign Clients
|| 03/13/14  KMC 10.5.7.8 (209594) Remove the ISNULL check on the LayoutKey so it can be removed instead of just default back to the old LayoutKey
*/

	DECLARE	@OldGetActualsBy smallint,
			@OldLayoutKey int,
			@OldMultipleSegments tinyint,
			@OldBillBy smallint,
			@OldOneLinePer smallint,
	        @RetVal	INTEGER,
	        @NextTranNo VARCHAR(100),
	        @OldActive tinyint,
	        @Date smalldatetime,
			@MultiCurrency int,
			@OldCurrencyID varchar(10)

     SELECT @Date = GETUTCDATE()	
     
	 -- Get the next number
	 IF @CampaignID IS NULL OR @CampaignID = ''
	 BEGIN
		EXEC sptCampaignGetNextCampaignNum
			@CompanyKey,
			@ClientKey,
			@RetVal OUTPUT,
			@NextTranNo OUTPUT

		IF @RetVal <> 1
			RETURN -1

		IF @NextTranNo IS NULL
			RETURN -1
	END
	ELSE
	BEGIN
		-- Check for a duplicate campaign id/number
		if isnull(@CampaignKey,0) > 0 
		begin
			IF EXISTS(
				SELECT 1 FROM tCampaign (NOLOCK) 
				WHERE
					CampaignID = @CampaignID AND
					CompanyKey = @CompanyKey AND
					CampaignKey <> @CampaignKey
					)
				RETURN -2
		end
		ELSE
		begin
			IF EXISTS(
				SELECT 1 FROM tCampaign (NOLOCK) 
				WHERE
					CampaignID = @CampaignID AND
					CompanyKey = @CompanyKey
					)
				RETURN -2
		end

		SELECT @NextTranNo = @CampaignID
	END

	SELECT @NextTranNo = LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(@NextTranNo, '&', ''), ',', ''), '"', ''), '''', '')))
 
	IF @CampaignKey > 0
	BEGIN
		
		-- Validation of GLCompanyKey
		IF EXISTS (SELECT 1 FROM tProject (NOLOCK) WHERE CampaignKey = @CampaignKey AND NOT ISNULL(GLCompanyKey, 0) IN (
						SELECT ISNULL(@GLCompanyKey, 0) 
						UNION
						(SELECT TargetGLCompanyKey FROM tGLCompanyMap (NOLOCK) WHERE SourceGLCompanyKey =  @GLCompanyKey)
				  )
				)
				RETURN -3

	SELECT	@OldGetActualsBy = GetActualsBy,
				@OldLayoutKey = LayoutKey,
				@OldMultipleSegments = MultipleSegments,
				@OldBillBy = BillBy,
				@OldOneLinePer = OneLinePer,
				@OldCurrencyID = CurrencyID
		FROM	tCampaign (nolock)
		WHERE	CampaignKey = @CampaignKey

		-- Validation of CurrencyID
		select @MultiCurrency = isnull(MultiCurrency, 0) from tPreference (nolock) where CompanyKey = @CompanyKey
		if @MultiCurrency = 1
		begin
			IF EXISTS (SELECT 1 FROM tProject (NOLOCK) 
						WHERE CampaignKey = @CampaignKey 
						AND   isnull(CurrencyID, '') <> isnull(@CurrencyID, '')
					)
					RETURN -4 
					
			IF isnull(@OldCurrencyID, '') <> isnull(@CurrencyID, '') AND EXISTS (SELECT 1 FROM tEstimate (NOLOCK)
				WHERE CompanyKey = @CompanyKey
				AND   CampaignKey = @CampaignKey
				)
				RETURN -5 
		end
	
		IF @BillBy = 2
		BEGIN
			--If BillBy was set to Campaign but projects are linked to it that have a different client than this campaign, then return error
			IF EXISTS
					(SELECT	NULL
					FROM	tProject (nolock)
					WHERE	CampaignKey = @CampaignKey
					AND		ClientKey <> @ClientKey)
				RETURN -6
		END

		IF @MultipleSegments = 0 AND @OldMultipleSegments = 1
		BEGIN
			UPDATE	tProject
			SET		CampaignSegmentKey = NULL
			WHERE	CampaignKey = @CampaignKey

			DELETE	tCampaignSegment
			WHERE	CampaignKey = @CampaignKey
		END
		
		SELECT @OldActive = ISNULL(Active, 0)	
		FROM   tCampaign (nolock)
		WHERE  CampaignKey = @CampaignKey
			
		IF @OldActive <> @Active
		BEGIN
			IF @Active = 1
				EXEC sptActionLogInsert 'Campaign',@CampaignKey, @CompanyKey, 0, 'Active', @Date, NULL, 'Campaign marked active', @CampaignID, NULL, @UserKey  
			ELSE
				EXEC sptActionLogInsert 'Campaign',@CampaignKey, @CompanyKey, 0, 'Inactive', @Date, NULL, 'Campaign marked inactive', @CampaignID, NULL, @UserKey  
		END
	
		UPDATE
			tCampaign
		SET
			CompanyKey = @CompanyKey,
			CampaignID = @NextTranNo, 
			CampaignName = @CampaignName,
			ClientKey = @ClientKey,
			Description = @Description,
			Objective = @Objective,
			StartDate = @StartDate,
			EndDate = @EndDate,
			AEKey = @AEKey,
			Active = @Active,
			CustomFieldKey = @CustomFieldKey,
			GetActualsBy = @GetActualsBy,
			LayoutKey = @LayoutKey,
			MultipleSegments = ISNULL(@MultipleSegments, @OldMultipleSegments),
			BillBy = ISNULL(@BillBy, @OldBillBy),
			OneLinePer = ISNULL(@OneLinePer, @OldOneLinePer),
			ContactKey = @ContactKey,
			GLCompanyKey = @GLCompanyKey,
			ClientDivisionKey = @ClientDivisionKey,
			ClientProductKey = @ClientProductKey,
			NextProjectNum = @NextProjectNum,
			CurrencyID = @CurrencyID 
		WHERE
			CampaignKey = @CampaignKey 

		--If GetActualsBy has changed, clear the budget items
		IF @GetActualsBy <> @OldGetActualsBy
			DELETE	tCampaignBudgetItem
			WHERE	CampaignKey = @CampaignKey

		--If not using Project for Actuals, clear out any links from tProject
		IF @GetActualsBy < 3
			UPDATE	tProject
			SET		CampaignBudgetKey = NULL
			WHERE	CampaignKey = @CampaignKey	
		
		RETURN @CampaignKey
	END
	ELSE
	BEGIN
		INSERT tCampaign
			(
			CompanyKey,
			CampaignID,
			CampaignName,
			ClientKey,
			Description,
			Objective,
			StartDate,
			EndDate,
			AEKey,
			Active,
			CustomFieldKey,
			GetActualsBy,
			LayoutKey,
			MultipleSegments,
			BillBy,
			OneLinePer,
			ContactKey,
			GLCompanyKey,
			ClientDivisionKey,
			ClientProductKey,
			NextProjectNum,
			CurrencyID
			)

		VALUES
			(
			@CompanyKey,
			@NextTranNo,
			@CampaignName,
			@ClientKey,
			@Description,
			@Objective,
			@StartDate,
			@EndDate,
			@AEKey,
			@Active,
			@CustomFieldKey,
			@GetActualsBy,
			@LayoutKey,
			@MultipleSegments,
			@BillBy,
			@OneLinePer,
			@ContactKey,
			@GLCompanyKey,
			@ClientDivisionKey,
			@ClientProductKey,
			@NextProjectNum,
			@CurrencyID
			)
	
		RETURN @@IDENTITY	
	END
GO
