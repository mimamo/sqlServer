USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptCBSplitBillingGetInvoice]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptCBSplitBillingGetInvoice]
	(
		@CompanyKey int,
		@InvoiceNumber varchar(50)
	)

AS --Encrypt

  /*
  || When     Who	Rel			What
  || 06/07/10 MAS	10.5.2.1	(76639)Created
  || 06/27/10 MAS	10.5.3.1	Removed the Inner Join back to tInvoiceLine il2
  */

Declare @FieldDefKey INT

-- Figure out the CF Key we're interested
Select  @FieldDefKey = FieldDefKey 
from tFieldDef  (nolock)
Where OwnerEntityKey = @CompanyKey 
And AssociatedEntity = 'General' -- This will relate back to tCompany
And FieldName = 'Billbox'
	
Select
	i.InvoiceKey,
	i.InvoiceDate, 
	i.DueDate,
	i.InvoiceNumber, 
	LTRIM(ISNULL(p.ProjectNumber, '') + ' ' + ISNULL(p.ProjectName,'')) As ProjectName,
	pt.TermsDescription,
	pr.ProjectTypeKey, ISNULL(pr.ProjectTypeName, 'Other') as ProjectTypeName,  p.ProjectKey,
	ISNULL(i.TotalNonTaxAmount, 0)  AS TotalAmount,
	ISNULL(i.SalesTaxAmount, 0) AS SalesTaxAmount,
	c.CompanyName,  c.CompanyKey, 
	a.Address1, a.Address2, a.Address3, a.City, a.Country, a.State, a.PostalCode,
	Case pr.ProjectTypeName		-- Customer requested this sorting order
		When 'Project Services' Then 1
		When 'Shared Services' Then 2
		When 'Account Services' Then 3
		Else 4 
	End  AS DisplayOrder,
	fv.FieldValue As BillBox
From 	
	tInvoice i (nolock)
	inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
	Inner join tProject p (nolock) on i.ProjectKey = p.ProjectKey	
	Left Outer Join tAddress a (nolock) on a.AddressKey = c.DefaultAddressKey
	Left Outer Join tPaymentTerms pt (nolock) on pt.PaymentTermsKey = i.TermsKey
	Left Outer Join tProjectType pr (nolock) on p.ProjectTypeKey = pr.ProjectTypeKey
	Left Outer Join tFieldValue fv (nolock) on fv.ObjectFieldSetKey = c.CustomFieldKey and fv.FieldDefKey = @FieldDefKey
Where
	i.CompanyKey = @CompanyKey
	And i.InvoiceNumber = @InvoiceNumber
 	
Order by i.CompanyKey, DisplayOrder, ProjectName
GO
