USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptExpenseReceiptUpdate]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptExpenseReceiptUpdate]
 @ExpenseReceiptKey int,
 @ExpenseEnvelopeKey int,
 @UserKey int,
 @ExpenseDate smalldatetime,
 @ItemKey int,
 @ProjectKey int,
 @TaskKey int,
 @PaperReceipt tinyint,
 @Taxable tinyint,
 @Taxable2 tinyint,
 @ActualQty decimal(24,4),
 @ActualUnitCost money,
 @ActualCost money,
 @Description varchar(100),
 @Comments varchar(500),
 @UnitRate money,
 @Markup decimal(24,4),
 @Billable tinyint,
 @BillableCost money,
 @SalesTaxAmount money,
 @SalesTax1Amount money,
 @SalesTax2Amount money,
 @DoProjectRollup int = 1,
 @PCurrencyID varchar(10) = null,
 @PExchangeRate decimal(24,7) = 1,
 @PTotalCost money = null,
 @GrossAmount money = null,
 @oIdentity int output

AS --Encrypt

/*
|| When		Who Rel			What
|| 02/15/07	GHL 8.4			Added project rollup section   
|| 12/04/07	GHL 8.5			(17090) Changed ActualQty and Markup to decimal(24, 4) for consistency with flash screen 
|| 03/07/11	RLB 10542		(100772) Changes for Sales Tax
|| 11/8/11	GHL 10550		(125072) Added DoProjectRollup param so that we can choose to rollup or not       
|| 11/27/13	GHL 10574		Added multi currency info. make sure exchange rate >0 
|| 01/20/14	GHL 10.575		For import compare isnull(PTotalCost, 0) to 0 rather than PTotalCost to NULL    
|| 06/09/14	MAS 15.5.8.1	Combined sptExpenseReceiptInsert & sptExpenseReceiptUpdate for Platinum                  
*/


DECLARE	@TranType INT,@BaseRollup INT,@Approved INT,@Unbilled INT,@WriteOff INT

IF ISNULL(@ExpenseReceiptKey, 0) > 0 
	BEGIN
		DECLARE @OldProjectKey INT

		if @DoProjectRollup = 1
		SELECT @OldProjectKey = ProjectKey
		FROM   tExpenseReceipt (NOLOCK)
		WHERE  ExpenseReceiptKey = @ExpenseReceiptKey

		 IF isnull(@PTotalCost, 0) = 0 
			select @PTotalCost = @ActualCost
		 IF isnull(@GrossAmount, 0) = 0 
			select @GrossAmount = @BillableCost

		 if isnull(@PExchangeRate,0) <= 0 Or isnull(@PCurrencyID, '') = ''
			select @PExchangeRate = 1

		 UPDATE
		  tExpenseReceipt
		 SET
		  ExpenseDate = @ExpenseDate,
		  ItemKey = @ItemKey,
		  ProjectKey = @ProjectKey,
		  TaskKey = @TaskKey,
		  PaperReceipt = @PaperReceipt,
		  Taxable = @Taxable,
		  Taxable2 = @Taxable2,
		  ActualQty = @ActualQty,
		  ActualUnitCost = @ActualUnitCost,
		  ActualCost = @ActualCost,
		  Description = @Description,
		  Comments = @Comments,
		  UnitRate = @UnitRate,
		  Markup = @Markup,
		  Billable = @Billable,
		  BillableCost = @BillableCost,
		  SalesTaxAmount = @SalesTaxAmount,
		  SalesTax1Amount = @SalesTax1Amount,
		  SalesTax2Amount = @SalesTax2Amount,
		  PCurrencyID = @PCurrencyID,
		  PExchangeRate = @PExchangeRate,
		  PTotalCost = @PTotalCost,
		  GrossAmount = @GrossAmount
		 WHERE
		  ExpenseReceiptKey = @ExpenseReceiptKey 

		SELECT @oIdentity = @ExpenseReceiptKey

		if @DoProjectRollup = 0
			return 1

		SELECT	@TranType = 3,@BaseRollup = 1,@Approved = 1,@Unbilled = 1,@WriteOff = 1
		EXEC sptProjectRollupUpdate @ProjectKey, @TranType, @BaseRollup,@Approved,@Unbilled,@WriteOff
		IF @OldProjectKey <> @ProjectKey
			EXEC sptProjectRollupUpdate @OldProjectKey, @TranType, @BaseRollup,@Approved,@Unbilled,@WriteOff

		RETURN 1
	END
ELSE
BEGIN
	IF @PTotalCost is null and @ActualCost is not null
		select @PTotalCost = @ActualCost
	 IF @GrossAmount is null and @BillableCost is not null
		select @GrossAmount = @BillableCost

	 if isnull(@PExchangeRate,0) <= 0
		select @PExchangeRate = 1

	 INSERT tExpenseReceipt
	  (
	  ExpenseEnvelopeKey,
	  UserKey,
	  ExpenseDate,
	  ItemKey,
	  ProjectKey,
	  TaskKey,
	  PaperReceipt,
	  Taxable,
	  Taxable2,
	  ActualQty,
	  ActualUnitCost,
	  ActualCost,
	  Description,
	  Comments,
	  UnitRate,
	  Markup,
	  Billable,
	  BillableCost,
	  SalesTaxAmount,
	  SalesTax1Amount,
	  SalesTax2Amount,
	  PCurrencyID,
	  PExchangeRate,
	  PTotalCost,
	  GrossAmount
	  )
	 VALUES
	  (
	  @ExpenseEnvelopeKey,
	  @UserKey,
	  @ExpenseDate,
	  @ItemKey,
	  @ProjectKey,
	  @TaskKey,
	  @PaperReceipt,
	  @Taxable,
	  @Taxable2,
	  @ActualQty,
	  @ActualUnitCost,
	  @ActualCost,
	  @Description,
	  @Comments,
	  @UnitRate,
	  @Markup,
	  @Billable,
	  @BillableCost,
	  @SalesTaxAmount,
	  @SalesTax1Amount,
	  @SalesTax2Amount,
	  @PCurrencyID,
	  @PExchangeRate,
	  @PTotalCost,
	  @GrossAmount
	  )
	 
	 SELECT @oIdentity = @@IDENTITY

	 if @DoProjectRollup = 0
		return 1

	SELECT	@TranType = 3,@BaseRollup = 1,@Approved = 1,@Unbilled = 1,@WriteOff = 0
	EXEC sptProjectRollupUpdate @ProjectKey, @TranType, @BaseRollup,@Approved,@Unbilled,@WriteOff

 RETURN 1
END
GO
