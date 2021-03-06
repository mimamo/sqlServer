USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vExport_InvoiceDetail]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE        VIEW [dbo].[vExport_InvoiceDetail]
AS
SELECT 
	i.InvoiceKey, 
	i.CompanyKey, 
	i.InvoiceDate, 
	i.Downloaded, 
	i.InvoiceStatus,
	il.LineType, 
	il.LineSubject, 
	il.Quantity, 
	cl.ClassID,
	ISNULL(il.TotalAmount, 0) AS TotalAmount,
	CASE WHEN st.TaxRate IS NULL THEN 
		0
	ELSE 
		(ISNULL(st.TaxRate, 0) / 100) * (ISNULL(il.TotalAmount, 0)) * ISNULL(il.Taxable, 0) END TotalTaxableAmount,
	il.DisplayOrder, 
    	gl.AccountNumber AS SalesAccount,
	gl.ParentAccountKey,
	glwt.AccountNumber as BISalesAccount,
	il.Taxable,
	ISNULL(st.TaxRate, 0) as TaxRate,
	wt.WorkTypeID
FROM
	tInvoice i (NOLOCK) 
	inner join tInvoiceLine il (NOLOCK) on i.InvoiceKey = il.InvoiceKey
	left outer join tGLAccount gl (NOLOCK) on il.SalesAccountKey = gl.GLAccountKey
	left outer join tSalesTax st (NOLOCK) on i.SalesTaxKey = st.SalesTaxKey
	left outer join tWorkType wt (NOLOCK) on il.WorkTypeKey = wt.WorkTypeKey
	left outer join tGLAccount glwt (NOLOCK) on wt.GLAccountKey = glwt.GLAccountKey
	left outer join tClass cl (NOLOCK) on il.ClassKey = cl.ClassKey
WHERE 
	il.LineType = 2
GO
