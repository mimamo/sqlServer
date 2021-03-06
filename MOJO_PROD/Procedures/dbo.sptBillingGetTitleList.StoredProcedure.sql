USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingGetTitleList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingGetTitleList]

	@BillingKey int
	,@TitleKey int = 0

AS --Encrypt

  /*
  || When     Who Rel    What
  || 11/17/14 GHL 10.586 Cloned sptBillingGetServiceList to support the use of titles
  */

	declare @CompanyKey int

	select @CompanyKey = CompanyKey from tBilling (nolock) where BillingKey = @BillingKey

	select -1 as EntityKey
	      ,'[No Title]' as EntityID
	
	union all

	select 
			ti.TitleKey as EntityKey
			,ti.TitleName as EntityID
      from tTitle ti (nolock) 
	  where ti.CompanyKey = @CompanyKey
	  and   ti.TitleKey in (select t.TitleKey 
								from tBillingDetail bd (nolock)
									inner join tTime t (nolock) on bd.EntityGuid = t.TimeKey 
								where bd.BillingKey = @BillingKey
							  union 
								select @TitleKey
							  )  
     
  order by EntityID asc
GO
