USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spTrafficGetTime]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTrafficGetTime]
	(
		@CompanyKey int,
		@StartDate datetime,
		@EndDate datetime,
		@ProjectStatusKey int = NULL,
		@OfficeKey int = NULL,
		@DepartmentKey int = NULL,
		@ServiceKey int = NULL,
		@UserKey int = NULL,
		@TeamKey int = NULL,
		@SearchProjectKey int = NULL,
		@ClientKey int = NULL
	)
	
AS

  /*
  || When     Who Rel       What
  || 8/24/09  GWG 10.508    Modified the join to tTask so that detailedtaskkey can be null
  || 8/24/09  GWG 10.508    Removed the restrications on department and active status so that all time is pulled.
  || 10/07/09 GHL 10.512    Removed transactions which have been transferred out to other projects
  || 7/29/10  MAS 10.5.3.3 (85631) added filters SearchProjectKey and ClientKey  
  || 8/27/10  MAS 10.5.3.3  Added t.verified
  || 9/13/10  CRG 10.5.3.5  Added TimeKey
  || 10/15/11 GWG 10.5.4.9  Added a filter for Team
  */
  
Select 
	'tTime' as Entity
	,t.TimeKey
	,t.TaskKey
	,t.DetailTaskKey
	,t.UserKey
	,t.ServiceKey
	,u.FirstName + ' ' + u.LastName				AS FormattedName
	,p.ProjectNumber + ' - ' + ProjectName		AS ProjectFullName
    ,t.ProjectKey								AS ProjectKey
    ,ta.TaskID
    ,ta.TaskName
	,t.WorkDate									AS PlanStart
	,t.WorkDate									AS PlanComplete
	,1											AS PlanDuration
	,1											AS WorkAnyDay
	,t.ActualHours								AS Hours
	,t.Comments
	,t.StartTime
	,t.EndTime
	,t.UserKey
	,t.Verified
	,u.CompanyKey
	,1 AS WorkSun, 1 AS WorkMon, 1 AS WorkTue, 1 AS WorkWed, 1 AS WorkThur, 1 AS WorkFri, 1 AS WorkSat 
	,0											AS PercComp
	,0											AS ActualHours
From
	tTime t (nolock)
	inner join tUser u (nolock) on t.UserKey = u.UserKey
	inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
	left outer join tTask ta (nolock) on ISNULL(t.DetailTaskKey, t.TaskKey) = ta.TaskKey
Where
		  t.WorkDate >= @StartDate
	AND   t.WorkDate <= @EndDate
	AND   p.CompanyKey = @CompanyKey
	AND   (@OfficeKey IS NULL OR u.OfficeKey = @OfficeKey)
	AND   (@DepartmentKey IS NULL OR u.DepartmentKey = @DepartmentKey)
	AND   (@SearchProjectKey IS NULL OR p.ProjectKey = @SearchProjectKey)
	AND   (@ClientKey IS NULL OR p.ClientKey = @ClientKey)
	AND   (@TeamKey IS NULL OR t.UserKey in (Select UserKey from tTeamUser (nolock) Where TeamKey = @TeamKey))
	
	/*	Removed so that all time is pulled regardless of the status of projects you are searching for
		AND   (
			(@ProjectStatusKey = -1 AND p.Active = 1)
			 OR 
			(@ProjectStatusKey = -2 AND p.Active = 0 )
			OR
			 @ProjectStatusKey = -3
			OR
			 p.ProjectStatusKey = @ProjectStatusKey
		  )
	AND	  (@ServiceKey IS NULL OR t.ServiceKey = @ServiceKey) */
	
	AND   u.Active = 1	
	AND   t.TransferToKey is null
GO
