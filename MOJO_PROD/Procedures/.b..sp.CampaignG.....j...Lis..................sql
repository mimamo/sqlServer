USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignGetProjectList]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignGetProjectList]
	@CampaignKey int,
	@IncludeTasks tinyint = 1,
	@ProjectKey int = null
AS

/*
|| When      Who Rel      What
|| 1/14/10   CRG 10.5.1.7 Created
|| 4/26/10   CRG 10.5.2.1 Added PlanDuration to project query
|| 4/27/10   CRG 10.5.2.1 Added TaskStatus to project query
|| 7/8/10    CRG 10.5.3.2 Removed ProjectNumber and TaskID from DisplayName
|| 8/17/10   CRG 10.5.3.3 Added optional @IncludeTasks parm so that this can be called by sptCampaignGet to just return the projects.
||                        Also added CampaignOrder
|| 11/18/10  GHL 10.5.3.8 Changed DisplayName to project full name
|| 11/19/20  GHL 10.5.3.8 Added fields to change on the task edit ballon on the schedule grid
|| 11/23/10  GHL 10.5.3.9 Added ProjectKey to restrict the dataset after task edit balloon 
|| 11/23/10  GHL 10.5.3.9 Added fields to change on the project edit ballon on the schedule grid
|| 11/30/10  GHL 10.5.3.9 Added openIcon to control visibility of open icon for projects/segments
|| 10/04/12  RLB 10.5.6.0 (155991) Added check for project with a locked status
*/


create table #projects (ProjectKey int null, ScheduleDirection int null, WorkSun int null, WorkMon int null, WorkTue int null, WorkWed int null, WorkThur int null, WorkFri int null, WorkSat int null)
 
if isnull(@ProjectKey, 0) > 0 
	insert #projects (ProjectKey, ScheduleDirection, WorkSun, WorkMon, WorkTue, WorkWed, WorkThur, WorkFri, WorkSat)
	SELECT	p.ProjectKey
			-- fields needed by Task Edit balloon
			,p.ScheduleDirection,p.WorkSun, p.WorkMon, p.WorkTue, p.WorkWed, p.WorkThur, p.WorkFri, p.WorkSat 
	FROM	tProject p (nolock)
	WHERE	p.ProjectKey = @ProjectKey
else
	insert #projects (ProjectKey, ScheduleDirection, WorkSun, WorkMon, WorkTue, WorkWed, WorkThur, WorkFri, WorkSat)
	SELECT	p.ProjectKey
			-- fields needed by Task Edit balloon
			,p.ScheduleDirection,p.WorkSun, p.WorkMon, p.WorkTue, p.WorkWed, p.WorkThur, p.WorkFri, p.WorkSat 
	FROM	tProject p (nolock)
	LEFT JOIN tCampaignSegment cs (nolock) ON p.CampaignSegmentKey = cs.CampaignSegmentKey
	WHERE	p.CampaignKey = @CampaignKey
	OR		cs.CampaignKey = @CampaignKey

	SELECT	p.ProjectKey,
			p.ProjectNumber,
			p.ProjectName, 
			p.Closed,
			ISNULL(p.ProjectNumber + ' - ', '') + ISNULL(p.ProjectName, '') AS DisplayName, 
		    p.Description,
			p.AccountManager,
			isnull(u.FirstName + ' ', '') + u.LastName as AccountManagerName,
			p.ProjectStatusKey,
			p.CampaignSegmentKey,
			p.StartDate AS PlanStart,
			p.CompleteDate AS PlanComplete,
			DATEDIFF(DAY, p.StartDate, p.CompleteDate) AS PlanDuration,
			1 AS TaskStatus, --Initialize to 1, the MAX from the tasks will be rolled up in Flex by the Rollup manager
			ISNULL(p.CampaignOrder, 0) AS CampaignOrder
			-- fields needed by the Project Edit balloon
			,'edit' as editIcon
			,p.StatusNotes
			,p.ClientNotes
			,p.DetailedNotes
			,p.ProjectColor
			,ps.ProjectStatusID 
			,ps.ProjectStatus
			,ps.Locked 
			,pbs.ProjectBillingStatusID 
			,pbs.ProjectBillingStatus
			-- fields needed by the Task Add balloon
			,'new' as addIcon
			-- fields needed by the Project Open balloon (target)
			,'menuPC' as openIcon

	FROM	tProject p (nolock)
	INNER JOIN #projects tmp ON p.ProjectKey = tmp.ProjectKey
	left outer join tUser u (nolock) on p.AccountManager = u.UserKey
	left outer join tProjectStatus ps (nolock) on ps.ProjectStatusKey = p.ProjectStatusKey
	left outer join tProjectBillingStatus pbs (nolock) on pbs.ProjectBillingStatusKey = p.ProjectBillingStatusKey
	ORDER BY p.CampaignOrder

	IF @IncludeTasks = 1
	BEGIN
		SELECT	t.TaskKey
		INTO	#tasks
		FROM	tTask t (nolock)
		INNER JOIN #projects tmp ON t.ProjectKey = tmp.ProjectKey
		WHERE	t.ScheduleTask = 1
	
		SELECT	t.TaskKey,
				t.ProjectKey,
				ISNULL(t.TaskName, '') AS DisplayName,
				t.DisplayOrder,
				t.ProjectOrder,
				t.SummaryTaskKey,
				t.TaskType,
				t.TaskLevel,
				t.PlanStart,
				t.PlanComplete,
				t.PercComp,
				t.PercCompSeparate,
				t.BaseStart,
				t.BaseComplete,
				t.PlanDuration,
				t.TaskID,
				t.TaskStatus,
				-- fields below needed for task edit balloon
				case when t.TaskType = 2 then 'edit' else null end as editIcon,
				t.ActStart,
				t.ActComplete,
				t.TaskConstraint,
				t.ConstraintDate,
				t.WorkAnyDay,
				t.Priority,
				t.Comments,
				t.Description,
				p.ScheduleDirection,
				p.WorkSun, p.WorkMon, p.WorkTue, p.WorkWed, p.WorkThur, p.WorkFri, p.WorkSat	
					 
		FROM	tTask t (nolock)
		INNER JOIN #tasks tmp ON t.TaskKey = tmp.TaskKey
		INNER JOIN #projects p ON t.ProjectKey = p.ProjectKey
		ORDER BY t.ProjectKey, t.ProjectOrder
	
		SELECT	tp.*
		FROM	tTaskPredecessor tp (nolock)
		INNER JOIN #tasks tmp ON tp.TaskKey = tmp.TaskKey
	
		SELECT	tu.*,
				SUBSTRING(ISNULL(FirstName, ''),1,1) + SUBSTRING(ISNULL(MiddleName, ''),1,1) + SUBSTRING(ISNULL(LastName, ''),1,1) AS Initials
		FROM	tTaskUser tu (nolock)
		INNER JOIN tUser u (nolock) ON tu.UserKey = u.UserKey
		INNER JOIN #tasks tmp ON tu.TaskKey = tmp.TaskKey
	END
GO
