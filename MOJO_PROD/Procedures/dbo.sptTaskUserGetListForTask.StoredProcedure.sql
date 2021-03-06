USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUserGetListForTask]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUserGetListForTask]
	(
	@TaskKey int,
	@UserKey int = NULL
	)
AS

/*
|| When		Who	Rel			What
|| 04/14/14 MAS 10.5.7.8	Exlcude the current user from the result set for the new app
|| 04/19/15 GWG 10.5.9.1    Added support for deliverables
*/

If ISNULL(@UserKey, 0) = 0
	BEGIN 
		Select tu.*, vu.UserName, s.Description as ServiceDescription, rd.DeliverableName
		From tTaskUser tu (nolock) 
		left outer join vUserName vu (nolock) on tu.UserKey = vu.UserKey
		left outer join tService s (nolock) on tu.ServiceKey = s.ServiceKey
		left outer join tReviewDeliverable rd (nolock) on tu.DeliverableKey = rd.ReviewDeliverableKey
		Where tu.TaskKey = @TaskKey
		Order By vu.UserName, s.Description
	END
Else	
	BEGIN -- Exclude the Current User from the assigned user list
		Select tu.*, vu.UserName, s.Description as ServiceDescription, rd.DeliverableName
		From tTaskUser tu (nolock) 
		left outer join vUserName vu (nolock) on tu.UserKey = vu.UserKey
		left outer join tService s (nolock) on tu.ServiceKey = s.ServiceKey
		left outer join tReviewDeliverable rd (nolock) on tu.DeliverableKey = rd.ReviewDeliverableKey
		Where tu.TaskKey = @TaskKey AND tu.UserKey <> @UserKey
		Order By vu.UserName, s.Description
	END
GO
