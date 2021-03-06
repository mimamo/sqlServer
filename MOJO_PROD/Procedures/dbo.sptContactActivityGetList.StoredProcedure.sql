USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptContactActivityGetList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptContactActivityGetList]

	@CompanyKey int,
	@ContactCompanyKey int,
	@UserKey int = 0,
	@Completed smallint = 0

AS --Encrypt

  /*
  || When     Who Rel   What
  || 02/20/08 GHL 8.5   Removed *= join for SQL 2005 
  || 08/25/09 RLB 105.08 Fixed SP to work with WMJ 105                 
  */

Declare @sSQL nvarchar(4000)

Select @sSQL = 'SELECT a.*, c.CompanyName, u.FirstName + '' '' + u.LastName as UserName, u.Phone1'
select @sSQL = @sSQL + ' FROM tActivity a (nolock) '
select @sSQL = @sSQL + ' INNER JOIN tCompany c (nolock) ON a.ContactCompanyKey = c.CompanyKey '
select @sSQL = @sSQL + ' LEFT OUTER JOIN tUser u (nolock) ON a.ContactKey = u.UserKey '
select @sSQL = @sSQL + ' WHERE a.CompanyKey = ' + CAST(@CompanyKey as varchar)

if isnull(@UserKey, 0) > 0 
	select @sSQL = @sSQL + ' and a.AssignedUserKey = ' + CAST(@UserKey as varchar)

if not @ContactCompanyKey IS NULL
	select @sSQL = @sSQL + ' and a.ContactCompanyKey = ' + CAST(@ContactCompanyKey as varchar)

select @sSQL = @sSQL + ' and a.Completed = ' + CAST(@Completed as varchar) 



select @sSQL = @sSQL + ' ORDER BY a.Priority, a.ActivityDate'

exec sp_executesql @sSQL

RETURN 1

 
GO
