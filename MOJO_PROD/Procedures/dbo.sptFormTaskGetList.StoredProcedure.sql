USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormTaskGetList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptFormTaskGetList]

	(
		 @TaskKey int
		,@UserKey int
	)

AS --Encrypt

Select 
	f.*, fd.FormPrefix + '-' + Cast(f.FormNumber as varchar(10)) as FormFullNumber,
	uauth.FirstName + ' ' + uauth.LastName as AuthorName,
	(select uass.FirstName + ' ' + uass.LastName 
	  from tUser uass (nolock)
	 where f.AssignedTo = uass.UserKey) as AssignedName,
	(Case f.Priority When 1 Then 'High'
		When 2 then 'Medium'
		When 3 then 'Low'
		else 'Medium' end) as FormPriority,
	isnull((select 1
	         from tUser us (nolock) inner join tSecurityAccess sa (nolock) on us.SecurityGroupKey = sa.SecurityGroupKey
	        where us.UserKey = @UserKey
	          and sa.Entity = 'tFormDef'
	          and sa.EntityKey = fd.FormDefKey)
	         ,0) as HasAccess
from
	tForm f (nolock),
	tFormDef fd (nolock),
	tUser uauth (nolock)
Where
	f.FormDefKey = fd.FormDefKey and
	f.Author = uauth.UserKey and
	f.TaskKey = @TaskKey and
	f.DateClosed IS NULL
GO
