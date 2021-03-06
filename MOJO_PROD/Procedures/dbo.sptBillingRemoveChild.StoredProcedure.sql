USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingRemoveChild]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingRemoveChild]
(
	@BillingKey int
   ,@UserKey int
)

As --Encrypt

  /*
  || When     Who Rel    What
  || 01/29/07 GHL 8.4    Added recalc to update parent work sheet totals 
  || 09/26/13 WDF 10.573 (188654) Added UserKey
  ||                    
  */
  
Declare @CurOrder int, 
		@CurParent int,	
		@ClientKey int,
		@SalesTaxKey int,
		@SalesTax2Key int,
		@TermsKey int,
		@DefaultARLineFormat smallint,
		@DefaultSalesAccountKey int

Select  
	@CurOrder = DisplayOrder, 
	@ClientKey = ClientKey, 
	@CurParent = ISNULL(ParentWorksheetKey, 0) 
from tBilling (nolock) 
Where BillingKey = @BillingKey

Select 
	@SalesTaxKey = c.SalesTaxKey,
	@SalesTax2Key = c.SalesTax2Key,
	@TermsKey = p.PaymentTermsKey,
	@DefaultARLineFormat = c.DefaultARLineFormat,
	@DefaultSalesAccountKey = ISNULL(c.DefaultSalesAccountKey, p.DefaultSalesAccountKey)
From tCompany c (nolock)
	inner join tPreference p (nolock) on c.OwnerCompanyKey = p.CompanyKey
WHERE
	c.CompanyKey = @ClientKey
	
		
Update tBilling
Set ParentWorksheetKey = NULL, 
	DisplayOrder = 1,
	SalesTaxKey = @SalesTaxKey,
	SalesTax2Key = @SalesTax2Key,
	TermsKey = @TermsKey,
	DefaultARLineFormat = @DefaultARLineFormat,
	DefaultSalesAccountKey = @DefaultSalesAccountKey
Where
	BillingKey = @BillingKey
	
--Set Child Worksheet to Unapproved
EXEC sptBillingChangeStatus @BillingKey, @UserKey, 2

if @CurParent > 0
BEGIN
	Update tBilling
	Set DisplayOrder = DisplayOrder - 1
	Where ParentWorksheetKey = @CurParent and DisplayOrder >  @CurOrder


	-- Roll up from child WS to Parent WS
	EXEC sptBillingRecalcTotals @CurParent
END
GO
