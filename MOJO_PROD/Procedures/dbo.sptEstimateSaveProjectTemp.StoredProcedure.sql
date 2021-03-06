USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateSaveProjectTemp]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateSaveProjectTemp]
	(
	@Entity varchar(50) 
	,@EntityKey int
	,@ProjectKey int
	)
AS --Encrypt
	SET NOCOUNT ON

/*
|| When     Who Rel       What
|| 03/12/10 GHL 10.519  Creation for opportunities
*/

	IF ISNULL(@EntityKey, 0) = 0
		RETURN 1
	
	IF ISNULL(@ProjectKey, 0) = 0
		RETURN 1
	
	IF EXISTS (SELECT 1 FROM tEstimateTaskTemp (NOLOCK) WHERE Entity = @Entity AND EntityKey = @EntityKey)
		RETURN 1
	
	INSERT tEstimateTaskTemp
           ([Entity]
           ,[EntityKey]
           ,[TaskKey]
           ,[ProjectKey]
           ,[TaskID]
           ,[TaskName]
           ,[Description]
           ,[TaskType]
           ,[SummaryTaskKey]
           ,[DisplayOrder]
           ,[HourlyRate]
           ,[Markup]
           ,[IOCommission]
           ,[BCCommission]
           ,[ShowDescOnEst]
           ,[Visibility]
           ,[ServiceKey]
           ,[Taxable]
           ,[Taxable2]
           ,[WorkTypeKey]
           ,[PlanStart]
           ,[PlanComplete]
           ,[PlanDuration]
           ,[ActStart]
           ,[ActComplete]
           ,[PercComp]
           ,[TaskStatus]
           ,[TaskConstraint]
           ,[ScheduleNote]
           ,[Comments]
           ,[BaseStart]
           ,[BaseComplete]
           ,[ScheduleTask]
           ,[MoneyTask]
           ,[TrackBudget]
           ,[HideFromClient]
           ,[ProjectOrder]
           ,[TaskLevel]
           ,[EstHours]
           ,[BudgetLabor]
           ,[EstLabor]
           ,[BudgetExpenses]
           ,[EstExpenses]
           ,[ApprovedCOHours]
           ,[ApprovedCOLabor]
           ,[ApprovedCOBudgetLabor]
           ,[ApprovedCOExpense]
           ,[ApprovedCOBudgetExp]
           ,[Contingency]
           ,[MasterTaskKey]
           ,[AllowAnyone]
           ,[ConstraintDate]
           ,[PercCompSeparate]
           ,[WorkAnyDay]
           ,[PredecessorsComplete]
           ,[TaskAssignmentTypeKey]
           ,[CustomFieldKey]
           ,[ReviewedByTraffic]
           ,[ReviewedByDate]
           ,[ReviewedByKey]
           ,[EventStart]
           ,[EventEnd]
           ,[ShowOnCalendar]
           ,[TaskAssignmentKey]
           ,[Priority]
           ,[ShowEstimateDetail]
           ,[RollupOnEstimate]
           ,[RollupOnInvoice]
           ,[TimeZoneIndex]
           ,[DueBy]
           ,[BudgetTaskKey]
           ,[CompletedByDate]
           ,[CompletedByKey]
           ,[TimeZoneConverted])
     SELECT
		   @Entity	
           ,@EntityKey
           ,TaskKey
           ,ProjectKey
           ,TaskID
           ,TaskName
           ,Description
           ,TaskType
           ,SummaryTaskKey
           ,DisplayOrder
           ,HourlyRate
           ,Markup
           ,IOCommission
           ,BCCommission
           ,ShowDescOnEst
           ,Visibility
           ,ServiceKey
           ,Taxable
           ,Taxable2
           ,WorkTypeKey
           ,PlanStart
           ,PlanComplete
           ,PlanDuration
           ,ActStart
           ,ActComplete
           ,PercComp
           ,TaskStatus
           ,TaskConstraint
           ,ScheduleNote
           ,Comments
           ,BaseStart
           ,BaseComplete
           ,ScheduleTask
           ,MoneyTask
           ,TrackBudget
           ,HideFromClient
           ,ProjectOrder
           ,TaskLevel
           ,EstHours
           ,BudgetLabor
           ,EstLabor
           ,BudgetExpenses
           ,EstExpenses
           ,ApprovedCOHours
           ,ApprovedCOLabor
           ,ApprovedCOBudgetLabor
           ,ApprovedCOExpense
           ,ApprovedCOBudgetExp
           ,Contingency
           ,MasterTaskKey
           ,AllowAnyone
           ,ConstraintDate
           ,PercCompSeparate
           ,WorkAnyDay
           ,PredecessorsComplete
           ,TaskAssignmentTypeKey
           ,CustomFieldKey
           ,ReviewedByTraffic
           ,ReviewedByDate
           ,ReviewedByKey
           ,EventStart
           ,EventEnd
           ,ShowOnCalendar
           ,TaskAssignmentKey
           ,Priority
           ,ShowEstimateDetail
           ,RollupOnEstimate
           ,RollupOnInvoice
           ,TimeZoneIndex
           ,DueBy
           ,BudgetTaskKey
           ,CompletedByDate
           ,CompletedByKey
           ,TimeZoneConverted
    FROM   tTask (nolock)
    WHERE  ProjectKey = @ProjectKey
    
    IF @@ERROR <> 0
		RETURN -1
    
     INSERT tEstimateTaskTempPredecessor
           ([Entity]
           ,[EntityKey]
           ,[TaskPredecessorKey]
           ,[TaskKey]
           ,[PredecessorKey]
           ,[Type]
           ,[Lag])
     SELECT
           @Entity			
           ,@EntityKey
           ,tp.TaskPredecessorKey
           ,tp.TaskKey
           ,tp.PredecessorKey
           ,tp.Type
           ,tp.Lag   
	FROM tTaskPredecessor tp (nolock)
	INNER JOIN tTask t (nolock) ON t.TaskKey = tp.TaskKey
	WHERE t.ProjectKey = @ProjectKey
	
   IF @@ERROR <> 0
		RETURN -1
 	
	INSERT tEstimateTaskTempUser
           ([Entity]
           ,[EntityKey]
           ,[UserKey]
           ,[TaskKey]
           ,[Hours]
           ,[PercComp]
           ,[ActStart]
           ,[ActComplete]
           ,[ReviewedByTraffic]
           ,[ReviewedByDate]
           ,[ReviewedByKey]
           ,[CompletedByDate]
           ,[CompletedByKey]
           ,[ServiceKey]
           ,[TaskUserKey]
           ,[Subject]
           ,[Description]
           ,[Comments])
     SELECT
		   @Entity
           ,@EntityKey
           ,tu.UserKey
           ,tu.TaskKey
           ,tu.Hours
           ,tu.PercComp
           ,tu.ActStart
           ,tu.ActComplete
           ,tu.ReviewedByTraffic
           ,tu.ReviewedByDate
           ,tu.ReviewedByKey
           ,tu.CompletedByDate
           ,tu.CompletedByKey
           ,tu.ServiceKey
           ,tu.TaskUserKey
           ,tu.Subject
           ,tu.Description
           ,tu.Comments
	FROM tTaskUser tu (nolock)
	INNER JOIN tTask t (nolock) ON t.TaskKey = tu.TaskKey
	WHERE t.ProjectKey = @ProjectKey
           
  IF @@ERROR <> 0
		RETURN -1
            
	RETURN 1
GO
