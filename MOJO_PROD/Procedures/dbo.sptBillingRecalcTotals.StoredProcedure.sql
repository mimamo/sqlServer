USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingRecalcTotals]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingRecalcTotals]
(
	@BillingKey int
)

as --Encrypt

  /*
  || When     Who Rel   What
  || 01/29/07 GHL 8.4   Added recalc from child worksheets when billing worksheet is parent work sheet 
  ||                    
  */
  
Declare @FFTotal money, @LaborTotal money, @ExpenseTotal money, @WOTotal money, @MBTotal money, @HoldTotal money, @OffHoldTotal money, @TransferTotal money, @DoNotBillTotal money, @GeneratedLabor money, @GeneratedExpense money, @RetainerAmount money

	
Declare @CompanyKey Int, @ParentWorksheetKey Int, @ParentWorksheet Int 

Select @CompanyKey = CompanyKey
      ,@ParentWorksheetKey = ParentWorksheetKey  -- indicates who the parent is
      ,@ParentWorksheet = ParentWorksheet        -- indicates that this is a parent
From   tBilling (nolock)
Where  BillingKey = @BillingKey

--0 = Write Off
--1 = Bill
--2 = Mark As Billed
--3 = Mark As On Hold
--4 = Mark On Hold Item As Billable
--5 = Transfer
--6 = Remove
--7 = Do Not Bill

IF @ParentWorksheet = 0
BEGIN
	-- This one is not a parent
	
	-- Rollup from detail to ws
	Select @FFTotal = Sum(Amount) from tBillingFixedFee (nolock) Where BillingKey = @BillingKey
	Select @WOTotal = Sum(Total) from tBillingDetail (nolock) Where BillingKey = @BillingKey and Action = 0
	Select @LaborTotal = Sum(Total) from tBillingDetail (nolock) Where BillingKey = @BillingKey and Action = 1 and EntityGuid is not null
	Select @ExpenseTotal = Sum(Total) from tBillingDetail (nolock) Where BillingKey = @BillingKey and Action = 1 and EntityGuid is null
	Select @MBTotal = Sum(Total) from tBillingDetail (nolock) Where BillingKey = @BillingKey and Action = 2
	Select @HoldTotal = Sum(Total) from tBillingDetail (nolock) Where BillingKey = @BillingKey and Action = 3
	Select @OffHoldTotal = Sum(Total) from tBillingDetail (nolock) Where BillingKey = @BillingKey and Action = 4
	Select @TransferTotal = Sum(Total) from tBillingDetail (nolock) Where BillingKey = @BillingKey and Action = 5
	Select @DoNotBillTotal = Sum(Total) from tBillingDetail (nolock) Where BillingKey = @BillingKey and Action = 7

	Update tBilling
	Set
		FFTotal = ISNULL(@FFTotal, 0),
		WOTotal = ISNULL(@WOTotal, 0), 
		LaborTotal = ISNULL(@LaborTotal, 0),
		ExpenseTotal = ISNULL(@ExpenseTotal, 0),
		MBTotal = ISNULL(@MBTotal, 0),
		HoldTotal = ISNULL(@HoldTotal, 0),
		OffHoldTotal = ISNULL(@OffHoldTotal, 0), 
		TransferTotal = ISNULL(@TransferTotal, 0),
		DoNotBillTotal = ISNULL(@DoNotBillTotal, 0)
	Where
		BillingKey = @BillingKey
	
END	
ELSE
BEGIN
	-- This one is a parent
	
	-- Change parent key to perform rollup
	SELECT @ParentWorksheetKey = @BillingKey
	
END

	-- And rollup from child WS to Parent WS
	If ISNULL(@ParentWorksheetKey, 0) > 0
	Begin

		Select @FFTotal = Sum(FFTotal) from tBilling (nolock) Where ParentWorksheetKey = @ParentWorksheetKey And CompanyKey = @CompanyKey
		Select @WOTotal = Sum(WOTotal) from tBilling (nolock) Where ParentWorksheetKey = @ParentWorksheetKey And CompanyKey = @CompanyKey
		Select @LaborTotal = Sum(LaborTotal) from tBilling (nolock) Where ParentWorksheetKey = @ParentWorksheetKey And CompanyKey = @CompanyKey
		Select @ExpenseTotal = Sum(ExpenseTotal) from tBilling (nolock) Where ParentWorksheetKey = @ParentWorksheetKey And CompanyKey = @CompanyKey
		Select @MBTotal = Sum(MBTotal) from tBilling (nolock) Where ParentWorksheetKey = @ParentWorksheetKey And CompanyKey = @CompanyKey
		Select @HoldTotal = Sum(HoldTotal) from tBilling (nolock) Where ParentWorksheetKey = @ParentWorksheetKey And CompanyKey = @CompanyKey
		Select @OffHoldTotal = Sum(OffHoldTotal) from tBilling (nolock) Where ParentWorksheetKey = @ParentWorksheetKey And CompanyKey = @CompanyKey
		Select @TransferTotal = Sum(TransferTotal) from tBilling (nolock) Where ParentWorksheetKey = @ParentWorksheetKey And CompanyKey = @CompanyKey
		Select @DoNotBillTotal = Sum(DoNotBillTotal) from tBilling (nolock) Where ParentWorksheetKey = @ParentWorksheetKey And CompanyKey = @CompanyKey
		Select @RetainerAmount = Sum(RetainerAmount) from tBilling (nolock) Where ParentWorksheetKey = @ParentWorksheetKey And CompanyKey = @CompanyKey
		
		Update tBilling
		Set
			FFTotal = ISNULL(@FFTotal, 0),
			WOTotal = ISNULL(@WOTotal, 0), 
			LaborTotal = ISNULL(@LaborTotal, 0),
			ExpenseTotal = ISNULL(@ExpenseTotal, 0),
			MBTotal = ISNULL(@MBTotal, 0),
			HoldTotal = ISNULL(@HoldTotal, 0),
			OffHoldTotal = ISNULL(@OffHoldTotal, 0), 
			TransferTotal = ISNULL(@TransferTotal, 0),
			DoNotBillTotal = ISNULL(@DoNotBillTotal, 0),
			RetainerAmount = ISNULL(@RetainerAmount, 0)				
		Where
			BillingKey = @ParentWorksheetKey

	End
GO
