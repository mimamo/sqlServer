USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUserSearchTaskList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec sptTaskUserSearchTaskList 16, '2/1/2014', 3, NULL

CREATE PROCEDURE [dbo].[sptTaskUserSearchTaskList]
 (  
  @UserKey int  
 ,@AsOfDate smalldatetime
 ,@Section smallint
 ,@SearchText varchar(500)
 ,@OtherPeoplesTasks int
 ,@CompletedPredecessors int
 )  
AS --Encrypt  
  
 SET NOCOUNT ON  
  
/*  
|| When      Who Rel      What  
   01/14/14   GWG 10.5.7.6 Created for today page in new app
   06/23/14   QMD 10.5.8.1 Added @OtherPeoplesTasks and @CompletedPredecessors option
   12/30/14   MAS 10.5.8.7 Added p.CompanyKey = @CompanyKey to the WHERE clauses
|| 04/20/15 GWG 10.5.9.1	Added a hook out to deliverables through the taskuser record.
|| 04/23/15 RLB 10.5.9.1   (254121) @CompletedPredecessors = 0 will not come into this as a null so both completed and not completed tasks are pulled into search
*/  

DECLARE @CompanyKey INT, @RateLevel INT, @DepartmentKey INT
SELECT @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey)
      ,@RateLevel = RateLevel
      ,@DepartmentKey = DepartmentKey
      ,@AsOfDate = DATEADD(d, 7, @AsOfDate)
FROM   tUser (NOLOCK)
WHERE  UserKey = @UserKey

-- Assigned  to my department
if @Section = 1
BEGIN	
	SELECT t.TaskKey
		,tu.TaskUserKey 
		,t.TaskID
		,t.TaskName
		,st.TaskName as SummaryTaskName
		,ISNULL(c.CustomerID, '''') as ClientID
		,c.CompanyName as ClientName 

		,t.PlanStart
		,t.PlanComplete
		,t.Priority
		,p.ProjectNumber
		,p.ProjectName
		,u.FirstName + ' ' + u.LastName as AssignedTo

		,ISNULL(s.Description, '(no service)') as ServiceName
		,tu.Hours
		,(Select Sum(ActualHours) from tTime (nolock) Where UserKey = @UserKey and ISNULL(DetailTaskKey, TaskKey) = t.TaskKey) as ActualHours
		,rd.DeliverableName
		
	 from tTask t (nolock)
	 INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey    
	 inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey 
	 inner join tUser u (nolock) on tu.UserKey = u.UserKey
	 LEFT OUTER JOIN tCompany c (nolock) on p.ClientKey = c.CompanyKey   
	 left outer join tTask st (nolock) on t.SummaryTaskKey = st.TaskKey
	 LEFT OUTER JOIN tService s (nolock) on tu.ServiceKey = s.ServiceKey
	 LEFT OUTER JOIN tReviewDeliverable rd (nolock) on tu.DeliverableKey = rd.ReviewDeliverableKey

	Where 
		t.PlanStart <= @AsOfDate
		and p.CompanyKey = @CompanyKey
		and tu.PercComp < 100
		and (@CompletedPredecessors IS NULL OR t.PredecessorsComplete = @CompletedPredecessors)
		and p.Active = 1
		and u.DepartmentKey = @DepartmentKey
		and u.UserKey <> @UserKey 
		and (@SearchText is null OR t.TaskName like '%' + @SearchText + '%' 
				OR p.ProjectNumber like '%' + @SearchText + '%' OR p.ProjectName like '%' + @SearchText + '%' OR c.CompanyName like '%' + @SearchText + '%')
	Order By t.Priority, t.PlanComplete
END
  
  
-- all tasks for services I can perform
if @Section = 2
BEGIN

	if @OtherPeoplesTasks = 1
	   BEGIN	   
		SELECT t.TaskKey
			,tu.TaskUserKey 
			,t.TaskID
			,t.TaskName
			,st.TaskName as SummaryTaskName
			,t.PlanStart
			,t.PlanComplete
			,t.Priority
			,ISNULL(c.CustomerID, '''') as ClientID
			,c.CompanyName as ClientName 

			,u.FirstName + ' ' + u.LastName as AssignedTo
			,p.ProjectNumber
			,p.ProjectName

			,ISNULL(s.Description, '(no service)') as ServiceName
			,tu.Hours
			,(Select Sum(ActualHours) from tTime (nolock) Where UserKey = @UserKey and ISNULL(DetailTaskKey, TaskKey) = t.TaskKey) as ActualHours
			,rd.DeliverableName
			
		 from tTask t (nolock)
		 INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey    
		 INNER JOIN tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey 
		 LEFT OUTER JOIN tUserService us (nolock) on tu.ServiceKey = us.ServiceKey
		 LEFT OUTER JOIN tUser u (nolock) on tu.UserKey = u.UserKey
		 LEFT OUTER JOIN tTask st (nolock) on t.SummaryTaskKey = st.TaskKey
		 LEFT OUTER JOIN tCompany c (nolock) on p.ClientKey = c.CompanyKey   
		 LEFT OUTER JOIN tService s (nolock) on tu.ServiceKey = s.ServiceKey
	  	 LEFT OUTER JOIN tReviewDeliverable rd (nolock) on tu.DeliverableKey = rd.ReviewDeliverableKey

		Where 
			t.PlanStart <= @AsOfDate
			and p.CompanyKey = @CompanyKey
			and (us.UserKey = @UserKey OR us.UserKey IS NULL)
			and tu.PercComp < 100
			and tu.UserKey <> @UserKey
			and (@CompletedPredecessors IS NULL OR t.PredecessorsComplete = @CompletedPredecessors)
			and p.Active = 1
			and (@SearchText is null OR t.TaskName like '%' + @SearchText + '%' 
					OR p.ProjectNumber like '%' + @SearchText + '%' OR p.ProjectName like '%' + @SearchText + '%' OR c.CompanyName like '%' + @SearchText + '%')
		Order By t.Priority, t.PlanComplete
	   END
	  else
	   BEGIN
		SELECT t.TaskKey
			,tu.TaskUserKey 
			,t.TaskID
			,t.TaskName
			,st.TaskName as SummaryTaskName
			,t.PlanStart
			,t.PlanComplete
			,t.Priority
			,ISNULL(c.CustomerID, '''') as ClientID
			,c.CompanyName as ClientName 

			,u.FirstName + ' ' + u.LastName as AssignedTo
			,p.ProjectNumber
			,p.ProjectName

			,ISNULL(s.Description, '(no service)') as ServiceName
			,tu.Hours
			,(Select Sum(ActualHours) from tTime (nolock) Where UserKey = @UserKey and ISNULL(DetailTaskKey, TaskKey) = t.TaskKey) as ActualHours
			,rd.DeliverableName
			
		 from tTask t (nolock)
		 INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey    
		 inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey 
		 inner join tUserService us (nolock) on tu.ServiceKey = us.ServiceKey
		 left outer join tUser u (nolock) on tu.UserKey = u.UserKey
		 left outer join tTask st (nolock) on t.SummaryTaskKey = st.TaskKey
		 LEFT OUTER JOIN tCompany c (nolock) on p.ClientKey = c.CompanyKey   
		 LEFT OUTER JOIN tService s (nolock) on tu.ServiceKey = s.ServiceKey
		 LEFT OUTER JOIN tReviewDeliverable rd (nolock) on tu.DeliverableKey = rd.ReviewDeliverableKey

		Where 
			t.PlanStart <= @AsOfDate
			and p.CompanyKey = @CompanyKey
			and us.UserKey = @UserKey
			and tu.PercComp < 100
			and tu.UserKey is null
			and (@CompletedPredecessors IS NULL OR t.PredecessorsComplete = @CompletedPredecessors)
			and p.Active = 1
			and (@SearchText is null OR t.TaskName like '%' + @SearchText + '%' 
					OR p.ProjectNumber like '%' + @SearchText + '%' OR p.ProjectName like '%' + @SearchText + '%' OR c.CompanyName like '%' + @SearchText + '%')
		Order By t.Priority, t.PlanComplete
	   END
END



-- unassigned tasks
if @Section = 3
BEGIN

SELECT t.TaskKey
	,tu.TaskUserKey 
	,t.TaskID
	,t.TaskName
	,st.TaskName as SummaryTaskName
	,t.PlanStart
	,t.PlanComplete
	,t.Priority
	,ISNULL(c.CustomerID, '''') as ClientID
	,c.CompanyName as ClientName 

    ,p.ProjectNumber
    ,p.ProjectName

	,tu.Hours
	,(Select Sum(ActualHours) from tTime (nolock) Where UserKey = @UserKey and ISNULL(DetailTaskKey, TaskKey) = t.TaskKey) as ActualHours
	,rd.DeliverableName
	
 from tTask t (nolock)
 INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey    
 left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey 
 left outer join tTask st (nolock) on t.SummaryTaskKey = st.TaskKey
 LEFT OUTER JOIN tCompany c (nolock) on p.ClientKey = c.CompanyKey   
LEFT OUTER JOIN tReviewDeliverable rd (nolock) on tu.DeliverableKey = rd.ReviewDeliverableKey

Where 
	t.PlanStart <= @AsOfDate
	and p.CompanyKey = @CompanyKey
	and t.PercComp < 100
	and (@CompletedPredecessors IS NULL OR t.PredecessorsComplete = @CompletedPredecessors)
	and p.Active = 1
	and tu.TaskUserKey is null
	and (@SearchText is null OR t.TaskName like '%' + @SearchText + '%' 
			OR p.ProjectNumber like '%' + @SearchText + '%' OR p.ProjectName like '%' + @SearchText + '%' OR c.CompanyName like '%' + @SearchText + '%')
Order By t.Priority, t.PlanComplete

END


RETURN 1
GO
