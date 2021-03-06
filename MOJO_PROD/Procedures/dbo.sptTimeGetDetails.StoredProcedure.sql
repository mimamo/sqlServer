USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeGetDetails]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeGetDetails]
 @TimeKey uniqueidentifier,
 @TaskKey int = NULL,
 @UserKey int = NULL
AS --Encrypt

/*
|| When      Who Rel      What
|| 3/28/08   CRG 1.0.0.0  Added RegisteredUser, Billed, WipPost, BillingDetail. 
||                        These are used to determine whether a Time entry can be modified.
|| 11/6/09   CRG 10.5.1.3 Added PercComp 
|| 8/6/10    CRG 10.5.3.3 Added optional @TaskKey and @UserKey, to allow the TaskEdit balloon to load a record based on the TaskKey rather than the TimeKey.
|| 8/27/10   MAS 10.5.3.3 Added DetailTaskKey and join to tCompany for Client's full name
|| 8/17/10   GWG 10.5.3.5 Fixed an issue where the service description was not showing up in the time widget when double clicked from todays time
|| 8/15/11	 GWG 10.5.4.6 Added a check for being assigned to the task
|| 9/15/11   GMG 10.5.4.6 HF Changed logic for Timer Widget
|| 11/16/11  CRG 10.5.5.0 (126305) Added TaskDataReturned and TaskUserKey for use by the Time Entry Widget
|| 12/05/12  MFT 10.5.6.2	(161001) Added DetailTaskKey to @TaskKeySpecified = 1 result set
|| 09/12/13  WDF 10.5.7.2 (189802) Added ServiceCode, ServiceName, ServiceKey to Task data
|| 02/27/14  KMC 10.5.7.7 (207875) Added TaskUserKey for Task Entry Widget
*/

	declare @ActualHours decimal(24,4), @AllocatedHours decimal(24,4), @ActualStart smalldatetime, @ActualComplete smalldatetime, @ActualPercComp decimal(24,4), @AssignedToTask tinyint,
			@TaskUserKey int

	Declare @Registered tinyint, @BillingDetail tinyint, @TaskKeySpecified tinyint

	SELECT  @TaskKeySpecified = 0, @AssignedToTask = 0
	IF @TaskKey IS NOT NULL
		SELECT @TaskKeySpecified = 1
	ELSE
		Select @TaskKey = ISNULL(DetailTaskKey, TaskKey), @UserKey = UserKey from tTime (nolock) Where TimeKey = @TimeKey

	if @TaskKey is not null
	BEGIN
		Select @AllocatedHours = Hours, @ActualStart = ActStart, @ActualComplete = ActComplete, @ActualPercComp = PercComp, @TaskUserKey = TaskUserKey
			from tTaskUser (nolock) Where TaskKey = @TaskKey and UserKey = @UserKey
		
		Select @ActualHours = Sum(ActualHours) from tTime (nolock) Where TaskKey = @TaskKey and UserKey = @UserKey

		if exists(Select 1 from tTaskUser (nolock) Where TaskKey = @TaskKey and UserKey = @UserKey)
			Select @AssignedToTask = 1

		if exists(Select 1 from tTask (nolock) Where TaskKey = @TaskKey and AllowAnyone = 1)
			Select @AssignedToTask = 1
	END
	ELSE
	BEGIN
		Select @ActualHours = 0, @AllocatedHours = 0
	END

	if exists(Select 1 From tUser (nolock) Where UserKey = @UserKey and	Len(UserID) > 0 and	Active = 1 and ClientVendorLogin = 0)
		Select @Registered = 1
	else
		Select @Registered = 0

	if exists(Select 1 from tBillingDetail bd (nolock)
						inner join tTime t (nolock) on bd.EntityGuid = t.TimeKey
						inner join tBilling b (nolock) on bd.BillingKey = b.BillingKey  
					Where t.TimeKey = @TimeKey
					And   bd.Entity = 'tTime'
					And   b.Status < 5)
		Select @BillingDetail = 1
	else
		Select @BillingDetail = 0
	
	IF @TaskKeySpecified = 1
		SELECT
				ta.TaskKey AS DetailTaskKey,
				ta.TaskID as DetailTaskID, 
				ta.TaskName as DetailTaskName,
				bt.TaskKey as BudgetTaskKey,
				bt.TaskID as BudgetTaskID,
				bt.TaskName as BudgetTaskName,
				ta.PlanStart,
				ta.PlanComplete, 
				ta.Description,
				ta.Comments as StatusComments,
				NULL AS BillingComments,
				p.ProjectNumber, 
				p.ProjectName,
				p.ProjectNumber + ' - ' + p.ProjectName as ProjectFullName,
				pc.FirstName + ' ' + pc.LastName as PrimaryContact,
				pc.Phone1,
				pc.Cell,
				pc.Email,
				ISNULL(@AllocatedHours, 0) as AllocatedHours,
				ISNULL(@ActualHours, 0) as TotalActualHours,
				@ActualStart as UserActStart,
				@ActualComplete as UserActComplete, 
				@ActualPercComp as UserPercComp,
				NULL AS Status,
				@Registered AS RegisteredUser,
				0 AS Billed,
				0 AS WipPost,
				@BillingDetail AS BillingDetail,
				ta.PercComp,
				c.CustomerID + '-' + c.CompanyName as ClientFullName,
				p.ProjectNumber + '-' + p.ProjectName AS ProjectFullName,
				@AssignedToTask as AssignedToTask,
				CASE When t.RateLevel = 2 then ISNULL(s.Description2, s.Description)
					When t.RateLevel = 3 then ISNULL(s.Description3, s.Description)
					When t.RateLevel = 4 then ISNULL(s.Description4, s.Description)
					When t.RateLevel = 5 then ISNULL(s.Description5, s.Description)
					else ISNULL(s.Description1, s.Description) 
				END AS ServiceName,
				s.ServiceCode,
				s.ServiceKey,
				@TaskUserKey AS TaskUserKey
		FROM	tTask ta (nolock)
		LEFT JOIN tTask bt (nolock) on ta.BudgetTaskKey = bt.TaskKey
		LEFT JOIN tProject p (nolock) on ta.ProjectKey = p.ProjectKey
		LEFT JOIN tCompany c (nolock) on p.ClientKey = c.CompanyKey 
		LEFT JOIN tUser pc (nolock) on p.BillingContact = pc.UserKey
		LEFT JOIN tTaskUser tu (nolock) on ta.TaskKey = tu.TaskKey  and
		                                    tu.UserKey = @UserKey
		LEFT JOIN tService s (nolock) on tu.ServiceKey = s.ServiceKey
		LEFT JOIN tTime t (nolock) on ta.TaskKey = t.DetailTaskKey
		WHERE	ta.TaskKey = @TaskKey
	ELSE
		SELECT	t.*, 
				ta.TaskID as DetailTaskID, 
				ta.TaskName as DetailTaskName,
				bt.TaskKey as BudgetTaskKey,
				bt.TaskID as BudgetTaskID,
				bt.TaskName as BudgetTaskName,
				ta.PlanStart,
				ta.PlanComplete, 
				ta.Description,
				ta.Comments as StatusComments,
				t.Comments as BillingComments,
				p.ProjectNumber, 
				p.ProjectName,
				p.ProjectNumber + ' - ' + p.ProjectName as ProjectFullName,
				CASE When t.RateLevel = 2 then ISNULL(s.Description2, s.Description)
					When t.RateLevel = 3 then ISNULL(s.Description3, s.Description)
					When t.RateLevel = 4 then ISNULL(s.Description4, s.Description)
					When t.RateLevel = 5 then ISNULL(s.Description5, s.Description)
					else ISNULL(s.Description1, s.Description) end as ServiceName,
				s.ServiceCode,
				pc.FirstName + ' ' + pc.LastName as PrimaryContact,
				pc.Phone1,
				pc.Cell,
				pc.Email,
				ISNULL(@AllocatedHours, 0) as AllocatedHours,
				ISNULL(@ActualHours, 0) as TotalActualHours,
				@ActualStart as UserActStart,
				@ActualComplete as UserActComplete, 
				@ActualPercComp as UserPercComp,
				ts.Status,
				@Registered AS RegisteredUser,
				CASE 
					WHEN t.InvoiceLineKey IS NOT NULL OR t.WriteOff = 1 THEN 1
					ELSE 0
				END AS Billed,
				CASE
					WHEN t.WIPPostingInKey > 0 or t.WIPPostingOutKey > 0 THEN 1
					ELSE 0
				END AS WipPost,
				@BillingDetail AS BillingDetail,
				ta.PercComp,
				@AssignedToTask as AssignedToTask,
				CASE
					WHEN @TaskKey IS NOT NULL THEN 1
					ELSE 0
				END AS TaskDataReturned,
				@TaskUserKey AS TaskUserKey
			FROM tTime t (nolock)
				inner join tTimeSheet ts (nolock) on ts.TimeSheetKey = t.TimeSheetKey
				LEFT OUTER JOIN tTask ta (nolock) on t.DetailTaskKey = ta.TaskKey
				LEFT OUTER JOIN tTask bt (nolock) on t.TaskKey = bt.TaskKey
				LEFT OUTER JOIN tProject p (nolock) on t.ProjectKey = p.ProjectKey
				LEFT OUTER JOIN tUser pc (nolock) on p.BillingContact = pc.UserKey
				LEFT OUTER JOIN tService s (nolock) on t.ServiceKey = s.ServiceKey
			WHERE
				TimeKey = @TimeKey

 RETURN 1
GO
