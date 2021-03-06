USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceAdvanceBillGetApplyListForClient]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceAdvanceBillGetApplyListForClient]
	(
		@ClientKey int, -- must be set when InvoiceKey = 0
		@GLCompanyKey int, -- must be set when InvoiceKey = 0
		@RealInvoiceSalesTax money, -- pass taxes because they are edited on the screen  
		@InvoiceKey int,
		@AdvanceBill tinyint,
		@AppliedOnly tinyint,
	    @CurrencyID varchar(10) = null 
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
|| 10/12/10  GHL 10.536  Cloned sptInvoiceAdvanceBillGetApplyList to handle the case when InvoiceKey = 0 in flex billing screen
|| 09/27/13 GHL 10.572 (181928) Filter out voided invoices
|| 09/27/13 GHL 10.572  Added support for multi currencies
|| 04/02/14 GHL 10.578  (174684) Allowing now the selection of posted regular invoices
|| 05/28/14 GHL 10.580  (217652) Added sort by Invoice Number
|| 08/18/14 GHL 10.583  (226613) Rolled back (174684). Needs to be reviewed more carefully
|| 08/28/14 GHL 10.583  (226613) Added field from tInvoiceAdvanceBill.FromAB
||                      Allowing now posted real invoices
|| 09/02/14 WDF 10.584  (196359) Added ProjectName, CampaignName
*/

Declare @ParentCompanyKey int

/*
Select @ClientKey = ClientKey, @GLCompanyKey = GLCompanyKey
,@RealInvoiceSalesTax = isnull(SalesTaxAmount, 0) 
from tInvoice (nolock) Where InvoiceKey = @InvoiceKey
*/

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
			0 as Applied,
			i.InvoiceKey, 
			i.InvoiceNumber, 
			i.InvoiceDate, 
			i.PostingDate, 
			i.Posted,
			i.InvoiceTotalAmount, 
			p.ProjectName, 
			c.CampaignName, 
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
			as UnappliedAmount,
			0,
			0,
			ISNULL(i.SalesTaxAmount, 0) - ISNULL(
				(SELECT SUM(iabt.Amount) FROM tInvoiceAdvanceBillTax iabt (NOLOCK) 
				WHERE iabt.AdvBillInvoiceKey = i.InvoiceKey)   
			, 0) AS OpenSalesTax
			,0 AS AppliedSalesTax
			,(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) 
			- isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as OpenAmount		
			
			,0 as FromAB	-- still unapplied, so FromAB = 0 because this is a regular/real invoice  	
		From
			tInvoice i (nolock) left outer join tProject  p (nolock) on (p.ProjectKey = i.ProjectKey)
                                left outer join tCampaign c (nolock) on (c.CampaignKey = p.CampaignKey)
		Where
			i.AdvanceBill = 1 and
			i.InvoiceStatus = 4 and
			ISNULL(i.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) and
			ISNULL(i.VoidInvoiceKey, 0) = 0 AND
			ISNULL(i.CurrencyID, '') = ISNULL(@CurrencyID, '') AND
			i.ClientKey IN (SELECT CompanyKey from tCompany (NOLOCK) WHERE CompanyKey = @ClientKey 
				OR (@ParentCompanyKey <> 0 AND ParentCompanyKey = @ParentCompanyKey) 
				OR ParentCompanyKey = @ClientKey OR CompanyKey = @ParentCompanyKey)  and
			i.InvoiceTotalAmount > 0 and
			i.InvoiceKey not in (Select AdvBillInvoiceKey from tInvoiceAdvanceBill (nolock) Where tInvoiceAdvanceBill.InvoiceKey = @InvoiceKey) 
			and
			(
			((ISNULL(InvoiceTotalAmount, 0) - ISNULL((Select Sum(Amount) 
			from tInvoiceAdvanceBill (nolock) Where tInvoiceAdvanceBill.AdvBillInvoiceKey = i.InvoiceKey), 0)) > 0)
			Or
			-- Patch to show Advance Bills which have SalesTaxAmount but missing records in tInvoiceAdvanceBillTax 
			((ISNULL(SalesTaxAmount, 0) - ISNULL((Select Sum(Amount) 
			from tInvoiceAdvanceBillTax (nolock) Where tInvoiceAdvanceBillTax.AdvBillInvoiceKey = i.InvoiceKey), 0)) > 0)
			)
			
			order by i.InvoiceNumber

	else
		-- This is an Adv Bill

		-- Looking for Non Adv Bill That are open

		Select
			0 as Applied,
			i.InvoiceKey, 
			i.InvoiceNumber, 
			i.InvoiceDate, 
			i.PostingDate, 
			i.Posted,
			i.InvoiceTotalAmount, 
			p.ProjectName, 
			c.CampaignName, 
			(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) 
			- isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as UnappliedAmount,
			0,
			0,
			ISNULL(i.SalesTaxAmount, 0) - ISNULL(
				(SELECT SUM(iabt.Amount) FROM tInvoiceAdvanceBillTax iabt (NOLOCK) 
				WHERE iabt.InvoiceKey = i.InvoiceKey)   
			, 0) AS OpenSalesTax
			,0 AS AppliedSalesTax
			,(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) 
			- isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as OpenAmount
			
			,1 as FromAB -- still unapplied, so FromAB = 1 because this is an adv bill
		From
			tInvoice i (nolock) left outer join tProject  p (nolock) on (p.ProjectKey = i.ProjectKey)
                                left outer join tCampaign c (nolock) on (c.CampaignKey = p.CampaignKey)
		Where
			i.AdvanceBill = 0 and
			i.InvoiceStatus = 4 and
			--i.Posted = 0 and -- 226613 now it is possible
			ISNULL(i.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) and
			ISNULL(i.VoidInvoiceKey, 0) = 0 AND
			ISNULL(i.CurrencyID, '') = ISNULL(@CurrencyID, '') AND
			i.ClientKey IN (SELECT CompanyKey from tCompany (nolock) WHERE CompanyKey = @ClientKey OR (@ParentCompanyKey <> 0 AND ParentCompanyKey = @ParentCompanyKey) OR ParentCompanyKey = @ClientKey OR CompanyKey = @ParentCompanyKey)  
			and
			((ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) 
			- isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)
			 ) > 0)
			and
			i.InvoiceKey not in (Select InvoiceKey from tInvoiceAdvanceBill (nolock) Where tInvoiceAdvanceBill.AdvBillInvoiceKey = @InvoiceKey)

			order by i.InvoiceNumber
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
			i.PostingDate, 
			i.Posted,
			i.InvoiceTotalAmount, 
			p.ProjectName, 
			c.CampaignName, 
			(ISNULL(InvoiceTotalAmount, 0) - ISNULL((Select Sum(Amount) from tInvoiceAdvanceBill (nolock) 
				Where tInvoiceAdvanceBill.AdvBillInvoiceKey = i.InvoiceKey), 0)) as UnappliedAmount,
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

			,isnull(ab.FromAB, 0) as FromAB
		From 
			tInvoice i (nolock)
			inner join tInvoiceAdvanceBill ab (nolock) on i.InvoiceKey = ab.AdvBillInvoiceKey
			left outer join tProject  p (nolock) on (p.ProjectKey = i.ProjectKey)
			left outer join tCampaign c (nolock) on (c.CampaignKey = p.CampaignKey)
		Where
			ab.InvoiceKey = @InvoiceKey

		order by i.InvoiceNumber
	else
		-- Looking for Non Adv Bill That are open
		
		Select
			1 as Applied,
			i.InvoiceKey, 
			i.InvoiceNumber, 
			i.InvoiceDate, 
			i.PostingDate, 
			i.Posted,
			i.InvoiceTotalAmount, 
			p.ProjectName, 
			c.CampaignName, 
			(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) 
			- isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as UnappliedAmount,
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
		
			,isnull(ab.FromAB, 0) as FromAB
		
		From 
			tInvoice i (nolock)
			inner join tInvoiceAdvanceBill ab (nolock) on i.InvoiceKey = ab.InvoiceKey
			left outer join tProject  p (nolock) on (p.ProjectKey = i.ProjectKey)
			left outer join tCampaign c (nolock) on (c.CampaignKey = p.CampaignKey)
		Where
			ab.AdvBillInvoiceKey = @InvoiceKey

		order by i.InvoiceNumber

END
GO
