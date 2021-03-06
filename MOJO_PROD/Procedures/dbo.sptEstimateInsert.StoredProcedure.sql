USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateInsert]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateInsert]
	@ProjectKey int,
	@CampaignKey int,
	@LeadKey int,
	@EstimateName varchar(100),
	@EstimateNumber varchar(50),
	@EstimateDate smalldatetime,
	@DeliveryDate smalldatetime,
	@Revision int,
	@EstType smallint,
	@EstDescription text,
	@LayoutKey int,
	@EstimateTemplateKey int,
	@PrimaryContactKey int,
	@AddressKey int,
	@SalesTaxKey int,
	@SalesTax2Key int,
	@LaborTaxable tinyint,
	@Contingency decimal(24,4),
	@ChangeOrder tinyint,
	@InternalApprover int,
	@InternalDueDate smalldatetime,
	@ExternalApprover int,
	@ExternalDueDate smalldatetime,
	@MultipleQty tinyint,
	@ApprovedQty smallint,
	@Expense1 varchar(100),
	@Expense2 varchar(100),
	@Expense3 varchar(100),
	@Expense4 varchar(100),
	@Expense5 varchar(100),
	@Expense6 varchar(100),
	@EnteredBy int,
	@UserDefined1 varchar(250),
	@UserDefined2 varchar(250),
	@UserDefined3 varchar(250),
	@UserDefined4 varchar(250),
	@UserDefined5 varchar(250),
	@UserDefined6 varchar(250),
	@UserDefined7 varchar(250),
	@UserDefined8 varchar(250),
	@UserDefined9 varchar(250),
	@UserDefined10 varchar(250),
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel     What
|| 10/28/08 GWG 10.011  Removed the adding of the person to the project just because they are approving the estimate
|| 02/04/10 GHL 10.518  Added CompanyKey to facilitate queries because ProjectKey is not required 
|| 01/19/15 GHL 10.588  Added campaign, opportunity and layout key to use with the new APP screens
*/


DECLARE @RetVal INT
		,@CompanyKey INT
        ,@ProjectTypeKey INT
        
SELECT  @CompanyKey = CompanyKey
		,@ProjectTypeKey = ProjectTypeKey
FROM    tProject (NOLOCK)
WHERE   ProjectKey = @ProjectKey

-- Get the next number -- Get the next number
IF @EstimateNumber IS NULL OR @EstimateNumber = ''
BEGIN
	EXEC sptEstimateGetNextEstimateNum
		@CompanyKey,
		@ProjectKey,
		@CampaignKey,
		@LeadKey,
		@RetVal OUTPUT,
		@EstimateNumber OUTPUT

	IF @RetVal <> 1
		RETURN -1	
END
ELSE
BEGIN
	-- Check for a duplicate project number
	SELECT @EstimateNumber = REPLACE(REPLACE(REPLACE(REPLACE(@EstimateNumber, '&', ''), ',', ''), '"', ''), '''', '')

	IF EXISTS(
			SELECT 1 FROM tEstimate e (NOLOCK)
			WHERE  e.EstimateNumber = @EstimateNumber 
			AND    e.CompanyKey = @CompanyKey
			)
		RETURN -2
END
 
 	INSERT tEstimate
		(
		CompanyKey,
		ProjectKey,
		CampaignKey,
		LeadKey,
		EstimateName,
		EstimateNumber,
		EstimateDate,
		DeliveryDate,
		Revision,
		EstType,
		EstDescription,
		LayoutKey,
		EstimateTemplateKey,
		PrimaryContactKey,
		AddressKey,
		SalesTaxKey,
		SalesTax2Key,
		LaborTaxable,
		Contingency,
		ChangeOrder,
		InternalApprover,
		InternalDueDate,
		InternalStatus,
		ExternalApprover,
		ExternalDueDate,
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
		DateAdded,
		UserDefined1,
		UserDefined2,
		UserDefined3,
		UserDefined4,
		UserDefined5,
		UserDefined6,
		UserDefined7,
		UserDefined8,
		UserDefined9,
		UserDefined10
		)

	VALUES
		(
		@CompanyKey,
		@ProjectKey,
		@CampaignKey,
		@LeadKey,
		@EstimateName,
		@EstimateNumber,
		@EstimateDate,
		@DeliveryDate,
		@Revision,
		@EstType,
		@EstDescription,
		@LayoutKey,
		@EstimateTemplateKey,
		@PrimaryContactKey,
		@AddressKey,
		@SalesTaxKey,
		@SalesTax2Key,
		@LaborTaxable,
		@Contingency,		
		@ChangeOrder,
		@InternalApprover,
		@InternalDueDate,
		1,
		@ExternalApprover,
		@ExternalDueDate,
		1,
		@MultipleQty,
		@ApprovedQty,
		@Expense1,
		@Expense2,
		@Expense3,
		@Expense4,
		@Expense5,
		@Expense6,
		@EnteredBy,
		GETUTCDATE(),
		@UserDefined1,
		@UserDefined2,
		@UserDefined3,
		@UserDefined4,
		@UserDefined5,
		@UserDefined6,
		@UserDefined7,
		@UserDefined8,
		@UserDefined9,
		@UserDefined10
		)
	
	SELECT @oIdentity = @@IDENTITY

if @EstType in (2, 4, 5)
BEGIN
	EXEC sptEstimateServiceInsertList @oIdentity
END


-- Make sure that the internal approver is assigned to the project
-- This SP will do the job
-- exec sptAssignmentInsertFromTask @ProjectKey, @InternalApprover


	RETURN 1
GO
