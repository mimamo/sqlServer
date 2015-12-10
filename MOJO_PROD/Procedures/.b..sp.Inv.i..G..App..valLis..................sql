USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceGetApprovalList]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceGetApprovalList]

	(
		@UserKey int
	)

AS --Encrypt

Select i.*, c.CompanyName as ClientName
from tInvoice i (nolock)
	inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
Where
	i.InvoiceStatus = 2 and
	i.ApprovedByKey = @UserKey
Order By InvoiceDate
GO
