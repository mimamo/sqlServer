USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGraphInvoicebyStatus]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGraphInvoicebyStatus]
(
@CompanyKey int,
@InvoiceStatus int,
@ClientKey int 


)

AS --Encrypt

select 
i.*,
(ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(i.AmountReceived, 0) - ISNULL(i.RetainerAmount, 0) - ISNULL(i.WriteoffAmount, 0)) as AmountDue,
c.CompanyName
from tInvoice i (nolock) left outer join tCompany c (nolock) on c.CompanyKey = i.ClientKey
where 
	i.InvoiceStatus = @InvoiceStatus 
and 
(ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(i.AmountReceived, 0) - ISNULL(i.RetainerAmount, 0) - ISNULL(i.WriteoffAmount, 0)) <> 0 
and 
i.DueDate <= GetDate() and i.CompanyKey = @CompanyKey
and
i.ClientKey = @ClientKey 

return 1
GO
