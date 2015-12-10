USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptCBSplitBillingUpdate]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptCBSplitBillingUpdate]
	(
		@CompanyKey int,
		@StartingInvoiceDate smalldatetime, 
		@ThroughInvoiceDate smalldatetime,
		@InvoiceDate smalldatetime,
		@ClientKey int,
		@PaymentTermsKey int
	)

AS --Encrypt

  /*
  || When     Who	Rel			What
  || 06/07/10 MAS	10.5.2.1	(76639)Created
  || 06/27/10 MAS	10.5.3.1	Removed the Inner Join back to tInvoiceLine il2
  */
		
Declare @FieldDefKey INT
		
if 	@PaymentTermsKey = 0
	Select @PaymentTermsKey = NULL

Select @StartingInvoiceDate = ISNULL(@StartingInvoiceDate, '01/01/2000')
Select @ThroughInvoiceDate = ISNULL(@ThroughInvoiceDate, '01/01/2049')

-- Figure out the CF Key we're interested
Select  @FieldDefKey = FieldDefKey 
from tFieldDef  (nolock)
Where OwnerEntityKey = @CompanyKey 
And AssociatedEntity = 'General' -- This will relate back to tCompany
And FieldName = 'Billbox'
	
Select
	i.InvoiceKey,
	ISNULL(@InvoiceDate, '') as InvoiceDate, 
	DATEADD(day, ISNULL(pt.DueDays,0), @InvoiceDate ) As DueDate,
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
	into #t	
From 	
	tInvoice i (nolock)
	inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
	Inner join tProject p (nolock) on i.ProjectKey = p.ProjectKey	
	Left Outer Join tAddress a (nolock) on a.AddressKey = c.DefaultAddressKey
	Left Outer Join tPaymentTerms pt (nolock) on pt.PaymentTermsKey = @PaymentTermsKey 
	Left Outer Join tProjectType pr (nolock) on p.ProjectTypeKey = pr.ProjectTypeKey
	Left Outer Join tFieldValue fv (nolock) on fv.ObjectFieldSetKey = c.CustomFieldKey and fv.FieldDefKey = @FieldDefKey
Where
	i.CompanyKey = @CompanyKey
	AND ISNULL(i.Posted , 0) = 0
	AND c.CompanyName LIKE 'CBREi%' -- Customer wanted to filter for only these companies
	AND (@StartingInvoiceDate IS NULL OR i.InvoiceDate >= @StartingInvoiceDate )
	And (@ThroughInvoiceDate  IS NULL OR i.InvoiceDate <= @ThroughInvoiceDate )
	AND (@ClientKey IS NULL OR i.ClientKey = @ClientKey)
	AND i.TotalNonTaxAmount <> 0
Order by c.CompanyKey	

 -- Update the InvoiceNumbers in the temp table
 DECLARE @CompanyKey2	INT
 DECLARE @RetVal		INT
 DECLARE @NextInvoiceNumber	VARCHAR(100)
			
 Select @CompanyKey2 = 0
 WHILE (1=1)
 BEGIN
	 Select @CompanyKey2 = Min(#t.CompanyKey) 
	 FROM #t 
	 WHERE #t.CompanyKey > @CompanyKey2 
	
	 IF (@CompanyKey2 IS NULL) BREAK
	 
	 EXEC spGetNextTranNo
		@CompanyKey,
		'AR',	-- TranType
		@RetVal					OUTPUT,
		@NextInvoiceNumber 		OUTPUT				
				
	 update #t
	 Set #t.InvoiceNumber = RTRIM(LTRIM(@NextInvoiceNumber))
	 Where #t.CompanyKey = @CompanyKey2 
	 OR (#t.CompanyKey = @CompanyKey2)
 END

-- Then update the InvoiceNumbers in tInvoice
Update tInvoice
Set tInvoice.InvoiceNumber = #t.InvoiceNumber,
	tInvoice.InvoiceDate = #t.InvoiceDate,
	tInvoice.DueDate = #t.DueDate
from #t
Join tInvoice (nolock) on tInvoice.InvoiceKey = #t.InvoiceKey

-- Then return the results
Select	
	InvoiceDate, 
	DueDate,
	InvoiceNumber,
	ProjectName,
	TermsDescription,
	ProjectTypeKey, ProjectTypeName,
	TotalAmount,
	SalesTaxAmount,
	CompanyName, CompanyKey,
	Address1,Address2, Address3, City, Country, State, PostalCode,
	DisplayOrder,
	BillBox ,
	TotalAmount,
	SalesTaxAmount
	from #t	
Order by CompanyKey, DisplayOrder, ProjectName
GO
