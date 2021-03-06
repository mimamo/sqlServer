USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceGetPostingList]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceGetPostingList]

	(
		@CompanyKey int
	)

AS --Encrypt

Select i.*, c.CompanyName as ClientName
from tInvoice i (nolock)
	inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
Where
	i.InvoiceStatus = 4 and
	i.Posted = 0 and
	i.CompanyKey = @CompanyKey
Order By InvoiceDate
GO
