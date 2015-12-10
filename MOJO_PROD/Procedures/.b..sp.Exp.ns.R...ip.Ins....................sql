USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptExpenseReceiptInsert]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptExpenseReceiptInsert]
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
  || When     Who Rel   What
  || 02/15/07 GHL 8.4   Added project rollup section       
  || 12/04/07 GHL 8.5   (17090) Changed ActualQty and Markup to decimal(24, 4) for consistency with flash screen
  || 02/09/11 RLB 10.542 (100772) Added Taxable Fields 
  || 11/8/11  GHL 10550 (125072) Added DoProjectRollup param so that we can choose to rollup or not 
  || 11/27/13 GHL 10574  Added multi currency info. make sure exchange rate >0            
  */
  
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

DECLARE	@TranType INT,@BaseRollup INT,@Approved INT,@Unbilled INT,@WriteOff INT
SELECT	@TranType = 3,@BaseRollup = 1,@Approved = 1,@Unbilled = 1,@WriteOff = 0
EXEC sptProjectRollupUpdate @ProjectKey, @TranType, @BaseRollup,@Approved,@Unbilled,@WriteOff


 RETURN 1
GO
