USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckGetApplied]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckGetApplied]

	(
		@CheckKey int
	)

AS --Encrypt

Select
	i.InvoiceKey,
	i.InvoiceNumber,
	(ISNULL(i.InvoiceTotalAmount, 0) - isnull(i.WriteoffAmount, 0) - isnull(i.DiscountAmount, 0) - isnull(i.RetainerAmount, 0)) as InvoiceTotal,
	i.Posted,
	i.InvoiceStatus,
	ca.CheckApplKey,
	ca.Amount,
	gl.AccountNumber,
	gl.AccountName,
	cl.ClassID,
	cl.ClassName,
	ca.Description,
	ca.Prepay
From
	tCheckAppl ca (nolock)
	Left Outer Join tInvoice i (nolock) on ca.InvoiceKey = i.InvoiceKey
	Left Outer Join tGLAccount gl (nolock) on ca.SalesAccountKey = gl.GLAccountKey
	Left Outer Join tClass cl (nolock) on ca.ClassKey = cl.ClassKey
Where 
	ca.CheckKey = @CheckKey
GO
