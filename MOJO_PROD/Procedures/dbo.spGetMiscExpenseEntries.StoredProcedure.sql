USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetMiscExpenseEntries]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGetMiscExpenseEntries]

	(
		@InvoiceLineKey int
	)

AS --Encrypt

 DECLARE @ProjectKey int
 
 SELECT @ProjectKey = ProjectKey
 FROM tInvoiceLine (NOLOCK)
 WHERE InvoiceLineKey = @InvoiceLineKey
 
SELECT 
	* 
FROM 
	vWIP_MiscCost (NOLOCK)
WHERE
	ProjectKey = @ProjectKey
	and InvoiceLineKey is null
	and WriteOff = 0
ORDER BY
	ExpenseDate
GO
