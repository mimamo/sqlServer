USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportEstimate]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportEstimate]
	@CompanyKey int,
	@ProjectNumber varchar(50),
	@EstimateName varchar(100),
	@Revision int,
	@EstDescription varchar(1000),
	@SalesTaxID varchar(100),
	@SalesTax2ID varchar(100),
	@ChangeOrder tinyint,
	@LaborTaxable smallint,	--0 not taxable, 1 by task, 2 by project
	@Contingency tinyint,
	@ApprovedByUserID varchar(100),
	@DateApproved smalldatetime,
	@CreatedByUserID varchar(100),
	@DateCreated smalldatetime,
	@Approved tinyint,
	@UserKey int,
	@oIdentity INT OUTPUT,
	@ProjectKey int OUTPUT
AS --Encrypt

	SELECT	@ProjectKey = ProjectKey
	FROM	tProject (nolock)
	WHERE	ProjectNumber = @ProjectNumber
	AND		CompanyKey = @CompanyKey
	
	IF @ProjectKey IS NULL
		RETURN -1

	DECLARE @RetVal INT
			,@EstimateNumber VARCHAR(50)
		
	EXEC sptEstimateGetNextEstimateNum
		@CompanyKey,
		@ProjectKey,
		NULL, -- campaign
		NULL, -- lead
		@RetVal OUTPUT,
		@EstimateNumber OUTPUT
		
DECLARE @SalesTaxKey int
if @SalesTaxID is not null
	begin
		SELECT	@SalesTaxKey = SalesTaxKey
		FROM	tSalesTax (nolock)
		WHERE	SalesTaxID = @SalesTaxID
		AND		CompanyKey = @CompanyKey
		if @SalesTaxKey is null
			Return -2
	end 

DECLARE @SalesTax2Key int
if @SalesTax2ID is not null
	begin
		SELECT	@SalesTax2Key = SalesTaxKey
		FROM	tSalesTax (nolock)
		WHERE	SalesTaxID = @SalesTax2ID
		AND		CompanyKey = @CompanyKey
		if @SalesTax2Key is null
			Return -3
	end 
		
	-- Get from the IDS
	DECLARE @InternalApprover INT
		   ,@InternalStatus INT
		   ,@CreatedBy INT
	
	SELECT	@InternalApprover = UserKey
	FROM	tUser (nolock)
	WHERE	UserID = @ApprovedByUserID
	AND		CompanyKey = @CompanyKey
	
	IF @InternalApprover IS NULL
		SELECT	@InternalApprover = UserKey
		FROM	tUser (nolock)
		WHERE	SystemID = @ApprovedByUserID
		AND		CompanyKey = @CompanyKey
		
	IF @InternalApprover IS NULL
		SELECT	@InternalApprover = @UserKey

	SELECT	@CreatedBy = UserKey
	FROM	tUser (nolock)
	WHERE	UserID = @CreatedByUserID
	AND		CompanyKey = @CompanyKey
	
	IF @CreatedBy IS NULL
		SELECT	@CreatedBy = UserKey
		FROM	tUser (nolock)
		WHERE	SystemID = @CreatedByUserID
		AND		CompanyKey = @CompanyKey
		
	if @CreatedBy is null
		Select @CreatedBy = @UserKey
		
	IF @Approved = 1
		SELECT	@InternalStatus = 4
	ELSE
		SELECT	@InternalStatus = 2

	If @LaborTaxable Is Null
		Select @LaborTaxable = 0

	If @Contingency Is Null
		Select @Contingency = 0

	IF @LaborTaxable < 0 OR @LaborTaxable > 2
		SELECT @LaborTaxable = 0	
	    
	INSERT tEstimate
		(
		CompanyKey,
		ProjectKey,
		EstimateName,
		EstimateNumber,
		Revision,
		EstType,
		EstDescription,
		EstimateTemplateKey,
		SalesTaxKey,
		SalesTax2Key,
		LaborTaxable,
		Contingency,
		ChangeOrder,
		InternalApprover,
		InternalStatus,
		InternalApproval,
		ExternalApprover,
		ExternalStatus,
		MultipleQty,
		ApprovedQty,
		Expense1,
		Expense2,
		Expense3,
		Expense4,
		Expense5,
		Expense6,
		EnteredBy,
		DateAdded		
		)

	VALUES
		(
		@CompanyKey,
		@ProjectKey,
		@EstimateName,
		@EstimateNumber,
		@Revision,
		1,
		@EstDescription,
		NULL,
		@SalesTaxKey,
		@SalesTax2Key,
		@LaborTaxable,
		@Contingency,
		@ChangeOrder,
		@InternalApprover,
		@InternalStatus,
		@DateApproved,		-- InternalApproval,
		0,					-- ExternalApprover,
		1,					-- ExternalStatus,
		0,					-- MultipleQty,
		1,					-- ApprovedQty,
		'Option1',			-- Expense1,
		'',					-- Expense2,
		'',					-- Expense3,
		'',					-- Expense4,
		'',					-- Expense5,
		'',					-- Expense6,
		@CreatedBy,
		GETDATE()			-- DateAdded
	
		)
	
	SELECT @oIdentity = @@IDENTITY


	RETURN 1
GO
