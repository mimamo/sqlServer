USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGraphLeadClosed]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGraphLeadClosed]

@CompanyKey int,
@StartDate Datetime,
@EndDate Datetime,
@GLCompanyKey int = null,
@UserKey int = null 

AS --Encrypt

/*
  || When     Who Rel       What
  || 08/08/12 RLB 10.5.5.8  Adding GLCompany option and HMI Changes
  */



Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
From   tPreference (nolock) 
Where  CompanyKey = @CompanyKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

Select 

	Count(l.LeadKey) as OutcomeCount,
	l.AccountManagerKey as AEKey,
	u.FirstName + ' ' + u.LastName as AccountManager
	
FROM  

tLead  l (nolock) 	
inner join tLeadStatus ls (nolock) on l.LeadStatusKey = ls.LeadStatusKey
Left Outer Join tUser u (nolock) on l.AccountManagerKey = u.UserKey

WHERE    
	l.CompanyKey = @CompanyKey 
	and l.ActualCloseDate Between @StartDate and @EndDate
	and ls.Active = 0
	and (@GLCompanyKey is null or l.GLCompanyKey = @GLCompanyKey)
	and (@GLCompanyKey is not null or (@RestrictToGLCompany = 0 or l.GLCompanyKey in (select uglca.GLCompanyKey from tUserGLCompanyAccess uglca (nolock) where uglca.UserKey = @UserKey)))
Group By 
	l.AccountManagerKey,u.FirstName,u.LastName

RETURN
GO
