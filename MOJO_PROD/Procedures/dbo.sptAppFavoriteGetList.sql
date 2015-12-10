USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAppFavoriteGetList]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptAppFavoriteGetList]
(
	@UserKey int,
	@ActionID varchar(50)
)

as

/*
|| When     Who Rel			What
|| 07/31/14 QMD 10.5.8.2	changed User.Today.MyTasks to today.creative.myTasks
|| 09/03/14 MAS 10.5.8.3	changed Projects.Production.MyProjects to projects.production.myProjects added CustomerFullName
|| 09/03/14 MAS 10.5.8.3	Added FinancialStatusImage
|| 04/20/15 GWG 10.5.9.1	Added a hook out to deliverables through the taskuser record.
|| 04/21/15 GWG 10.5.9.1    Removed counting to do's as unread
*/

if @ActionID = 'Project'
	Select ProjectNumber, ProjectName
	From tProject p (nolock)
	inner join tAppFavorite af (nolock) on p.ProjectKey = af.ActionKey
	Where af.UserKey = @UserKey and af.ActionID = @ActionID
	Order By af.DisplayOrder
	
if @ActionID = 'today.creative.myTasks'
BEGIN

DECLARE @CompanyKey INT, @RateLevel INT
SELECT @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey)
      ,@RateLevel = RateLevel
FROM   tUser (NOLOCK)
WHERE  UserKey = @UserKey

SELECT t.TaskKey
	,tu.TaskUserKey 
	,t.TaskID
	,t.TaskName
	,st.TaskName as SummaryTaskName
	,t.PlanStart
	,t.PlanComplete
	,t.Priority
	,t.TaskStatus
	,ISNULL(c.CustomerID, '''') as ClientID
	,c.CompanyName as ClientName 
	,p.ProjectKey

    ,p.ProjectNumber
    ,p.ProjectName

	,Case @RateLevel 
	When 1 then ISNULL(s.Description1, s.Description)
	When 2 then ISNULL(s.Description2, s.Description)
	When 3 then ISNULL(s.Description3, s.Description)
	When 4 then ISNULL(s.Description4, s.Description)
	When 5 then ISNULL(s.Description5, s.Description)
	else s.Description
	end as ServiceName
	,s.ServiceKey
	,tu.Hours
	,ISNULL((Select Sum(ActualHours) from tTime (nolock) Where UserKey = @UserKey and ISNULL(DetailTaskKey, TaskKey) = t.TaskKey), 0) as ActualHours
	,ISNULL((Select count(*) from tActivity (nolock) Where TaskKey = t.TaskKey and Completed = 0 and ActivityEntity = 'ToDo' and (AssignedUserKey is null OR AssignedUserKey = @UserKey)), 0)  as ToDoCount
	,ISNULL((Select count(*) from tTimer (nolock) Where ISNULL(DetailTaskKey, TaskKey) = t.TaskKey and UserKey = @UserKey and ISNULL(Paused, 0) = 0), 0)  as TimerCount
	,(select Count(*) from tActivity a (nolock)
		left outer join (Select * from tAppRead (nolock) Where UserKey = @UserKey) as ar on a.ActivityKey = ar.EntityKey and ar.Entity = 'tActivity'
		Where a.ActivityEntity = 'Diary' and a.TaskKey = t.TaskKey and ISNULL(ar.IsRead, 0) = 0) +

	(select Count(*) from tSpecSheet ss (nolock)
		left outer join (Select * from tAppRead (nolock) Where UserKey = @UserKey) as ar on ss.SpecSheetKey = ar.EntityKey and ar.Entity = 'tSpecSheet'
		Where ss.EntityKey = t.ProjectKey and ss.Entity = 'Project' and ISNULL(ar.IsRead, 0) = 0) as UpdateCount
 	 
 	 ,rd.DeliverableName
     ,tu.DeliverableKey
	 
	 from tTask t (nolock)
	 INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey    
	 inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey 
	 inner join tAppFavorite af (nolock) on tu.TaskUserKey = af.ActionKey and af.ActionID = 'today.creative.myTasks'
	 left outer join tTask st (nolock) on t.SummaryTaskKey = st.TaskKey
	 LEFT OUTER JOIN tCompany c (nolock) on p.ClientKey = c.CompanyKey   
	 LEFT OUTER JOIN tService s (nolock) on t.ServiceKey = s.ServiceKey
	 LEFT OUTER JOIN tReviewDeliverable rd (nolock) on tu.DeliverableKey = rd.ReviewDeliverableKey

	Where 
		af.UserKey = @UserKey

	Order By t.Priority, t.PlanComplete

END

if @ActionID = 'projects.production.myProjects'	
	SELECT p.*	
	,CASE ISNULL(c.CustomerID,'')
			WHEN '' THEN ISNULL(ISNULL(c.CompanyName,''), '')
			ELSE 
				CASE ISNULL(c.CompanyName,'')
					WHEN '' THEN ISNULL(c.CustomerID,'')
					ELSE c.CustomerID + ' - ' + c.CompanyName
				END
			END AS CustomerFullName
	,ISNULL(p.PercComp, 0) as ProjectPercComp	
	,ISNULL(p.TaskStatus, 1) AS ProjectTaskStatus
	,CASE 
		WHEN (ISNULL(p.EstLabor, 0) + ISNULL(p.ApprovedCOLabor, 0) + ISNULL(p.EstExpenses, 0) + ISNULL(p.ApprovedCOExpense,0)) = 0 THEN 1
		WHEN (ISNULL(pr.LaborGross, 0) + ISNULL(pr.MiscCostGross, 0) + ISNULL(pr.ExpReceiptGross, 0) + ISNULL(pr.VoucherGross, 0) + ISNULL(pr.OpenOrderGross, 0) )  > 
				ISNULL(p.EstLabor, 0) + ISNULL(p.ApprovedCOLabor, 0) + ISNULL(p.EstExpenses, 0) + ISNULL(p.ApprovedCOExpense,0) THEN 3
		WHEN (ISNULL(pr.LaborGross, 0) + ISNULL(pr.MiscCostGross, 0) + ISNULL(pr.ExpReceiptGross, 0) + ISNULL(pr.VoucherGross, 0) + ISNULL(pr.OpenOrderGross, 0) ) / 
				(ISNULL(p.EstLabor, 0) + ISNULL(p.ApprovedCOLabor, 0) + ISNULL(p.EstExpenses, 0) + ISNULL(p.ApprovedCOExpense,0)) * 100 >= 80 THEN 2 -- @BudgetWarning = 80%  TODO: make a company default
		ELSE 1
	END AS FinancialStatusImage
	,CASE
		WHEN (ISNULL(p.EstLabor, 0) + ISNULL(p.ApprovedCOLabor, 0) + ISNULL(p.EstExpenses, 0) + ISNULL(p.ApprovedCOExpense,0)) = 0 THEN 0
		ELSE (ISNULL(pr.LaborGross, 0) + ISNULL(pr.MiscCostGross, 0) + ISNULL(pr.ExpReceiptGross, 0) + ISNULL(pr.VoucherGross, 0) + ISNULL(pr.OpenOrderGross, 0) ) / 
				(ISNULL(p.EstLabor, 0) + ISNULL(p.ApprovedCOLabor, 0) + ISNULL(p.EstExpenses, 0) + ISNULL(p.ApprovedCOExpense,0)) * 100 
	END AS FinancialStatusPerc
	FROM tProject p (nolock)
	INNER JOIN tAppFavorite af (nolock) on af.ActionKey = p.ProjectKey and af.ActionID = 'projects.production.myProjects'
	LEFT  JOIN tProjectRollup pr (nolock)  ON p.ProjectKey = pr.ProjectKey 
	LEFT OUTER JOIN tCompany c (nolock) on p.ClientKey = c.CompanyKey 
	WHERE 
		af.UserKey = @UserKey

	ORDER BY p.ProjectNumber
GO
