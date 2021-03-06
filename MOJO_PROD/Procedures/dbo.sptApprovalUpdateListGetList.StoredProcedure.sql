USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalUpdateListGetList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sptApprovalUpdateListGetList]
	
	 @CompanyKey int
	,@ApprovalKey int
	
as -- Encrypt

/*
|| When     Who Rel   What
|| 10/25/06 CRG 8.35  Modified to restrict to only users with ClientVendorLogin = 0.
*/

	set nocount on
	
	select us.*
		  ,isnull(us.FirstName, '') + ' ' + isnull(us.LastName, '') AS UserName
		  ,(select count(*) 
		      from tApprovalUpdateList aul (nolock) 
		     where aul.ApprovalKey = @ApprovalKey 
		       and aul.UserKey = us.UserKey
		   ) as SendUpdateTo 	
	  from tApproval ap (nolock) inner join tAssignment a (nolock) on ap.ProjectKey = a.ProjectKey
	       inner join tUser us (nolock) on a.UserKey = us.UserKey
	 where ap.ApprovalKey = @ApprovalKey
       and us.Active = 1
       and us.ClientVendorLogin = 0
  order by us.Active desc, us.FirstName, us.LastName
  
	return 1
GO
