USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceChangeStatus]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceChangeStatus]

	(
		@InvoiceKey int,
		@Status smallint,
		@ApprovalComments varchar(500) = NULL,
		@CreateRollupTempTable int = 1
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 06/18/08 GHL 8.513 Added logic for Opening Transactions.
|| 04/21/09 GWG 10.023 Modify approval of child invoices so it sets inv number on approval
|| 02/17/10 GHL 10.518 (73756) Added logic for rollup of the Billed Amount Approved field
|| 05/24/12 GHL 10.556 Added update of ApprovedDate
|| 01/08/15 GHL 10.588 (241726) Added checking of posted status before unapproving
*/

Declare @CurStatus int, 
		@InvoiceDate smalldatetime, 
		@PostingDate smalldatetime, 
		@DueDate smalldatetime, 
		@InvoiceNumber varchar(100), 
		@NextTranNo varchar(100),
		@CompanyKey int,
		@RetVal int,
		@TermsKey int,
		@DueDays int,
		@PostToGL tinyint,
		@OpeningTransaction tinyint,
		@ApprovedDate smalldatetime,
		@Posted int
		
Select @CurStatus = InvoiceStatus 
	   ,@InvoiceDate = InvoiceDate 
	   ,@PostingDate = PostingDate 
	   ,@DueDate = DueDate 
	   ,@InvoiceNumber = InvoiceNumber
	   ,@CompanyKey = CompanyKey	
	   ,@TermsKey = TermsKey
	   ,@OpeningTransaction = ISNULL(OpeningTransaction, 0)
	   ,@Posted = Posted
from tInvoice (NOLOCK) 
Where InvoiceKey = @InvoiceKey

if @CurStatus = 4 and @Status <> 4
BEGIN
	if exists(Select 1 from tInvoiceAdvanceBill (nolock) Where AdvBillInvoiceKey = @InvoiceKey)
		return -1
	if exists(Select 1 from tInvoiceCredit (nolock) Where CreditInvoiceKey = @InvoiceKey)
		return -2
	if exists(Select 1 from tInvoice (nolock) Where ParentInvoiceKey = @InvoiceKey and InvoiceStatus = 4)
		return -3
	if exists(Select 1 from tCheckAppl (nolock) Where InvoiceKey = @InvoiceKey and ISNULL(Prepay, 0) = 0)
		return -4
	if @Posted = 1
		return -5
END	

if @Status = 4
	select @ApprovedDate = Cast(Cast(DatePart(mm,GETDATE()) as varchar) + '/' + Cast(DatePart(dd,GETDATE()) as varchar) + '/' + Cast(DatePart(yyyy,GETDATE()) as varchar) as smalldatetime)
-- else we leave ApprovedDate at null

-- Make sure that we have an InvoiceNumber before approving	
-- tPreference.SetInvoiceNumberOnApproval allows for delaying assignment of InvoiceNumber
IF @Status = 4 And (@InvoiceNumber IS NULL OR @InvoiceNumber = '')
BEGIN
	EXEC spGetNextTranNo
			@CompanyKey,
			'AR',		-- TranType
			@RetVal		  OUTPUT,
			@NextTranNo   OUTPUT
		
		IF @RetVal <> 1
			RETURN -5
	
	IF @InvoiceDate IS NULL
		SELECT 	@InvoiceDate = CONVERT(VARCHAR(10), GETDATE(), 101)
	
	SELECT @PostToGL = ISNULL(PostToGL, 0)
	FROM   tPreference (NOLOCK)
	WHERE  CompanyKey = @CompanyKey
	
	IF @OpeningTransaction = 1
		SELECT @PostToGL = 0
		
	IF @PostingDate IS NULL AND @PostToGL = 1  
		SELECT 	@PostingDate = @InvoiceDate
			
	IF @DueDate IS NULL
	BEGIN
		SELECT @DueDays = DueDays
		FROM   tPaymentTerms (NOLOCK)
		WHERE  PaymentTermsKey = @TermsKey
		
		SELECT @DueDate = DATEADD(day, @DueDays, @InvoiceDate)	
	END

	UPDATE tInvoice 
	SET InvoiceNumber	= @NextTranNo 
		,InvoiceDate	= @InvoiceDate
		,PostingDate	= @PostingDate
		,DueDate		= @DueDate
	WHERE InvoiceKey	= @InvoiceKey
			
END

if @ApprovalComments is null
	Update tInvoice
	Set
		InvoiceStatus = @Status,
		ApprovedDate = @ApprovedDate
	Where
		InvoiceKey = @InvoiceKey
else
	Update tInvoice
	Set
		InvoiceStatus = @Status,
		ApprovalComments = @ApprovalComments,
		ApprovedDate = @ApprovedDate
	Where
		InvoiceKey = @InvoiceKey
		
if @CreateRollupTempTable = 1
	create table #tProjectItemRollup (ProjectKey int null, Entity varchar(50) null, EntityKey int null, BilledAmountApproved money null) 
			
if @Status = 4 Or @CurStatus = 4
begin
		truncate table #tProjectItemRollup
		
		INSERT #tProjectItemRollup(ProjectKey,Entity,EntityKey)
		SELECT ProjectKey, isnull(Entity, 'tService'), ISNULL(EntityKey, 0)
		FROM   tInvoiceSummary (NOLOCK)
		WHERE  ProjectKey IN (SELECT ProjectKey FROM tInvoiceSummary (NOLOCK) WHERE InvoiceKey = @InvoiceKey)
		GROUP BY ProjectKey, isnull(Entity, 'tService'), isnull(EntityKey, 0)

		UPDATE #tProjectItemRollup
        SET	#tProjectItemRollup.BilledAmountApproved = 
			ISNULL((SELECT SUM(isum.Amount + isum.SalesTaxAmount)
			FROM tInvoiceSummary isum (NOLOCK) 
				INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey 
			WHERE i.AdvanceBill = 0 
			and   i.InvoiceStatus = 4
			and isum.ProjectKey = #tProjectItemRollup.ProjectKey
			AND   ISNULL(isum.Entity, 'tService') = #tProjectItemRollup.Entity COLLATE DATABASE_DEFAULT
			AND   ISNULL(isum.EntityKey, 0) = #tProjectItemRollup.EntityKey
			),0)


		UPDATE tProjectItemRollup
		SET    tProjectItemRollup.BilledAmountApproved = pir.BilledAmountApproved
		FROM   #tProjectItemRollup pir
		WHERE  tProjectItemRollup.ProjectKey = pir.ProjectKey
		AND    tProjectItemRollup.Entity = pir.Entity COLLATE DATABASE_DEFAULT
		AND    tProjectItemRollup.EntityKey = pir.EntityKey
		
		UPDATE tProjectRollup
		SET    tProjectRollup.BilledAmountApproved = pir.BilledAmountApproved
		FROM   (
				SELECT SUM(BilledAmountApproved) AS BilledAmountApproved , ProjectKey
				FROM  #tProjectItemRollup
				GROUP BY ProjectKey
				) AS pir
		WHERE  tProjectRollup.ProjectKey = pir.ProjectKey		
end
		
		
-- modified to handle assigning numbers to child invoices on approval.
if @Status = 4
BEGIN
	declare @curKey int
	Select @curKey = -1
	While 1=1
	BEGIN
		Select @curKey = min(InvoiceKey) from tInvoice (nolock) Where ParentInvoiceKey = @InvoiceKey and InvoiceKey > @curKey
			if @curKey is null break
			exec sptInvoiceChangeStatus @curKey, 4, @ApprovalComments, 0 -- 0: do not create a temp table
	END
END

		
		
 RETURN 1
GO
