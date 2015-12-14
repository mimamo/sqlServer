USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceAdvanceBillGetApplyList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceAdvanceBillGetApplyList]

	(
		@InvoiceKey int,
		@AdvanceBill tinyint,
		@AppliedOnly tinyint
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 04/30/07 GHL 8.5  Added OpenSalesTax for enhancement 6523.
|| 05/14/07 GHL 8.5  Added AppliedSalesTax to show on grid
|| 01/19/09 GHL 10.017 (44636) Added open amount on adv bills so that users can apply paid only adv bills
|| 07/13/09 GHL 10.505 (56173) Calculating now Advance Bill UnappliedAmount from TotalNonTaxAmount rather than InvoiceTotalAmount 
||                     when the real invoice does not have sales taxes 
|| 11/02/09 GHL 10.513 (67009) Fixed the calculation of UnAppliedAmount when there is no tax on the real invoice
||                     = TotalNonTaxAmount - (SUM(Amount) on tInvoiceAdvanceBill - SUM(Amount) on tInvoiceAdvanceBillTax))
||                     instead of
||                     = TotalNonTaxAmount - SUM(Amount) on tInvoiceAdvanceBill - SUM(Amount) on tInvoiceAdvanceBillTax)
|| 02/26/10  GHL 10.519  (74355) Enabling now a $0 application for a reg invoice to and advance bill
||                      This is to solve the problem of an advance bill having sales overapplied
||                      The idea is to create a $0 inv with negative sales and positive taxes applied
||                      So here, show AB with SalesTaxAmount <> Sum(tInvoiceAdvanceBillTax.Amount)
|| 09/27/13 GHL 10.572 (181928) Filter out voided invoices
*/

Declare @ClientKey int, @ParentCompanyKey int, @GLCompanyKey int, @RealInvoiceSalesTax money 

Select @ClientKey = ClientKey, @GLCompanyKey = GLCompanyKey
,@RealInvoiceSalesTax = isnull(SalesTaxAmount, 0) 
from tInvoice (nolock) Where InvoiceKey = @InvoiceKey

SELECT @ParentCompanyKey = ParentCompanyKey
	FROM   tCompany (NOLOCK)
	WHERE  CompanyKey = @ClientKey
	
SELECT @ParentCompanyKey = ISNULL(@ParentCompanyKey, 0)
	
--Invoice Key is the key of the real invoice. AdvBillInvoiceKey is the advance bill
-- When creating a credit on the Advance Billings screen, we create an advance billing against itself

if @AppliedOnly = 0
BEGIN
	--Apply to a normal invoice
	if @AdvanceBill = 0
		Select
			1 as Applied,
			i.InvoiceKey, 
			i.InvoiceNumber, 
			i.InvoiceDate, 
			i.Posted,
			i.InvoiceTotalAmount, 
			case when @RealInvoiceSalesTax > 0 
			then
				(ISNULL(InvoiceTotalAmount, 0) - ISNULL((Select Sum(Amount) from tInvoiceAdvanceBill (nolock) 
				Where tInvoiceAdvanceBill.AdvBillInvoiceKey = i.InvoiceKey), 0)) 
			else
				i.TotalNonTaxAmount - (
					ISNULL((Select Sum(Amount) from tInvoiceAdvanceBill (nolock) 
					Where tInvoiceAdvanceBill.AdvBillInvoiceKey = i.InvoiceKey), 0) 	
				- ISNULL((Select Sum(Amount) from tInvoiceAdvanceBillTax (nolock) 
					Where tInvoiceAdvanceBillTax.AdvBillInvoiceKey = i.InvoiceKey), 0) 	
				)
			end					
			as UnAppliedAmount,
			ab.InvoiceAdvanceBillKey,
			ab.Amount,
			ISNULL(i.SalesTaxAmount, 0) - ISNULL(
				(SELECT SUM(iabt.Amount) FROM tInvoiceAdvanceBillTax iabt (NOLOCK) 
				WHERE iabt.AdvBillInvoiceKey = i.InvoiceKey)   
			, 0) AS OpenSalesTax
			
			-- Applied Sales Taxes for this AdvanceBill application only
			,ISNULL(
			(SELECT SUM(iabt.Amount) FROM tInvoiceAdvanceBillTax iabt (NOLOCK) 
				WHERE iabt.InvoiceKey = ab.InvoiceKey
				AND   iabt.AdvBillInvoiceKey = ab.AdvBillInvoiceKey)
			,0) AS AppliedSalesTax	
			,(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) 
			- isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as OpenAmount				
		From 
			tInvoice i (nolock)
			inner join tInvoiceAdvanceBill ab (nolock) on i.InvoiceKey = ab.AdvBillInvoiceKey
		Where
			ab.InvoiceKey = @InvoiceKey

		UNION ALL

		Select
			0 as Applied,
			i.InvoiceKey, 
			i.InvoiceNumber, 
			i.InvoiceDate, 
			i.Posted,
			i.InvoiceTotalAmount, 
			case when @RealInvoiceSalesTax > 0 
			then 
				i.InvoiceTotalAmount - ISNULL((Select Sum(Amount) from tInvoiceAdvanceBill (nolock) 
				Where tInvoiceAdvanceBill.AdvBillInvoiceKey = i.InvoiceKey), 0) 
			else
				i.TotalNonTaxAmount - (
					ISNULL((Select Sum(Amount) from tInvoiceAdvanceBill (nolock) 
					Where tInvoiceAdvanceBill.AdvBillInvoiceKey = i.InvoiceKey), 0) 	
					- ISNULL((Select Sum(Amount) from tInvoiceAdvanceBillTax (nolock) 
					Where tInvoiceAdvanceBillTax.AdvBillInvoiceKey = i.InvoiceKey), 0) 	
				)
			end	
			as UnAppliedAmount,
			0,
			0,
			ISNULL(i.SalesTaxAmount, 0) - ISNULL(
				(SELECT SUM(iabt.Amount) FROM tInvoiceAdvanceBillTax iabt (NOLOCK) 
				WHERE iabt.AdvBillInvoiceKey = i.InvoiceKey)   
			, 0) AS OpenSalesTax
			,0 AS AppliedSalesTax
			,(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) 
			- isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as OpenAmount				
		From
			tInvoice i (nolock)
		Where
			i.AdvanceBill = 1 and
			i.InvoiceStatus = 4 and
			ISNULL(i.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) and
			ISNULL(i.VoidInvoiceKey, 0) = 0 AND
			i.ClientKey IN (SELECT CompanyKey from tCompany (NOLOCK) WHERE CompanyKey = @ClientKey 
				OR (@ParentCompanyKey <> 0 AND ParentCompanyKey = @ParentCompanyKey) 
				OR ParentCompanyKey = @ClientKey OR CompanyKey = @ParentCompanyKey)  and
			i.InvoiceTotalAmount > 0 and
			i.InvoiceKey not in (Select AdvBillInvoiceKey from tInvoiceAdvanceBill Where tInvoiceAdvanceBill.InvoiceKey = @InvoiceKey) 
			and
			(
			((ISNULL(InvoiceTotalAmount, 0) - ISNULL((Select Sum(Amount) 
			from tInvoiceAdvanceBill (nolock) Where tInvoiceAdvanceBill.AdvBillInvoiceKey = i.InvoiceKey), 0)) > 0)
			Or
			-- Patch to show Advance Bills which have SalesTaxAmount but missing records in tInvoiceAdvanceBillTax 
			((ISNULL(SalesTaxAmount, 0) - ISNULL((Select Sum(Amount) 
			from tInvoiceAdvanceBillTax (nolock) Where tInvoiceAdvanceBillTax.AdvBillInvoiceKey = i.InvoiceKey), 0)) > 0)
			)
			

	else
		-- This is an Adv Bill
		
		-- Looking for all applied
		Select
			1 as Applied,
			i.InvoiceKey, 
			i.InvoiceNumber, 
			i.InvoiceDate, 
			i.Posted,
			i.InvoiceTotalAmount, 
			(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) 
			- isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as UnAppliedAmount,
			ab.InvoiceAdvanceBillKey,
			ab.Amount,
			ISNULL(i.SalesTaxAmount, 0) - ISNULL(
				(SELECT SUM(iabt.Amount) FROM tInvoiceAdvanceBillTax iabt (NOLOCK) 
				WHERE iabt.InvoiceKey = i.InvoiceKey
				Or iabt.AdvBillInvoiceKey = i.InvoiceKey
				)      
			, 0) AS OpenSalesTax
			
			-- Applied Sales Taxes for this AdvanceBill application only
			,ISNULL(
			(SELECT SUM(iabt.Amount) FROM tInvoiceAdvanceBillTax iabt (NOLOCK) 
				WHERE iabt.InvoiceKey = ab.InvoiceKey
				AND   iabt.AdvBillInvoiceKey = ab.AdvBillInvoiceKey)
			,0) AS AppliedSalesTax		
			,(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) 
			- isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as OpenAmount
		From 
			tInvoice i (nolock)
			inner join tInvoiceAdvanceBill ab (nolock) on i.InvoiceKey = ab.InvoiceKey
		Where
			ab.AdvBillInvoiceKey = @InvoiceKey

		UNION ALL

		-- Looking for Non Adv Bill That are open
		Select
			0 as Applied,
			i.InvoiceKey, 
			i.InvoiceNumber, 
			i.InvoiceDate, 
			i.Posted,
			i.InvoiceTotalAmount, 
			(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) 
			- isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as UnAppliedAmount,
			0,
			0,
			ISNULL(i.SalesTaxAmount, 0) - ISNULL(
				(SELECT SUM(iabt.Amount) FROM tInvoiceAdvanceBillTax iabt (NOLOCK) 
				WHERE iabt.InvoiceKey = i.InvoiceKey)   
			, 0) AS OpenSalesTax
			,0 AS AppliedSalesTax
			,(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) 
			- isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as OpenAmount
			
		From
			tInvoice i (nolock)
		Where
			i.AdvanceBill = 0 and
			i.InvoiceStatus = 4 and
			i.Posted = 0 and
			ISNULL(i.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) and
			ISNULL(i.VoidInvoiceKey, 0) = 0 AND
			i.ClientKey IN (SELECT CompanyKey from tCompany WHERE CompanyKey = @ClientKey OR (@ParentCompanyKey <> 0 AND ParentCompanyKey = @ParentCompanyKey) OR ParentCompanyKey = @ClientKey OR CompanyKey = @ParentCompanyKey)  
			and
			((ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) 
			- isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)
			 ) > 0)
			and
			i.InvoiceKey not in (Select InvoiceKey from tInvoiceAdvanceBill (nolock) Where tInvoiceAdvanceBill.AdvBillInvoiceKey = @InvoiceKey)
END
ELSE
BEGIN
	-- Show Applied Only
	
	--Apply to a normal invoice
	if @AdvanceBill = 0
		Select
			1 as Applied,
			i.InvoiceKey, 
			i.InvoiceNumber, 
			i.InvoiceDate, 
			i.Posted,
			i.InvoiceTotalAmount, 
			(ISNULL(InvoiceTotalAmount, 0) - ISNULL((Select Sum(Amount) from tInvoiceAdvanceBill (nolock) 
				Where tInvoiceAdvanceBill.AdvBillInvoiceKey = i.InvoiceKey), 0)) as UnAppliedAmount,
			ab.InvoiceAdvanceBillKey,
			ab.Amount,
			ISNULL(i.SalesTaxAmount, 0) - ISNULL(
				(SELECT SUM(iabt.Amount) FROM tInvoiceAdvanceBillTax iabt (NOLOCK) 
				WHERE iabt.AdvBillInvoiceKey = i.InvoiceKey)   
			, 0) AS OpenSalesTax
			
			-- Applied Sales Taxes for this AdvanceBill application only
			,ISNULL(
			(SELECT SUM(iabt.Amount) FROM tInvoiceAdvanceBillTax iabt (NOLOCK) 
				WHERE iabt.InvoiceKey = ab.InvoiceKey
				AND   iabt.AdvBillInvoiceKey = ab.AdvBillInvoiceKey)
			,0) AS AppliedSalesTax		
			,(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) 
			- isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as OpenAmount

		From 
			tInvoice i (nolock)
			inner join tInvoiceAdvanceBill ab (nolock) on i.InvoiceKey = ab.AdvBillInvoiceKey
		Where
			ab.InvoiceKey = @InvoiceKey

	else
		-- Looking for Non Adv Bill That are open
		Select
			1 as Applied,
			i.InvoiceKey, 
			i.InvoiceNumber, 
			i.InvoiceDate, 
			i.Posted,
			i.InvoiceTotalAmount, 
			(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) 
			- isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as UnAppliedAmount,
			ab.InvoiceAdvanceBillKey,
			ab.Amount,
			ISNULL(i.SalesTaxAmount, 0) - ISNULL(
				(SELECT SUM(iabt.Amount) FROM tInvoiceAdvanceBillTax iabt (NOLOCK) 
				WHERE iabt.InvoiceKey = i.InvoiceKey
				Or iabt.AdvBillInvoiceKey = i.InvoiceKey)   
			, 0) AS OpenSalesTax
			
			-- Applied Sales Taxes for this AdvanceBill application only
			,ISNULL(
			(SELECT SUM(iabt.Amount) FROM tInvoiceAdvanceBillTax iabt (NOLOCK) 
				WHERE iabt.InvoiceKey = ab.InvoiceKey
				AND   iabt.AdvBillInvoiceKey = ab.AdvBillInvoiceKey)
			,0) AS AppliedSalesTax		
			,(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) 
			- isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as OpenAmount
		From 
			tInvoice i (nolock)
			inner join tInvoiceAdvanceBill ab (nolock) on i.InvoiceKey = ab.InvoiceKey
		Where
			ab.AdvBillInvoiceKey = @InvoiceKey

END
GO
