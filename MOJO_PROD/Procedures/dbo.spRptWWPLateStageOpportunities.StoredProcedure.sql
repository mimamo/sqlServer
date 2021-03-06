USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptWWPLateStageOpportunities]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptWWPLateStageOpportunities]
	(
	@CompanyKey int,
	@AccountManagerKey int -- -1 All or > 0 valid user
	)
AS
	SET NOCOUNT ON
	
  /*
  || When     Who Rel       What
  || 06/01/09 GHL 10.5.0.0  Creation for Blair's WWP Business Development Report
  || 09/8/09  GWG 10.5.0.9  Changed how the level is gotten to be based on current level, not level history
  || 08/03/11 RLB 10.5.4.6  (117407) Only pulling Leads in an active lead status only
  */

	-- no nulls or zeroes
	select @AccountManagerKey = isnull(@AccountManagerKey, -1)
	if @AccountManagerKey = 0 select @AccountManagerKey = -1

	select co.CompanyName
	       ,l.Subject
	       ,l.SaleAmount
	       ,a.Subject as ActivitySubject
	       ,a.ActivityDate
	       ,isnull(au.FirstName, '') + ' ' + isnull(au.LastName, '') as AssignedTo
           ,l.WWPCurrentLevel as Level			
	from   tLead l (nolock)
		inner join tCompany co (nolock) on l.ContactCompanyKey = co.CompanyKey
		left outer join tActivity a (nolock) on l.NextActivityKey = a.ActivityKey 
		left outer join tUser au (nolock) on a.AssignedUserKey = au.UserKey
		left outer join tLeadStatus ls (nolock) on l.LeadStatusKey = ls.LeadStatusKey

	where  l.CompanyKey = @CompanyKey
	and    l.ActualCloseDate is null
	and   (@AccountManagerKey = -1 Or l.AccountManagerKey = @AccountManagerKey) 
	and    l.WWPCurrentLevel > 2 -- only 3 or 4
	and	   ls.Active = 1

		   		
			
	
	
	RETURN 1
GO
