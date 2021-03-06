USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetVoucherDetailEntries]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGetVoucherDetailEntries]

	(
		@InvoiceLineKey int
	)

AS --Encrypt

Declare @ProjectKey int

Select @ProjectKey = ProjectKey from tInvoiceLine (nolock) Where InvoiceLineKey = @InvoiceLineKey

SELECT 
	* 
FROM 
	vWIP_Voucher (NOLOCK)
WHERE
	ProjectKey = @ProjectKey
	and InvoiceLineKey is null AND
	WriteOff = 0 and 
	Status = 4
order by InvoiceDate

return 1
GO
