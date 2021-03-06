USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceGetApprovalCount]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceGetApprovalCount]

	(
		@UserKey int
	)

AS --Encrypt

Declare @Count int

Select @Count = Count(*)
from tInvoice i (nolock)
	inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
Where
	i.InvoiceStatus = 2 and
	i.ApprovedByKey = @UserKey

Return ISNULL(@Count, 0)
GO
