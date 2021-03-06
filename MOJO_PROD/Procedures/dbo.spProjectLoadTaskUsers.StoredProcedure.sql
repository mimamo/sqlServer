USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectLoadTaskUsers]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectLoadTaskUsers]
	(
	@ProjectKey int
	)
AS

/*
|| When      Who Rel		What
|| 6/16/09   MAS 10.5		(54796)Added the join to tUser so we could use the UserName in Flex ScheduleEdit/ScheduleEditAssign
|| 5/18/10   CRG 10.5.3.0   Modified because tTaskUser allows NULL UserKey now.
|| 3/20/10   GWG 10.5.4.2   Added Initials for Mobile
|| 08/18/11  RLB 10.5.4.7  (107905) Added actual hours for this enhancement
|| 10/18/11  GWG 10.5.4.9  Added a restriction on actual hours to the assigned service. if no service on the assignment, then count all hours.
|| 02/16/11  GWG 10.5.5.2  Added isnull on the detail task key join for actual hours
|| 08/28/12  RLB 10.5.5.9  (152637) Enhancement
|| 05/02/13  RLB 10.5.6.7  (176584) Added ServiceCode the service look up needs it
|| 04/17/15  GWG 10.5.9.1  Added loading of deliverable name w the assignment
*/

Declare @ShowActualHours int, @CompanyKey int

Select @CompanyKey = CompanyKey
From tProject (nolock)
Where ProjectKey = @ProjectKey

Select @ShowActualHours = ISNULL(ShowActualHours, 0)
From   tPreference (nolock) 
Where  CompanyKey = @CompanyKey

SELECT	ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName,'') AS UserName,
	SUBSTRING(ISNULL(u.FirstName, ''), 1, 1) + SUBSTRING(ISNULL(u.MiddleName, ''), 1, 1) + SUBSTRING(ISNULL(u.LastName, ''), 1, 1) AS Initials,
	s.Description AS ServiceDescription,
	s.ServiceCode,
	Case When @ShowActualHours = 1 or tu.ServiceKey is null then 
		(Select ISNULL(SUM(ActualHours), 0) from tTime (nolock) where UserKey = tu.UserKey and ISNULL(DetailTaskKey, tTime.TaskKey) = tu.TaskKey) 
	else
		(Select ISNULL(SUM(ActualHours), 0) from tTime (nolock) where UserKey = tu.UserKey and ISNULL(DetailTaskKey, tTime.TaskKey) = tu.TaskKey and ServiceKey = tu.ServiceKey) 
	end as ActualHours,
	tu.*,
	d.DeliverableName
FROM	tTaskUser tu (nolock) 
INNER JOIN tTask t (nolock) ON tu.TaskKey = t.TaskKey
LEFT JOIN tUser u (nolock) ON tu.UserKey = u.UserKey
LEFT JOIN tService s (nolock) ON tu.ServiceKey = s.ServiceKey
LEFT JOIN tReviewDeliverable d (nolock) ON tu.DeliverableKey = d.ReviewDeliverableKey
WHERE	t.ProjectKey = @ProjectKey
ORDER BY s.Description, u.FirstName, u.LastName
GO
