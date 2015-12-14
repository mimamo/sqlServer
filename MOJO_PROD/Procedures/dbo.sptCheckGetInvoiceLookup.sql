USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckGetInvoiceLookup]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckGetInvoiceLookup]

	(
		@ClientKey int
	)

AS --Encrypt

Select
	i.*,
	(ISNULL(InvoiceTotalAmount, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as TotalDue,
	(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as TotalOpen,
	gl.AccountNumber
from tInvoice i (nolock)
	Left Outer Join tGLAccount gl (nolock) on i.ARAccountKey = gl.GLAccountKey
Where ClientKey = @ClientKey and
	AmountReceived < (ISNULL(InvoiceTotalAmount, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0))
	and InvoiceStatus = 4
Order By DueDate
GO
