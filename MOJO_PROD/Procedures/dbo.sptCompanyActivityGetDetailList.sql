USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyActivityGetDetailList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyActivityGetDetailList]

	(
		@CompanyKey int,
		@ContactCompanyKey int,
		@ContactKey int,
		@ShowAll tinyint,
		@LeadKey int = NULL
	)

AS --Encrypt

  /*
  || When     Who Rel    What
  || 01/08/09 GHL 10.016 Reading now tActivity instead of tContactActivity
  */

if @ShowAll = 1
SELECT 
	ca.*, 
	c.CompanyName, 
	u.FirstName + ' ' + u.LastName as UserName, 
	u.Phone1
 FROM tActivity ca (nolock)
 inner join tCompany c (nolock) on  ca.ContactCompanyKey = c.CompanyKey
 left outer join tUser u (nolock) on ca.ContactKey = u.UserKey
 
 Where ca.CompanyKey = @CompanyKey    
    and ca.ContactCompanyKey = @ContactCompanyKey
    and (@LeadKey is null or ca.LeadKey = @LeadKey)
  ORDER BY ca.ActivityDate DESC

else
SELECT 
	ca.*, 
	c.CompanyName, 
	u.FirstName + ' ' + u.LastName as UserName, 
	u.Phone1
 FROM tActivity ca (nolock)
 inner join tCompany c (nolock) on  ca.ContactCompanyKey = c.CompanyKey
 left outer join tUser u (nolock) on ca.ContactKey = u.UserKey
 
 Where ca.CompanyKey = @CompanyKey    
    and ca.ContactCompanyKey = @ContactCompanyKey
    and ca.ContactKey = @ContactKey
    and (@LeadKey is null or ca.LeadKey = @LeadKey)
 ORDER BY ca.ActivityDate DESC
GO
