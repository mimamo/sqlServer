USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckGetAppliedGL]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckGetAppliedGL]

	(
		@CheckKey int
	)

AS --Encrypt

Select
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
	Left Outer Join tGLAccount gl (nolock) on ca.SalesAccountKey = gl.GLAccountKey
	Left Outer Join tClass cl (nolock) on ca.ClassKey = cl.ClassKey
Where 
	ca.CheckKey = @CheckKey and ca.InvoiceKey is null
GO
