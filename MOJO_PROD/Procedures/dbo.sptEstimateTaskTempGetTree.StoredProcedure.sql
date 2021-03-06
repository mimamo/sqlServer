USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskTempGetTree]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskTempGetTree]
	@EstimateKey int
	,@Entity varchar(50)
	,@EntityKey int
	,@ProjectKey int = null -- really not 

AS --Encrypt

/*
|| When     Who Rel   What
|| 03/05/10 GHL 10.519 Created to query tEstimateTaskTemp 
*/

	-- These are the GetRateFrom values in tProject and tCompany
	declare @kGetRateFromClient int             select @kGetRateFromClient = 1			-- HourlyRate in tCompany
	declare @kGetRateFromProject int            select @kGetRateFromProject = 2			-- HourlyRate in tCompany/tProject
	declare @kGetRateFromProjectUser int        select @kGetRateFromProjectUser = 3
	declare @kGetRateFromService int            select @kGetRateFromService = 4
	declare @kGetRateFromServiceRateSheet int   select @kGetRateFromServiceRateSheet = 5
	declare @kGetRateFromTask int               select @kGetRateFromTask = 6
	
	-- But as far as template tasks are concerned, we can only get them from 2 places
	-- 1) HourlyRate (if By Client or By Project)
	-- 2) Or 0
		
	declare  @HourlyRate MONEY
	
	Select  @HourlyRate = c.HourlyRate 
		from tLead l (nolock) 
			LEFT OUTER JOIN tCompany c (nolock) on l.ContactCompanyKey = c.CompanyKey 
		where l.LeadKey = @EntityKey
		
	select @HourlyRate = isnull(@HourlyRate, 0)
		
	select ta1.TaskKey
			,ta1.TaskID
			,ta1.TaskName
			,ta1.TaskLevel
			,ta1.TaskType
			,ta1.Markup
			,ta1.SummaryTaskKey
			,ta1.TaskConstraint
			,ta1.MoneyTask
			,ta1.ScheduleTask
			,ta1.ShowDescOnEst
			,ta1.Description
			,ta1.ProjectOrder
			,ta1.TrackBudget
			,case
				when ta1.TaskType=1 and isnull(ta1.TrackBudget,0) = 0 then 1
				else 0
			end as NonTrackSummary
			,case when ta1.TaskType = 1 and isnull(ta1.TrackBudget,0) = 0 then 1
			else 2 end as BudgetTaskType
			,et.EstimateKey
			,et.EstimateTaskKey
			,et.Hours
			,isnull(et.Cost, isnull(et.Rate, @HourlyRate)) As Cost
			,round(isnull(et.Cost, isnull(et.Rate, @HourlyRate)) * isnull(et.Hours, 0), 2) as BudgetLabor 
			,isnull(et.Rate, @HourlyRate)
			,et.EstLabor
			,et.BudgetExpenses
			,et.Markup as EstMarkup
			,et.EstExpenses
			,(select sum(et2.Hours * isnull(et2.Cost, isnull(et2.Rate, @HourlyRate)) )
			from  tTask ta2 (nolock)
					inner join tEstimateTask et2 (nolock) on et2.TaskKey = ta2.TaskKey
				where ta2.SummaryTaskKey = ta1.TaskKey
				and   et2.EstimateKey = @EstimateKey
				) AS DetailBudgetLabor						-- To display on estimate_tasks.aspx grid
             ,et.Comments
		from tEstimateTaskTemp ta1 (nolock)
			left outer join tEstimateTask et (nolock) on ta1.TaskKey = et.TaskKey 
			and et.EstimateKey = @EstimateKey
		where ta1.Entity = @Entity
		and ta1.EntityKey = @EntityKey
		and isnull(ta1.MoneyTask,0) = 1
		order by ta1.ProjectOrder
	 
	 
	RETURN 1
GO
