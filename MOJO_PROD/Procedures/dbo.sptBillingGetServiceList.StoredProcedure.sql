USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingGetServiceList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingGetServiceList]

	@BillingKey int
	,@ServiceKey int = 0

AS --Encrypt

  /*
  || When     Who Rel   What
  || 05/15/07 GHL 8.4.2.2 Join with tBillingDetail.ServiceKey instead of tTime.ServiceKey
  ||                      more accurate after we edit labor on the billing worksheet    
  || 05/31/11 GHL 10.545 (112280) Added @ServiceKey because users can create a billing worksheet with zero billable amounts
  ||                     so that they can decide on billing them or marking them up as billed to clean them up like on the transactions screen 
  ||                     Problem is that worksheet_tm.aspx shows 0 amounts and the users can click on a service but will show as All Services on
  ||                     worksheet_tm_popup.aspx              
  */

	declare @CompanyKey int

	select @CompanyKey = CompanyKey from tBilling (nolock) where BillingKey = @BillingKey

	select -1 as EntityKey
	      ,'[No Service]' as EntityID
	
	union all

	select 
			se.ServiceKey								as EntityKey
			,se.ServiceCode + ' - ' + se.Description	as EntityID
      from tService se (nolock) 
	  where se.CompanyKey = @CompanyKey
	  and   se.ServiceKey in (select bd.ServiceKey from tBillingDetail bd (nolock) where bd.BillingKey = @BillingKey
							  union 
							  select @ServiceKey
							  )  
     
  order by EntityID asc

	return 1
GO
