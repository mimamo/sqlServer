USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingAddChild]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingAddChild]
(
	@BillingKey int,
	@NewChildKey int
)

As --Encrypt

  /*
  || When     Who Rel    What
  || 01/29/07 GHL 8.4    Added recalc to update parent work sheet totals 
  || 03/31/10 GHL 10.521 Added checking of line format when adding a child
  ||                    
  */
  
Declare @MaxOrder int, @DefaultARLineFormat int, @ChildBillingMethod int

Select @MaxOrder = ISNULL(Max(DisplayOrder), 0) + 1 
from   tBilling (nolock) 
Where  ParentWorksheetKey = @BillingKey

-- copy default line format from parent to child 
Select @DefaultARLineFormat = isnull(DefaultARLineFormat, 0)
from   tBilling (nolock) 
Where  BillingKey = @BillingKey

-- if line format is by Billing Item then Item i.e. not by project
if @DefaultARLineFormat = 9
begin
	Select @ChildBillingMethod = isnull(BillingMethod, 0)
	From   tBilling (nolock) 
	Where  BillingKey = @NewChildKey

	-- if billing method is FF or retainer
	if @ChildBillingMethod in (2, 3)
		select @DefaultARLineFormat = 8  -- make it by project then BI and item, FF projects will be done properly 
end

Update tBilling Set DefaultARLineFormat = @DefaultARLineFormat where BillingKey = @NewChildKey 

Delete tBillingPayment
Where BillingKey = @NewChildKey

Update tBilling
Set ParentWorksheetKey = @BillingKey, DisplayOrder = @MaxOrder
Where
	BillingKey = @NewChildKey
	
EXEC sptBillingRecalcTotals @NewChildKey
GO
