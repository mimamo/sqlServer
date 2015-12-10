USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptContactActivityGet]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptContactActivityGet]
	@ActivityKey int

AS --Encrypt

  /*
  || When     Who Rel    What
  || 11/26/07 GHL 8.5    Removed non ANSI joins for SQL 2005 
  || 01/08/09 GHL 10.016 Reading now tActivity instead of tContactActivity
  */

	SELECT 
		ca.*,
		-- Status = 1 Open, 2 Completed
		case when Completed = 1 then 2 else 1 end as Status, 
		c.CompanyName,
		c.Phone,
		u.FirstName + ' ' + u.LastName as UserName,
		u.Phone1,
		u.Phone2,
		u.Cell,
		u.Pager
	FROM 
		tActivity ca (nolock)
		INNER JOIN tCompany c (nolock) ON ca.ContactCompanyKey = c.CompanyKey
		LEFT OUTER JOIN tUser u (nolock) ON ca.ContactKey = u.UserKey
	WHERE
		ActivityKey = @ActivityKey

	RETURN 1
GO
