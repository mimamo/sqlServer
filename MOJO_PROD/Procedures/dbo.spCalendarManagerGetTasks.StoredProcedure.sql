USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerGetTasks]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerGetTasks]
	@UserKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@ExcludeCompletedTasks tinyint,
	@PredecessorsComplete tinyint
AS

/*
|| When      Who Rel      What
|| 10/31/08  CRG 10.5.0.0 Created for the CalendarManager to get Tasks for a user
|| 3/4/09    CRG 10.5.0.0 Added StatusNotes and DetailedNotes
|| 07/08/09  QMD 10.5.0.2 Per Chris ... we need a left join since clients are dependent on naming convention
|| 8/27/09   CRG 10.5.0.8 (61656) Restricted to only active projects
|| 2/1/10    CRG 10.5.1.8 (73187) Added @PredecessorsComplete
|| 02/09/10  MFT 10.5.1.8 (74377) Added HideFromClient
|| 03/02/10  RLB 10.5.1.9 (72925) Only task project whos status is not on hold
|| 4/8/11    CRG 10.5.4.3 (108032) Fixed the date range restriction in the where clause
|| 12/16/11  CRG 10.5.5.1 (128351) Added ProjectNumber and TaskNameOnly
*/

	SELECT	t.TaskKey, 
			t.TaskName AS TaskNameOnly,
			ISNULL(t.TaskID, '') + '-' + ISNULL(t.TaskName, '') AS TaskName, 
			t.ShowOnCalendar,
			CASE t.ShowOnCalendar
				WHEN 1 THEN t.EventStart
				ELSE t.PlanStart
			END AS EventStart,
			CASE t.ShowOnCalendar
				WHEN 1 THEN t.EventEnd
				ELSE t.PlanComplete
			END AS EventEnd,
			p.ProjectKey,
			p.ProjectColor,
			p.ProjectNumber,
			ISNULL(p.ProjectNumber, '') + '-' + ISNULL(p.ProjectName, '') AS ProjectName,
			ISNULL(c.CustomerID, '') + '-' + ISNULL(c.CompanyName, '') AS Client,
			u.UserName,
			p.StatusNotes,
			p.DetailedNotes,
			t.HideFromClient
	FROM	tTask t (nolock)
	INNER JOIN tTaskUser tu (nolock) ON t.TaskKey = tu.TaskKey
	INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey
	LEFT JOIN tCompany c (nolock) ON p.ClientKey = c.CompanyKey
	INNER JOIN vUserName u (nolock) ON tu.UserKey = u.UserKey
	INNER JOIN tProjectStatus ps (nolock) ON p.ProjectStatusKey = ps.ProjectStatusKey
	WHERE	t.PlanComplete >= @StartDate
	AND		t.PlanStart <= @EndDate
	AND		tu.UserKey = @UserKey
	AND		(ISNULL(t.PercComp, 0) <> 100 OR @ExcludeCompletedTasks = 0)
	AND		p.Active = 1
	AND		ISNULL(ps.OnHold, 0) = 0
	AND		t.PredecessorsComplete >= @PredecessorsComplete
GO
