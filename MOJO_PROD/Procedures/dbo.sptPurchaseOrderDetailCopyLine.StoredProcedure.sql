USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailCopyLine]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDetailCopyLine]
	@PurchaseOrderDetailKey int,
	@oIdentity int OUTPUT
AS --Encrypt

  /*
  || When     Who Rel     What
  || 02/26/07 GHL 8.4     Added project rollup section
  || 07/30/07 BSH 8.4.3.3 (10744)Fix PurchaseOrderTotal on POs, not calculated on copy line. 
  || 06/02/09 RLB 10.0.2.6(53960) Will pull the Office and Department onto the copied line.        
  || 09/14/09 GHL 10.5    Added logic for Transfers
  || 07/06/11 GHL 10.546  (11482) Added tax amounts on the line
  */
	DECLARE	@PurchaseOrderKey int,
			@LineNumber int,
			@POKind smallint,
			@CopyLineNumber int,
			@CustomFieldKey int,
			@FieldSetKey int,
			@ObjectFieldSetKey int,
			@ProjectKey int
			
	SELECT	@PurchaseOrderKey = PurchaseOrderKey,
			@CustomFieldKey = CustomFieldKey,
			@ProjectKey = ProjectKey
	FROM	tPurchaseOrderDetail (NOLOCK)
	WHERE	PurchaseOrderDetailKey = @PurchaseOrderDetailKey
	
	SELECT	@POKind = POKind
	FROM	tPurchaseOrder (NOLOCK)
	WHERE	PurchaseOrderKey = @PurchaseOrderKey

	SELECT	@LineNumber = MAX(LineNumber)
	FROM	tPurchaseOrderDetail (NOLOCK)
	WHERE	PurchaseOrderKey = @PurchaseOrderKey
	
	SELECT	@LineNumber = ISNULL(@LineNumber, 0) + 1
	
	--Get new ObjectFieldSetKey
    IF ISNULL(@CustomFieldKey,0) > 0
    BEGIN
		SELECT	@FieldSetKey = FieldSetKey
		FROM	tObjectFieldSet (NOLOCK)
		WHERE	ObjectFieldSetKey = @CustomFieldKey
		
		EXEC spCF_tObjectFieldSetInsert @FieldSetKey, @ObjectFieldSetKey OUTPUT
		
		IF ISNULL(@ObjectFieldSetKey,0) > 0
			INSERT	tFieldValue
					(FieldValueKey, FieldDefKey, ObjectFieldSetKey, FieldValue)
			SELECT	newid(), FieldDefKey, @ObjectFieldSetKey, FieldValue
			FROM	tFieldValue (NOLOCK)
			WHERE	ObjectFieldSetKey = @CustomFieldKey
    END
	
	IF (@POKind = 0) OR (@POKind = 1) --PO or IO
	BEGIN
		INSERT	tPurchaseOrderDetail
				(PurchaseOrderKey, 
				LineNumber, 
				LinkID, 
				ProjectKey, 
				TaskKey, 
				ClassKey, 
				ShortDescription, 
				LongDescription, 
				ItemKey, 
				Quantity, 
				UnitCost, 
				UnitDescription, 
				TotalCost,
				UnitRate,
				Billable, 
				Markup, 
				BillableCost, 
				AppliedCost, 
				MakeGoodKey, 
				CustomFieldKey, 
				QuoteReplyDetailKey, 
				InvoiceLineKey, 
				AmountBilled, 
				AccruedCost, 
				DateBilled, 
				Closed, 
				DetailOrderDate, 
				DetailOrderEndDate, 
				UserDate1, 
				UserDate2, 
				UserDate3, 
				UserDate4, 
				UserDate5, 
				UserDate6, 
				OrderDays, 
				OrderTime, 
				OrderLength, 
				OnHold, 
				Taxable, 
				Taxable2, 
				BilledComment, 
				TransferComment, 
				AdjustmentNumber, 
				MediaRevisionReasonKey,
				OfficeKey,
				DepartmentKey,
				SalesTaxAmount,
				SalesTax1Amount,
				SalesTax2Amount
				)
		SELECT	PurchaseOrderKey, 
				@LineNumber, 
				NULL, --LinkID
				ProjectKey, 
				TaskKey, 
				ClassKey, 
				ShortDescription, 
				LongDescription, 
				ItemKey, 
				Quantity, 
				UnitCost, 
				UnitDescription, 
				TotalCost, 
				UnitRate,
				Billable, 
				Markup, 
				BillableCost, 
				NULL, --AppliedCost
				NULL, --MakeGoodKey
				@ObjectFieldSetKey, --CustomFieldKey
				NULL, --QuoteReplyDetailKey
				NULL, --InvoiceLineKey
				NULL, --AmountBilled
				NULL, --AccruedCost
				NULL, --DateBilled
				0, --Closed
				DetailOrderDate,
				DetailOrderEndDate,
				UserDate1, 
				UserDate2, 
				UserDate3, 
				UserDate4, 
				UserDate5, 
				UserDate6, 
				OrderDays, 
				OrderTime, 
				OrderLength, 
				0, --OnHold
				Taxable, 
				Taxable2, 
				NULL, --BilledComment
				NULL, --TransferComment
				0, --AdjustmentNumber
				NULL, --MediaRevisionReasonKey
				OfficeKey,
				DepartmentKey,
				SalesTaxAmount,
				SalesTax1Amount,
				SalesTax2Amount
		FROM	tPurchaseOrderDetail (NOLOCK)
		WHERE	PurchaseOrderDetailKey = @PurchaseOrderDetailKey
	END
	
	IF @POKind = 2 --BC
	BEGIN
		SELECT	@CopyLineNumber = LineNumber
		FROM	tPurchaseOrderDetail (NOLOCK)
		WHERE	PurchaseOrderDetailKey = @PurchaseOrderDetailKey
			
		INSERT	tPurchaseOrderDetail
				(PurchaseOrderKey, 
				LineNumber, 
				LinkID, 
				ProjectKey, 
				TaskKey, 
				ClassKey, 
				ShortDescription, 
				LongDescription, 
				ItemKey, 
				Quantity, 
				UnitCost, 
				UnitDescription, 
				TotalCost, 
				UnitRate,
				Billable, 
				Markup, 
				BillableCost, 
				AppliedCost, 
				MakeGoodKey, 
				CustomFieldKey, 
				QuoteReplyDetailKey, 
				InvoiceLineKey, 
				AmountBilled, 
				AccruedCost, 
				DateBilled, 
				Closed, 
				DetailOrderDate, 
				DetailOrderEndDate, 
				UserDate1, 
				UserDate2, 
				UserDate3, 
				UserDate4, 
				UserDate5, 
				UserDate6, 
				OrderDays, 
				OrderTime, 
				OrderLength, 
				OnHold, 
				Taxable, 
				Taxable2, 
				BilledComment, 
				TransferComment, 
				AdjustmentNumber, 
				MediaRevisionReasonKey,
				OfficeKey,
				DepartmentKey,
				SalesTaxAmount,
				SalesTax1Amount,
				SalesTax2Amount
				)
		SELECT	PurchaseOrderKey, 
				@LineNumber, 
				NULL, --LinkID
				ProjectKey, 
				TaskKey, 
				ClassKey, 
				ShortDescription, 
				LongDescription, 
				ItemKey, 
				Quantity, 
				UnitCost, 
				UnitDescription, 
				TotalCost, 
				UnitRate,
				Billable, 
				Markup, 
				BillableCost, 
				NULL, --AppliedCost
				NULL, --MakeGoodKey
				@ObjectFieldSetKey, --CustomFieldKey 
				NULL, --QuoteReplyDetailKey
				NULL, --InvoiceLineKey
				NULL, --AmountBilled
				NULL, --AccruedCost
				NULL, --DateBilled
				0, --Closed
				DetailOrderDate,
				DetailOrderEndDate,
				UserDate1, 
				UserDate2, 
				UserDate3, 
				UserDate4, 
				UserDate5, 
				UserDate6, 
				OrderDays, 
				OrderTime, 
				OrderLength, 
				0, --OnHold
				Taxable, 
				Taxable2, 
				NULL, --BilledComment
				NULL, --TransferComment
				0, --AdjustmentNumber
				NULL, --MediaRevisionReasonKey
				OfficeKey,
				DepartmentKey,
				SalesTaxAmount,
				SalesTax1Amount,
				SalesTax2Amount
		FROM	tPurchaseOrderDetail  (NOLOCK)
		WHERE	PurchaseOrderKey = @PurchaseOrderKey
		AND		LineNumber = @CopyLineNumber
		AND		AdjustmentNumber = 0
		AND     TransferToKey is null
		
	END
	
	SELECT	@oIdentity = @@IDENTITY

	-- Media have no taxes	
	if @POKind = 0
		insert tPurchaseOrderDetailTax (PurchaseOrderDetailKey, SalesTaxKey, SalesTaxAmount)
		select @oIdentity, SalesTaxKey, SalesTaxAmount
		from   tPurchaseOrderDetailTax (nolock) where PurchaseOrderDetailKey = @PurchaseOrderDetailKey

	exec sptPurchaseOrderRollupAmounts @PurchaseOrderKey

	-- Project rollup, trantype = 5 or po
	EXEC sptProjectRollupUpdate @ProjectKey, 5, 1,1,1,1
	
	RETURN 1
GO
