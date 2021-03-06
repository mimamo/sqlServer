USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckApplGet]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckApplGet]
 @CheckApplKey int
AS --Encrypt

Select
	i.InvoiceNumber,
	i.ClientKey,
	gl.AccountNumber,
	gl.AccountName,
	cl.ClassID,
	cl.ClassName,
	ca.*,
	ch.ReferenceNumber
From
	tCheckAppl ca (nolock)
	inner join tCheck ch (nolock) on ch.CheckKey = ca.CheckKey
	Left Outer join tInvoice i (nolock) on ca.InvoiceKey = i.InvoiceKey
	Left Outer Join tGLAccount gl (nolock) on ca.SalesAccountKey = gl.GLAccountKey
	Left Outer Join tClass cl (nolock) on ca.ClassKey = cl.ClassKey
Where 
	ca.CheckApplKey = @CheckApplKey
GO
