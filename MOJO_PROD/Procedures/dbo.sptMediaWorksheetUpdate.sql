USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaWorksheetUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaWorksheetUpdate]
	@MediaWorksheetKey int,
	@CompanyKey int,
	@WorksheetID varchar(50) OUTPUT,
	@WorksheetName varchar(1000),
	@ClientKey int,
	@ProjectKey int,
	@UserKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@BillingBase smallint,
	@BillingAdjPercent decimal(24,4),
	@BillingAdjBase smallint,
	@CommissionOnly tinyint,
	@Comments varchar(max),
	@LockBuyChanges tinyint,
	@LockOrdering tinyint,
	@LockBilling tinyint,
	@LockVoucher tinyint,
	@Active tinyint,
	@TaskKey int,
	@POKind smallint,
	@GLCompanyKey int,
	@ClientProductKey int,
	@PrimaryBuyerKey int,
	@Frequency varchar(50),
	@Revision int,
	@DefaultLen int,
	@MediaAuth varchar(200),
	@WorksheetPONumber varchar(200),
	@AuthorizedBy int,
	@AuthorizedDate smalldatetime,
	@BudgetVar int,
	@FilterOptions varchar(max),
	@OneBuyPerOrder tinyint,
	@DoNotAppendNewBuys tinyint
AS

/*
|| When      Who Rel      What
|| 6/14/13   CRG 10.5.6.9 Created
|| 8/19/13   CRG 10.5.7.1 Now validating the Project Client
|| 10/16/13  CRG 10.5.7.3 Added GLCompanyKey
|| 12/11/13  CRG 10.5.7.5 Added ClientProductKey and PrimaryBuyerKey
|| 2/3/14    CRG 10.5.7.7 Added Frequency and Revision
|| 2/13/14   CRG 10.5.7.7 Added BroadcastType and DefaultLen
|| 2/26/14   CRG 10.5.7.7 Modified the call to spGetNextTranNo to use different TranTypes for each POKind
|| 3/5/14    PLC 10.5.7.7 Removed BroadcastType
|| 3/11/14   CRG 10.5.7.8 Added @MediaAuth, @WorksheetPONumber, @AuthorizedBy, @AuthorizedDate, @BudgetVar
|| 4/18/14   GHL 10.5.7.9 Added setting of project on PO and PO details
|| 05/05/14  GHL 10.5.7.9 Added FilterOptions param so that each worksheet can have its own options
||                        instead of using the session
|| 05/13/14  MFT 10.5.7.9 Added OneBuyPerOrder & DoNotAppendNewBuys
|| 06/16/14  GHL 10.5.8.1 If media orders exist, do not change OneBuyPerOrder 
*/

	IF ISNULL(@ProjectKey, 0) > 0 AND ISNULL(@ClientKey, 0) > 0
	BEGIN
		DECLARE @ProjectClientKey int
		SELECT	@ProjectClientKey = ClientKey
		FROM	tProject (nolock)
		WHERE	ProjectKey = @ProjectKey
		
		IF @ProjectClientKey <> @ClientKey
			RETURN -2
	END
	
	IF ISNULL(@ProjectKey, 0) > 0 AND ISNULL(@GLCompanyKey, 0) > 0
	BEGIN
		DECLARE	@ProjectGLCompanyKey int
		SELECT	@ProjectGLCompanyKey = GLCompanyKey
		FROM	tProject (nolock)
		WHERE	ProjectKey = @ProjectKey
		
		IF @ProjectGLCompanyKey <> @GLCompanyKey
			RETURN -3
	END

	declare @OldOneBuyPerOrder int
	declare @MediaOrderCount int

	IF @MediaWorksheetKey > 0
	BEGIN
		
		select @MediaOrderCount = count(*)
		from   tMediaOrder (nolock)
		where  MediaWorksheetKey = @MediaWorksheetKey  

		select @OldOneBuyPerOrder = OneBuyPerOrder
		from   tMediaWorksheet (nolock)
		where  MediaWorksheetKey = @MediaWorksheetKey  

		-- if we have created some media orders, do not change the grouping method
		if @MediaOrderCount > 0 
			select @OneBuyPerOrder = isnull(@OldOneBuyPerOrder, 0)

		UPDATE	tMediaWorksheet
		SET		WorksheetID = @WorksheetID,
				WorksheetName = @WorksheetName,
				ClientKey = @ClientKey,
				ProjectKey = @ProjectKey,
				LastUpdatedBy = @UserKey,
				LastUpdateDate = GETDATE(),
				StartDate = @StartDate,
				EndDate = @EndDate,
				BillingBase = @BillingBase,
				BillingAdjPercent = @BillingAdjPercent,
				BillingAdjBase = @BillingAdjBase,
				CommissionOnly = @CommissionOnly,
				Comments = @Comments,
				LockBuyChanges = @LockBuyChanges,
				LockOrdering = @LockOrdering,
				LockBilling = @LockBilling,
				LockVoucher = @LockVoucher,
				Active = @Active,
				TaskKey = @TaskKey,
				POKind = @POKind,
				GLCompanyKey = @GLCompanyKey,
				ClientProductKey = @ClientProductKey,
				PrimaryBuyerKey = @PrimaryBuyerKey,
				Frequency = @Frequency,
				Revision = @Revision,
				DefaultLen = @DefaultLen,
				MediaAuth = @MediaAuth,
				WorksheetPONumber = @WorksheetPONumber,
				AuthorizedBy = @AuthorizedBy,
				AuthorizedDate = @AuthorizedDate,
				BudgetVar = @BudgetVar,
				FilterOptions = @FilterOptions,
				OneBuyPerOrder = @OneBuyPerOrder,
				DoNotAppendNewBuys = @DoNotAppendNewBuys
		WHERE	MediaWorksheetKey = @MediaWorksheetKey
	
		-- Set the project of the purchase order and details
		-- If we use a worksheet, we need a project to bill and find the client
		UPDATE tPurchaseOrder
		SET    ProjectKey = @ProjectKey
		      ,TaskKey = @TaskKey
		WHERE  MediaWorksheetKey = @MediaWorksheetKey

		UPDATE tPurchaseOrderDetail
		SET    tPurchaseOrderDetail.ProjectKey = @ProjectKey
		      ,tPurchaseOrderDetail.TaskKey = @TaskKey
		FROM   tPurchaseOrder po (nolock)
		WHERE  po.MediaWorksheetKey = @MediaWorksheetKey
		AND    po.PurchaseOrderKey = tPurchaseOrderDetail.PurchaseOrderKey

	END
	ELSE
	BEGIN
		DECLARE @RetVal	int,
				@TranType varchar(50)
				
		SELECT	@TranType =
					CASE @POKind
						WHEN 1 THEN 'MediaWkshtPrint'
						WHEN 2 THEN 'MediaWkshtBC'
						WHEN 4 THEN 'MediaWkshtInt'
						WHEN 5 THEN 'MediaWkshtOOH'
					END

		EXEC spGetNextTranNo
			@CompanyKey,
			@TranType,
			@RetVal OUTPUT,
			@WorksheetID OUTPUT
		
			IF @RetVal <> 1
				RETURN -1

		SELECT @WorksheetID = LTRIM(RTRIM(@WorksheetID))

		INSERT	tMediaWorksheet
				(CompanyKey,
				WorksheetID,
				WorksheetName,
				ClientKey,
				ProjectKey,
				CreatedByKey,
				DateCreated,
				StartDate,
				EndDate,
				BillingBase,
				BillingAdjPercent,
				BillingAdjBase,
				CommissionOnly,
				Comments,
				LockBuyChanges,
				LockOrdering,
				LockBilling,
				LockVoucher,
				Active,
				TaskKey,
				POKind,
				GLCompanyKey,
				ClientProductKey,
				PrimaryBuyerKey,
				Frequency,
				Revision,
				DefaultLen,
				MediaAuth,
				WorksheetPONumber,
				AuthorizedBy,
				AuthorizedDate,
				BudgetVar,
				FilterOptions,
				OneBuyPerOrder,
				DoNotAppendNewBuys)
		VALUES (@CompanyKey,
				@WorksheetID,
				@WorksheetName,
				@ClientKey,
				@ProjectKey,
				@UserKey,
				GETDATE(),
				@StartDate,
				@EndDate,
				@BillingBase,
				@BillingAdjPercent,
				@BillingAdjBase,
				@CommissionOnly,
				@Comments,
				@LockBuyChanges,
				@LockOrdering,
				@LockBilling,
				@LockVoucher,
				@Active,
				@TaskKey,
				@POKind,
				@GLCompanyKey,
				@ClientProductKey,
				@PrimaryBuyerKey,
				@Frequency,
				@Revision,
				@DefaultLen,
				@MediaAuth,
				@WorksheetPONumber,
				@AuthorizedBy,
				@AuthorizedDate,
				@BudgetVar,
				@FilterOptions,
				@OneBuyPerOrder,
				@DoNotAppendNewBuys)

		SELECT	@MediaWorksheetKey = @@IDENTITY
	END

	RETURN @MediaWorksheetKey
GO
