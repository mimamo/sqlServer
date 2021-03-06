USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10518]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10518]
	

AS
	SET NOCOUNT ON

update tEstimate
set    tEstimate.CompanyKey = p.CompanyKey
from   tProject p (nolock)
where  tEstimate.ProjectKey = p.ProjectKey
		
update tCheck
set    tCheck.CompanyKey = c.OwnerCompanyKey
from   tCompany c (nolock)
where  tCheck.ClientKey = c.CompanyKey


update tProjectItemRollup
set    tProjectItemRollup.BilledAmountApproved = ISNULL((
	select sum(isum.Amount + isum.SalesTaxAmount)
		from tInvoiceSummary isum (nolock)
		inner join tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey 
			WHERE i.AdvanceBill = 0 
			and   i.InvoiceStatus = 4
			and isum.ProjectKey = tProjectItemRollup.ProjectKey
			AND   ISNULL(isum.Entity, 'tService') = tProjectItemRollup.Entity COLLATE DATABASE_DEFAULT
			AND   ISNULL(isum.EntityKey, 0) = tProjectItemRollup.EntityKey  
	),0)
	
update tProjectRollup
set    tProjectRollup.BilledAmountApproved = ISNULL((
	select sum(pir.BilledAmountApproved)
		from tProjectItemRollup pir (nolock)
	    where pir.ProjectKey = tProjectRollup.ProjectKey
	),0)
	
	RETURN
GO
