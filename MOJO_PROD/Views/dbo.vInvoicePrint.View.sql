USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vInvoicePrint]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vInvoicePrint]
AS

  /*
  || When      Who Rel     What
  || 12/05/06 GHL 8.4      Added ShowBillingSummary flag
  || 04/24/07 GHL 8.42     Added BCGroupByOrder, IOGroupByOrder
  || 02/25/08 GHL 8.505    (21518) Added HideClientName
  || 09/22/09 GHL 10.511   (63345) Added ShowExpComments
  || 03/26/10 MFT 10.520   Added SalesTax1Name and SalesTax2Name
  || 4/16/10  CRG 10.5.2.1 Added LayoutKey
  || 06/06/11 GHL 10.5.4.5 Added Address from GL company
  || 06/07/11 GHL 10.5.4.5 Added CompanyName/Phone/Fax from GL Company to be consistent
  ||                       with what we did for the POs vPurchaseOrderDetail (issue 37963)
  || 10/21/11 GHL 10.5.4.9 (124386) Split RetainerAmount in 2 fields, 1 for sales, 1 for taxes
  || 07/10/12 GHL 10.5.5.8 (148091) Added BillingName
  || 07/18/12 RLB 10.5.5.8 (143447) Added CampaignName
  || 09/10/12 RLB 10.5.6.0 (153617) Added Show Campaign option
  || 11/14/13 RLB 10.5.7.4 (196356) Added CampaignID to CampaignName
  || 01/10/14 GHL 10.5.7.6  Added CurrencyID for multicurrency invoices
  */

SELECT  i.InvoiceKey, 
	c.CompanyKey AS ClientKey, 
	c1.CompanyName, 
	c1.Phone,
	c1.Fax,
	
	glc.GLCompanyKey,
	glc.PrintedName as GLCCompanyName,
	glc.Phone as GLCPhone,
	glc.Fax as GLCFax,

	-- Default Company Address
	a_c1.Address1 as CAddress1, 
	a_c1.Address2 as CAddress2, 
	a_c1.Address3 as CAddress3, 
	a_c1.City as CCity, 
	a_c1.State as CState, 
	a_c1.PostalCode as CPostalCode, 
	a_c1.Country as CCountry, 
	
	-- Company Address from the GL Company
	a_glc.AddressKey as GLCAddressKey,
	a_glc.Address1 as GLCAddress1,
	a_glc.Address2 as GLCAddress2,
	a_glc.Address3 as GLCAddress3,
	a_glc.City as GLCCity,
	a_glc.State as GLCState,
	a_glc.PostalCode as GLCPostalCode,
	a_glc.Country as GLCCountry,
	
	-- Billing Address: 1) From Invoice, 2) Client Billing Addr, 3) Client Default Addr 
	isnull(c.BillingName,c.CompanyName) AS BCompanyName, 
	CASE
	    WHEN i.AddressKey IS NOT NULL THEN a_i.Address1 
	    ELSE
	        CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address1
	             ELSE a_dc.Address1 
		END 
	END  AS BAddress1, 
	CASE
	    WHEN i.AddressKey IS NOT NULL THEN a_i.Address2 
	    ELSE
	        CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address2
	             ELSE a_dc.Address2
		END 
	END  AS BAddress2, 
	CASE
	    WHEN i.AddressKey IS NOT NULL THEN a_i.Address3 
	    ELSE
	        CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address3
	             ELSE a_dc.Address3
		END 
	END  AS BAddress3, 
	CASE
	    WHEN i.AddressKey IS NOT NULL THEN a_i.City 
	    ELSE
	        CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.City
	             ELSE a_dc.City
		END 
	END  AS BCity, 
	CASE   
	    WHEN i.AddressKey IS NOT NULL THEN a_i.State 
	    ELSE
	        CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.State
	             ELSE a_dc.State
		END 
	END  AS BState, 
	CASE   
	    WHEN i.AddressKey IS NOT NULL THEN a_i.PostalCode 
	    ELSE
	        CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.PostalCode
	             ELSE a_dc.PostalCode
		END 
	END  AS BPostalCode, 
	CASE   
	    WHEN i.AddressKey IS NOT NULL THEN a_i.Country 
	    ELSE
	        CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Country
	             ELSE a_dc.Country
		END 
	END  AS BCountry, 
	c.CustomerID,
	c.UserDefined1 as CLUserDefined1,
	c.UserDefined2 as CLUserDefined2,
	c.UserDefined3 as CLUserDefined3,
	c.UserDefined4 as CLUserDefined4,
	c.UserDefined5 as CLUserDefined5,
	c.UserDefined6 as CLUserDefined6,
	c.UserDefined7 as CLUserDefined7,
	c.UserDefined8 as CLUserDefined8,
	c.UserDefined9 as CLUserDefined9,
	c.UserDefined10 as CLUserDefined10,
	i.ContactName AS BillingContact, 
	pt.TermsDescription, 
	i.InvoiceNumber, 
	i.InvoiceDate, 
    i.DueDate, 
	i.RecurringParentKey,
	i.UserDefined1,
	i.UserDefined2,
	i.UserDefined3,
	i.UserDefined4,
	i.UserDefined5,
	i.UserDefined6,
	i.UserDefined7,
	i.UserDefined8,
	i.UserDefined9,
	i.UserDefined10,
	i.Posted,
	i.InvoiceStatus,
    i.HeaderComment,
	i.SalesTaxKey,
	i.SalesTax2Key,
	i.ClassKey,
	i.ARAccountKey,
	i.ParentInvoiceKey,
	i.ParentInvoice,
	i.PercentageSplit,
	ISNULL(i.AmountReceived, 0) AS PaymentAmount,
	ISNULL(i.DiscountAmount, 0) AS DiscountAmount,
	ISNULL(i.WriteoffAmount, 0) AS WriteoffAmount,
	ISNULL(i.RetainerAmount, 0) AS RetainerAmount,
	ISNULL(i.RetainerAmount, 0)
	-ISNULL((select sum(iabt.Amount) from tInvoiceAdvanceBillTax iabt (nolock) where iabt.InvoiceKey = i.InvoiceKey), 0) as RetainerAmountSales,
	ISNULL((select sum(iabt.Amount) from tInvoiceAdvanceBillTax iabt (nolock) where iabt.InvoiceKey = i.InvoiceKey), 0) as RetainerAmountTaxes,
	ISNULL(i.AmountReceived, 0) AS AmountReceived,
	ISNULL(i.InvoiceTotalAmount, 0) - isnull(i.DiscountAmount, 0) - isnull(i.RetainerAmount, 0) AS BilledAmount,
    	ISNULL(i.InvoiceTotalAmount, 0) - isnull(i.WriteoffAmount, 0) - isnull(i.DiscountAmount, 0) - isnull(i.RetainerAmount, 0) - isnull(i.AmountReceived, 0) AS OpenAmount,
    	ISNULL(i.SalesTaxAmount, 0) AS SalesTaxAmount,
	ISNULL(i.SalesTax1Amount, 0) AS SalesTax1Amount,
	ISNULL(i.SalesTax2Amount, 0) AS SalesTax2Amount,
    	ISNULL(i.TotalNonTaxAmount, 0) AS TotalNonTaxAmount,
	ISNULL(i.InvoiceTotalAmount, 0) AS InvoiceTotalAmount,
	ISNULL(st.Description, 'Sales Tax') AS SalesTaxDescription,
	st2.Description AS SalesTax2Description,
	st.SalesTaxName AS SalesTax1Name,
	st2.SalesTaxName AS SalesTax2Name,
	it.InvoiceTemplateKey,
	it.ShowAmountsAtSummary,
	it.ShowDetailLines,
	it.ShowTime,
	it.TimeSummaryLevel,
	it.ShowComments,
	it.ShowExpenses,
	it.ShowProjectCustFields,
	it.ShowProjectNumber,
	it.ShowClientProjectNumber,
	it.ClientProjectNumberLabel,
	it.ShowProjectDescription,
	it.HidePageNumbers,
	it.HideZeroReceipts,
	it.QtyDescription,
	it.LabelUserDefined1,
	it.LabelUserDefined2,
	it.LabelUserDefined3,
	it.LabelUserDefined4,
	it.LabelUserDefined5,
	it.LabelUserDefined6,
	it.LabelUserDefined7,
	it.LabelUserDefined8,
	it.LabelUserDefined9,
	it.LabelUserDefined10,
	it.FooterMessage,
	it.LogoTop,
	it.LogoLeft,
	it.LogoHeight,
	it.LogoWidth,
	it.CompanyAddressTop,
	it.CompanyAddressLeft,
	it.CompanyAddressWidth,
	it.AddPhoneFaxToAddress,
	it.ClientAddressTop,
	it.ClientAddressLeft,
	it.ClientAddressWidth,
	
	-- Company Address from the Template
	it.AddressKey as TAddressKey,
	a_it.Address1 as TAddress1,
	a_it.Address2 as TAddress2,
	a_it.Address3 as TAddress3,
	a_it.City as TCity,
	a_it.State as TState,
	a_it.PostalCode as TPostalCode,
	a_it.Country as TCountry,
	
	it.CustomLogo,
	it.NumberTop,
	it.NumberLeft,
	it.ShowInvoiceNum,
	it.ShowInvoiceDate,
	it.ShowTerms,
	it.ShowDueDate,
	it.ShowAE,
	it.ShowCampaign,
	it.RepeatHeader,
	it.LabelTop,
	it.LabelLeft,
	it.LabelWidth,
	it.InvoiceLabel,
	it.InvoiceLabelSize,
	it.InvoiceLabelForAll,
	it.FontName,
	it.HeaderFontSize,
	it.DetailFontSize,
	it.ShowClientUserDefined,
	it.AddressFont,
	it.AddressSize,
	it.AddressBold,
	it.AddressItalic,
	it.HeaderFont,
	it.HeaderSize,
	it.HeaderBold,
	it.HeaderItalic,
	it.SummaryLineFont,
	it.SummaryLineSize,
	it.SummaryLineBold,
	it.SummaryLineItalic,
	it.SummaryDescFont,
	it.SummaryDescSize,
	it.SummaryDescBold,
	it.SummaryDescItalic,
	it.DetailLineFont,
	it.DetailLineSize,
	it.DetailLineBold,
	it.DetailLineItalic,
	it.DetailDescFont,
	it.DetailDescSize,
	it.DetailDescBold,
	it.DetailDescItalic,
	it.DetailsHeaderFont,
	it.DetailsHeaderSize,
	it.DetailsHeaderBold,
	it.DetailsHeaderItalic,
	it.DetailsHeaderBorder,
	it.DetailsFont,
	it.DetailsSize,
	it.DetailsBold,
	it.DetailsItalic,
	it.FooterFont,
	it.FooterSize,
	it.FooterBold,
	it.FooterItalic,
	it.ShowLaborHrs,
	it.ShowLaborRate,
	it.ShowTitle,
	it.GroupLaborDetailBy,
	it.ShowExpDate,
	it.ShowExpDescription,
	it.ShowExpComments,
	it.ShowExpItemDesc,
	it.ShowExpQty,
	it.ShowExpRate,
	it.ShowExpNet,
	it.ShowExpMarkup,
	it.ShowExpGross,
	it.SortExpBy,
	it.GroupExpByItem,
	it.ShowZeroTaxes,
	it.BCGroup1,
	it.BCGroup2,
	it.BCGroup3,
	it.BCGroup4,
	it.BCGroup5,
	it.BCTotal1,
	it.BCTotal2,
	it.BCTotal3,
	it.BCTotal4,
	it.BCTotal5,
	it.BCHideDetails,
	it.BCCol1,
	it.BCCol2,
	it.BCCol3,
	it.BCCol4,
	it.BCCol5,
	it.BCCol6,
	it.BCCol7,
	it.BCCol8,
	it.BCColWidth1,
	it.BCColWidth2,
	it.BCColWidth3,
	it.BCColWidth4,
	it.BCColWidth5,
	it.BCColWidth6,
	it.BCColWidth7,
	it.BCColWidth8,
	it.IOGroup1,
	it.IOGroup2,
	it.IOGroup3,
	it.IOGroup4,
	it.IOGroup5,
	it.IOTotal1,
	it.IOTotal2,
	it.IOTotal3,
	it.IOTotal4,
	it.IOTotal5,
	it.IOHideDetails,
	it.IOCol1,
	it.IOCol2,
	it.IOCol3,
	it.IOCol4,
	it.IOCol5,
	it.IOCol6,
	it.IOCol7,
	it.IOColWidth1,
	it.IOColWidth2,
	it.IOColWidth3,
	it.IOColWidth4,
	it.IOColWidth5,
	it.IOColWidth6,
	it.IOColWidth7,
	it.ShowLineQuantityRate,
	it.HideCompanyName,
	it.HideClientName,
	it.ShowProduct,
	it.ShowDivision,
	it.KeepFooterTogether,
	it.ShowBillingSummary,
	it.BCGroupByOrder,
	it.IOGroupByOrder,
	p.ProjectKey,
	p.ProjectNumber,
	p.ProjectName,
	p.Description as ProjectDescription,
	ae.FirstName + ' ' + ae.LastName as AEName,
	p.ClientProjectNumber,
	p.CustomFieldKey,
	cp.ProductName,
	cd.DivisionName,
    c.CustomFieldKey as CompanyCustomFieldKey,
	i.LayoutKey,
	i.CampaignKey,
	cpn.CampaignID + ' - ' + cpn.CampaignName AS CampaignName,
	i.CurrencyID
FROM tInvoice i (nolock)
	INNER JOIN tCompany c (nolock) ON i.ClientKey = c.CompanyKey 
	INNER JOIN tCompany c1 (nolock) ON i.CompanyKey = c1.CompanyKey
	LEFT OUTER JOIN tGLCompany glc (nolock) on i.GLCompanyKey = glc.GLCompanyKey 
	LEFT OUTER JOIN tPaymentTerms pt (nolock) ON i.TermsKey = pt.PaymentTermsKey
	LEFT OUTER JOIN tSalesTax st (nolock) ON i.SalesTaxKey = st.SalesTaxKey
	LEFT OUTER JOIN tSalesTax st2 (nolock) ON i.SalesTax2Key = st2.SalesTaxKey
	LEFT OUTER JOIN tInvoiceTemplate it (nolock) ON i.InvoiceTemplateKey = it.InvoiceTemplateKey
	LEFT OUTER JOIN tProject p ON i.ProjectKey = p.ProjectKey
	LEFT OUTER JOIN tUser ae ON p.AccountManager = ae.UserKey
	LEFT OUTER JOIN tAddress a_c1 (nolock) ON c1.DefaultAddressKey = a_c1.AddressKey -- Company
	LEFT OUTER JOIN tAddress a_dc (nolock) ON c.DefaultAddressKey = a_dc.AddressKey -- Client default
	LEFT OUTER JOIN tAddress a_bc (nolock) ON c.BillingAddressKey = a_bc.AddressKey -- Client billing
	LEFT OUTER JOIN tAddress a_it (nolock) ON it.AddressKey = a_it.AddressKey -- Company on template	
	LEFT OUTER JOIN tAddress a_i (nolock) ON i.AddressKey = a_i.AddressKey -- Client on invoice
	LEFT OUTER JOIN tAddress a_glc (nolock) ON glc.AddressKey =  a_glc.AddressKey -- Company on GL company
	LEFT OUTER JOIN tClientProduct cp (NOLOCK) ON p.ClientProductKey = cp.ClientProductKey
	LEFT OUTER JOIN tClientDivision cd (NOLOCK) ON p.ClientDivisionKey = cd.ClientDivisionKey
	LEFT OUTER JOIN tCampaign cpn (NOLOCK) ON i.CampaignKey = cpn.CampaignKey

Where ParentInvoice = 0
GO
