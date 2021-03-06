USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailUpdateAppliedCost]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptPurchaseOrderDetailUpdateAppliedCost]

	(
		@PurchaseOrderDetailKey int
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 12/22/06 CRG 8.4     Modified to check if any voucher detail lines have LastVoucher = 1. If so, it does not change the Closed flags on the PO's.
|| 05/01/07 RTC 8.4.2.1 (9049) Compared the ABS value of all applied invoice costs to the ABS value of the PO detail line TotalCost to determine if the 
||                      the order should be opened or closed.  Negative cost adjustment lines were not reopened properly.
|| 10/01/07 GHL 8.5     Added logic for DateClosed  
|| 11/06/13 GHL 10.574  Added update of PAppliedCost for Multi Currency functionality
|| 09/03/14 GHL 10.584  (228260) Take in account Cancelled flags when closing/opening
*/

		Declare @POTotalCost money, @POKey int, @AppliedCost money, @Closed tinyint, @LastVoucher tinyint
		Declare @PAppliedCost money, @ExchangeRate decimal(24,7), @PExchangeRate decimal(24,7)
		Declare @POCancelled int, @PODCancelled int 

Declare @Today smalldatetime
Select @Today = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)

Select @AppliedCost = ISNULL(Sum(TotalCost), 0), @LastVoucher = ISNULL(MAX(LastVoucher), 0)
	 from tVoucherDetail (nolock) 
	 Where PurchaseOrderDetailKey = @PurchaseOrderDetailKey

Select @POTotalCost = ISNULL(pod.TotalCost, 0)
      ,@ExchangeRate = ISNULL(po.ExchangeRate, 1)
	  ,@PExchangeRate = ISNULL(pod.PExchangeRate, 1)
	  ,@POKey = po.PurchaseOrderKey
	  ,@POCancelled = isnull(po.Cancelled, 0)
	  ,@PODCancelled = isnull(pod.Cancelled, 0)
from  tPurchaseOrderDetail pod (nolock)
	inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey 
Where pod.PurchaseOrderDetailKey = @PurchaseOrderDetailKey

-- we cannot divide by 0
If @PExchangeRate <= 0
	select @PExchangeRate = 1
If @ExchangeRate <= 0
	select @ExchangeRate = 1

Select @PAppliedCost = round((@AppliedCost * @ExchangeRate) / @PExchangeRate, 2)

IF @LastVoucher = 1
BEGIN
	--Just update the Applied Cost, don't change the Closed flags
	Update tPurchaseOrderDetail
	Set AppliedCost = ISNULL(@AppliedCost, 0)
	   ,PAppliedCost = ISNULL(@PAppliedCost, 0)
	Where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
END
ELSE
BEGIN
	--Update both the Applied Cost and Closed flags
	if ABS(@POTotalCost) > ABS(@AppliedCost)
		Select @Closed = 0
	else
		Select @Closed = 1
		
	if (@PODCancelled = 1 Or @POCancelled = 1)
		Select @Closed = 1

	Update tPurchaseOrderDetail
	Set    AppliedCost = ISNULL(@AppliedCost, 0)
		  ,PAppliedCost = ISNULL(@PAppliedCost, 0)
	      ,Closed = @Closed
		  ,DateClosed = case when @Closed = 1 then
				case when DateClosed is null then @Today else DateClosed end 
				else null end 
	Where PurchaseOrderDetailKey = @PurchaseOrderDetailKey

	If exists(Select 1 from tPurchaseOrderDetail (NOLOCK) Where PurchaseOrderKey = @POKey and ISNULL(Closed, 0) = 0)
		Update tPurchaseOrder Set Closed = 0 Where PurchaseOrderKey = @POKey
	else
		Update tPurchaseOrder Set Closed = 1 Where PurchaseOrderKey = @POKey
END
GO
