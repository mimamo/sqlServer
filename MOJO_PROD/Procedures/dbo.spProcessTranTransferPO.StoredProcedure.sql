USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessTranTransferPO]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessTranTransferPO]
	(
	@PurchaseOrderDetailKey int
	,@ToProjectKey int
	,@ToTaskKey int
	,@TransferDate smalldatetime
	,@TransferFromComment varchar(500)
	,@TransferToComment varchar(500)
	)
AS
	SET NOCOUNT ON

  /*
  || When     Who Rel     What
  || 08/27/09 GHL 10.5  Creation for new transfers 
  ||                    We need to do the following:
  ||                    - Create one tran for the new project (and get the TransferToKey)
  ||                    - Create one tran to reverse the initial transaction (old project)
  ||                    - Modify the initial transaction  
  || 11/05/09 GHL 10.513 Added checking of TransferToKey before transferring  
  || 11/16/09 GHL 10.513 (68471) When creating the new transaction, use OfficeKey/ClassKey from new project    
  || 12/21/09 GHL 10.515 (70850) Limiting now transfer comment to current transfer rather than appending 
  ||                     to old comments because it was causing an overflow 
  || 03/12/10 GHL 10.519 (76520) Now the rule is: do not change Class if the to project has a null class  
  || 05/13/10 GHL 10.523 (80709) Rolled back logic for same projects
  || 09/25/13 GHL 10.572 Added multi currency fields
  || 10/16/13 GHL 10.573 Added new PO fields
  || 04/29/14 RLB 10.579 (214240) Increasing Short Description field
  || 10/14/14 GHL 10.585 (224560) Added update of RootTransferFromKey + doublecheck the TransferFromKey
 */
  
	DECLARE @TransferToKey INT
	DECLARE @ReversalDetailKey INT
	DECLARE @Error INT
				  
	-- Various vars
    Declare @PurchaseOrderKey int
    Declare @LineNumber int
    Declare @LinkID varchar(100)
    Declare @ProjectKey int
    Declare @TaskKey int
    Declare @ClassKey int
    Declare @ShortDescription varchar(max)
    Declare @LongDescription varchar(6000)
    Declare @ItemKey int
    Declare @Quantity decimal(24,4)
    Declare @UnitCost money
    Declare @UnitDescription varchar(30) 
    Declare @TotalCost money
    Declare @Billable tinyint
    Declare @Markup decimal(24,4)
    Declare @BillableCost money
    Declare @AppliedCost money
    Declare @MakeGoodKey int
    Declare @CustomFieldKey int
    Declare @QuoteReplyDetailKey int
    Declare @InvoiceLineKey int
    Declare @AmountBilled money
    Declare @AccruedCost money
    Declare @DateBilled smalldatetime
    Declare @Closed tinyint
    Declare @DetailOrderDate smalldatetime
    Declare @DetailOrderEndDate smalldatetime
    Declare @UserDate1 smalldatetime
    Declare @UserDate2 smalldatetime
    Declare @UserDate3 smalldatetime
    Declare @UserDate4 smalldatetime
    Declare @UserDate5 smalldatetime
    Declare @UserDate6 smalldatetime
    Declare @OrderDays varchar(50) 
    Declare @OrderTime varchar(50)
    Declare @OrderLength varchar(50)
    Declare @OnHold tinyint
    Declare @Taxable tinyint
    Declare @Taxable2 tinyint
    Declare @BilledComment varchar(2000)
    Declare @AdjustmentNumber int 
    Declare @MediaRevisionReasonKey int
    Declare @UnitRate money
    Declare @AutoAdjustment tinyint
    Declare @DateClosed smalldatetime
    Declare @OfficeKey int
    Declare @DepartmentKey int
    Declare @AccruedExpenseInAccountKey int
    Declare @OrigTransferComment varchar(2000)
	Declare @CompanyKey int
	Declare @ToOfficeKey int
	Declare @ToClassKey int
	Declare @PExchangeRate decimal(24,7)
	Declare @PCurrencyID varchar(10)
	Declare @PTotalCost money
	Declare @PAppliedCost money
	Declare @Quantity1 decimal(24,4)
	Declare @Quantity2 decimal(24,4)
	Declare @GrossAmount money
	DECLARE @OldDetailOrderDate smalldatetime
	DECLARE @OldShortDescription varchar(max)
	DECLARE @OldMediaPrintSpaceKey int
	DECLARE @OldMediaPrintPositionKey int
	DECLARE @OldCompanyMediaPrintContractKey int
	DECLARE @OldMediaPrintSpaceID varchar(500)
	DECLARE @CommissionablePremium tinyint
	DECLARE @RootTransferFromKey int

	--SELECT @TransferDate = CONVERT(SMALLDATETIME, (CONVERT(VARCHAR(10), GETDATE(), 101)), 101)
	
	Select 
	   @PurchaseOrderKey = PurchaseOrderKey
      ,@LineNumber = LineNumber
      ,@LinkID = LinkID
      ,@ProjectKey = ProjectKey
      ,@TaskKey = TaskKey
      ,@ClassKey = ClassKey
      ,@ShortDescription = ShortDescription
      ,@LongDescription = LongDescription
      ,@ItemKey =ItemKey
      ,@Quantity =Quantity
      ,@UnitCost = UnitCost
      ,@UnitDescription = UnitDescription
      ,@TotalCost = TotalCost
      ,@Billable = Billable
      ,@Markup = Markup
      ,@BillableCost = BillableCost
      ,@AppliedCost = AppliedCost
      ,@MakeGoodKey = MakeGoodKey
      ,@CustomFieldKey = CustomFieldKey
      ,@QuoteReplyDetailKey = QuoteReplyDetailKey
      ,@InvoiceLineKey = InvoiceLineKey
      ,@AmountBilled = AmountBilled
      ,@AccruedCost = AccruedCost
      ,@DateBilled = DateBilled
      ,@Closed = Closed
      ,@DetailOrderDate = DetailOrderDate
      ,@DetailOrderEndDate = DetailOrderEndDate
      ,@UserDate1 = UserDate1
      ,@UserDate2 = UserDate2
      ,@UserDate3 = UserDate3
      ,@UserDate4 = UserDate4
      ,@UserDate5 = UserDate5
      ,@UserDate6 = UserDate6
      ,@OrderDays = OrderDays
      ,@OrderTime = OrderTime
      ,@OrderLength = OrderLength
      ,@OnHold = OnHold
      ,@Taxable = Taxable
      ,@Taxable2 = Taxable2
      ,@BilledComment = BilledComment
      ,@AdjustmentNumber = AdjustmentNumber
      ,@MediaRevisionReasonKey = MediaRevisionReasonKey
      ,@UnitRate = UnitRate
      ,@AutoAdjustment = AutoAdjustment
      ,@DateClosed = DateClosed
      ,@OfficeKey = OfficeKey
      ,@DepartmentKey = DepartmentKey
      ,@AccruedExpenseInAccountKey = AccruedExpenseInAccountKey  
      ,@OrigTransferComment = ISNULL(TransferComment, '')
      ,@TransferToKey = TransferToKey
      ,@PExchangeRate = PExchangeRate
	  ,@PCurrencyID = PCurrencyID
	  ,@PTotalCost = PTotalCost
	  ,@PAppliedCost = PAppliedCost
	  ,@Quantity1 = Quantity1
	  ,@Quantity2 = Quantity2
	  ,@GrossAmount = GrossAmount
	  ,@OldDetailOrderDate = OldDetailOrderDate
	  ,@OldShortDescription = OldShortDescription
	  ,@OldMediaPrintSpaceKey =OldMediaPrintSpaceKey
	  ,@OldMediaPrintPositionKey = OldMediaPrintPositionKey
	  ,@OldCompanyMediaPrintContractKey = OldCompanyMediaPrintContractKey
	  ,@OldMediaPrintSpaceID = OldMediaPrintSpaceID
	  ,@CommissionablePremium = CommissionablePremium
	  ,@RootTransferFromKey = RootTransferFromKey
	From   tPurchaseOrderDetail (nolock)
	Where  PurchaseOrderDetailKey = @PurchaseOrderDetailKey			
	
	If isnull(@TransferToKey, 0) <> 0
		return -1

	If exists (select 1 from tPurchaseOrderDetail (nolock)
		where PurchaseOrderKey = @PurchaseOrderKey -- all transfers should have the same header
		and   TransferFromKey = @PurchaseOrderDetailKey
		)
		return -1

/*	see explanations in time xfer
	if @ProjectKey = @ToProjectKey 
	begin
		update tPurchaseOrderDetail set TaskKey = @ToTaskKey
		Where  PurchaseOrderDetailKey = @PurchaseOrderDetailKey	
		
		return 1
	end
*/	
	-- get new office/class
	select @CompanyKey = CompanyKey, @ToOfficeKey = OfficeKey, @ToClassKey = ClassKey
	from tProject (nolock) where ProjectKey = @ToProjectKey
	
	if isnull(@ToClassKey, 0) = 0
		select @ToClassKey = @ClassKey
	
	if @ToOfficeKey = 0 select @ToOfficeKey = null
	if @ToClassKey = 0 select @ToClassKey = null

	/*
	* First create a transaction for the new project and collect the new key
	*/
	
	BEGIN TRAN

	-- this is a clone of the old one
	INSERT INTO tPurchaseOrderDetail
           (PurchaseOrderKey
           ,LineNumber
           ,LinkID
           ,ProjectKey
           ,TaskKey
           ,ClassKey
           ,ShortDescription
           ,LongDescription
           ,ItemKey
           ,Quantity
           ,UnitCost
           ,UnitDescription
           ,TotalCost
           ,Billable
           ,Markup
           ,BillableCost
           ,AppliedCost
           ,MakeGoodKey
           ,CustomFieldKey
           ,QuoteReplyDetailKey
           ,InvoiceLineKey
           ,AmountBilled
           ,AccruedCost
           ,DateBilled
           ,Closed
           ,DetailOrderDate
           ,DetailOrderEndDate
           ,UserDate1
           ,UserDate2
           ,UserDate3
           ,UserDate4
           ,UserDate5
           ,UserDate6
           ,OrderDays
           ,OrderTime
           ,OrderLength
           ,OnHold
           ,Taxable
           ,Taxable2
           ,BilledComment
           ,TransferComment
           ,AdjustmentNumber
           ,MediaRevisionReasonKey
           ,UnitRate
           ,AutoAdjustment
           ,DateClosed
           ,OfficeKey
           ,DepartmentKey
           ,AccruedExpenseInAccountKey
           ,TransferInDate
           ,TransferOutDate
           ,TransferFromKey
           ,TransferToKey
		   ,PExchangeRate 
	       ,PCurrencyID 
	       ,PTotalCost 
	       ,PAppliedCost 
	       ,Quantity1 
	       ,Quantity2 
	       ,GrossAmount
		   ,OldDetailOrderDate
		   ,OldShortDescription
		   ,OldMediaPrintSpaceKey
		   ,OldMediaPrintPositionKey
		   ,OldCompanyMediaPrintContractKey
		   ,OldMediaPrintSpaceID
		   ,CommissionablePremium
		   ,RootTransferFromKey
		    )
     VALUES
           (@PurchaseOrderKey
           ,@LineNumber
           ,@LinkID
           ,@ToProjectKey
           ,@ToTaskKey
           ,@ToClassKey
           ,@ShortDescription
           ,@LongDescription
           ,@ItemKey
           ,@Quantity
           ,@UnitCost
           ,@UnitDescription
           ,@TotalCost
           ,@Billable
           ,@Markup
           ,@BillableCost
           ,@AppliedCost
           ,@MakeGoodKey
           ,@CustomFieldKey
           ,@QuoteReplyDetailKey
           ,@InvoiceLineKey
           ,@AmountBilled
           ,@AccruedCost
           ,@DateBilled
           ,@Closed
           ,@DetailOrderDate
           ,@DetailOrderEndDate
           ,@UserDate1
           ,@UserDate2
           ,@UserDate3
           ,@UserDate4
           ,@UserDate5
           ,@UserDate6
           ,@OrderDays
           ,@OrderTime
           ,@OrderLength
           ,@OnHold
           ,@Taxable
           ,@Taxable2
           ,@BilledComment
           --@TransferComment
           --Append: Transferred from old Project, old task
           --,@TransferFromComment + '<br>' + left(@OrigTransferComment, 500 - Len(@TransferFromComment)) 
		   ,@TransferFromComment
		   ,@AdjustmentNumber
           ,@MediaRevisionReasonKey
           ,@UnitRate
           ,@AutoAdjustment
           ,@DateClosed
           ,@ToOfficeKey
           ,@DepartmentKey
           ,@AccruedExpenseInAccountKey
           ,@TransferDate -- TransferInDate
           ,NULL		--TransferOutDate
           ,@PurchaseOrderDetailKey --TransferFromKey
           ,NULL		--TransferToKey
           ,@PExchangeRate 
	       ,@PCurrencyID 
	       ,@PTotalCost 
	       ,@PAppliedCost 
	       ,@Quantity1 
	       ,@Quantity2 
	       ,@GrossAmount
		   ,@OldDetailOrderDate
		   ,@OldShortDescription
		   ,@OldMediaPrintSpaceKey
		   ,@OldMediaPrintPositionKey
		   ,@OldCompanyMediaPrintContractKey
		   ,@OldMediaPrintSpaceID
		   ,@CommissionablePremium
		   ,isnull(@RootTransferFromKey, @PurchaseOrderDetailKey)
		   )
           

	 SELECT @TransferToKey = @@IDENTITY, @Error = @@ERROR
	 
	 IF @Error > 0
	 BEGIN	
		ROLLBACK TRAN
		RETURN -1
	 END
	 	
	/*
	* Second create a transaction for the reversal of the old project 
	*/
	
	INSERT INTO tPurchaseOrderDetail
           (PurchaseOrderKey
           ,LineNumber
           ,LinkID
           ,ProjectKey
           ,TaskKey
           ,ClassKey
           ,ShortDescription
           ,LongDescription
           ,ItemKey
           ,Quantity
           ,UnitCost
           ,UnitDescription
           ,TotalCost
           ,Billable
           ,Markup
           ,BillableCost
           ,AppliedCost
           ,MakeGoodKey
           ,CustomFieldKey
           ,QuoteReplyDetailKey
           ,InvoiceLineKey
           ,AmountBilled
           ,AccruedCost
           ,DateBilled
           ,Closed
           ,DetailOrderDate
           ,DetailOrderEndDate
           ,UserDate1
           ,UserDate2
           ,UserDate3
           ,UserDate4
           ,UserDate5
           ,UserDate6
           ,OrderDays
           ,OrderTime
           ,OrderLength
           ,OnHold
           ,Taxable
           ,Taxable2
           ,BilledComment
           ,TransferComment
           ,AdjustmentNumber
           ,MediaRevisionReasonKey
           ,UnitRate
           ,AutoAdjustment
           ,DateClosed
           ,OfficeKey
           ,DepartmentKey
           ,AccruedExpenseInAccountKey
           ,TransferInDate
           ,TransferOutDate
           ,TransferFromKey
           ,TransferToKey
		   ,PExchangeRate 
	       ,PCurrencyID 
	       ,PTotalCost 
	       ,PAppliedCost 
	       ,Quantity1 
	       ,Quantity2 
	       ,GrossAmount
		   ,OldDetailOrderDate
		   ,OldShortDescription
		   ,OldMediaPrintSpaceKey
		   ,OldMediaPrintPositionKey
		   ,OldCompanyMediaPrintContractKey
		   ,OldMediaPrintSpaceID
		   ,CommissionablePremium
		   ,RootTransferFromKey
		   )
     VALUES
           (@PurchaseOrderKey
           ,@LineNumber
           ,NULL --@LinkID
           ,@ProjectKey
           ,@TaskKey
           ,@ClassKey
           ,@ShortDescription
           ,@LongDescription
           ,@ItemKey
           ,CASE WHEN ISNULL(@Quantity, 0) = 0 THEN -1 ELSE -1 * @Quantity END
           ,@UnitCost
           ,@UnitDescription
           ,@TotalCost * -1
           ,@Billable
           ,@Markup
           ,@BillableCost * -1
           ,0--@AppliedCost
           ,NULL --@MakeGoodKey
           ,@CustomFieldKey
           ,NULL --@QuoteReplyDetailKey
           ,0--@InvoiceLineKey
           ,0--@AmountBilled
           ,0--@AccruedCost
           ,@TransferDate -- @DateBilled
           ,1 -- @Closed
           ,@DetailOrderDate
           ,@DetailOrderEndDate
           ,@UserDate1
           ,@UserDate2
           ,@UserDate3
           ,@UserDate4
           ,@UserDate5
           ,@UserDate6
           ,@OrderDays
           ,@OrderTime
           ,@OrderLength
           ,@OnHold
           ,@Taxable
           ,@Taxable2
           ,@BilledComment
            --,@TransferComment
           ,'Reversal due to ' + @TransferToComment
           ,@AdjustmentNumber
           ,@MediaRevisionReasonKey
           ,@UnitRate
           ,@AutoAdjustment
           ,@TransferDate --@DateClosed
           ,@OfficeKey
           ,@DepartmentKey
           ,@AccruedExpenseInAccountKey
           ,@TransferDate -- TransferInDate
           ,@TransferDate -- TransferOutDate
           ,@PurchaseOrderDetailKey -- TransferFromKey
           ,@TransferToKey -- TransferToKey
           ,@PExchangeRate 
	       ,@PCurrencyID 
	       ,@PTotalCost * -1
	       ,0 --@PAppliedCost 
	       ,@Quantity1 
	       ,@Quantity2 
	       ,@GrossAmount * -1
		   ,@OldDetailOrderDate
		   ,@OldShortDescription
		   ,@OldMediaPrintSpaceKey
		   ,@OldMediaPrintPositionKey
		   ,@OldCompanyMediaPrintContractKey
		   ,@OldMediaPrintSpaceID
		   ,@CommissionablePremium
		   ,isnull(@RootTransferFromKey, @PurchaseOrderDetailKey)
		   )
   		
	 SELECT @ReversalDetailKey = @@IDENTITY, @Error = @@ERROR
	 
	 IF @Error > 0
	 BEGIN	
		ROLLBACK TRAN
		RETURN -1
	 END
	     
	/*     
    * Then update the inital transaction
    */
     
     UPDATE tPurchaseOrderDetail
     SET    LinkID = null -- disconnect from Strata
           ,AppliedCost = 0 
           ,QuoteReplyDetailKey = null -- disconnect from quote
           ,AccruedCost = 0
           ,MakeGoodKey = 0
           ,Closed = 1
           ,DateClosed = @TransferDate
           --,AdjustmentNumber = null
            
		   ,DateBilled = @TransferDate
           ,InvoiceLineKey = 0 
           ,AmountBilled = 0
           
           ,TransferComment = @TransferToComment 	
           ,TransferOutDate = @TransferDate
           ,TransferToKey = @TransferToKey
           ,RootTransferFromKey = isnull(@RootTransferFromKey, @PurchaseOrderDetailKey)
	WHERE  PurchaseOrderDetailKey = @PurchaseOrderDetailKey
     	
	IF @@ERROR > 0
	 BEGIN	
		ROLLBACK TRAN
		RETURN -1
	 END
     	
	If  (select count(*) from tPurchaseOrderDetail (nolock)
		where PurchaseOrderKey = @PurchaseOrderKey -- all transfers should have the same header
		and   TransferFromKey = @PurchaseOrderDetailKey
		) > 2
	begin
		rollback tran
		return -1
	end

	COMMIT TRAN
		 	
	RETURN 1
GO
