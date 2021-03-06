USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineGetTree]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineGetTree]
	@InvoiceKey int
AS --Encrypt

/*
|| When     Who Rel    What
|| 09/27/06 CRG 8.35   Added ClassID to the query. 
|| 11/12/10 GHL 10.538 Added DOHidden to hide or show DisplayOption
*/

	select 
		il.*, 
		0.000 as RollupTotal,
		p.ProjectNumber,
		p.ProjectName,
		gl.AccountNumber,
		gl.AccountName,
		wt.WorkTypeName,
		c.ClassID,
		0 AS DOHidden 
	  from tInvoiceLine il (nolock)
	  left outer join tGLAccount gl (nolock) on il.SalesAccountKey = gl.GLAccountKey
	  left outer join tProject p (nolock) on il.ProjectKey = p.ProjectKey
	  left outer join tWorkType wt (nolock) on il.WorkTypeKey = wt.WorkTypeKey
	  left outer join tClass c (nolock) on il.ClassKey = c.ClassKey
	 where il.InvoiceKey = @InvoiceKey
  order by il.InvoiceOrder
	 
	RETURN 1
GO
