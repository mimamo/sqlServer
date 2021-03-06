USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeRecalcCost]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeRecalcCost]

	 @CompanyKey int
	,@StartDate smalldatetime
	,@EndDate smalldatetime
	
AS
	
  /*
  || When     Who Rel		What
  || 08/12/10 GHL 10.533    (80011) Recalculating now tProjectItemRollup + tProjectRollup records    
  || 11/19/13 GHL 10.574    Updating now HCostRate   
  */

declare @UserKey int
declare @MonthlyCost money
declare @MonthlyHours decimal(24,4)
declare @HCostRate money

create table #project(ProjectKey int null)

	select @UserKey = -1	
	while(1=1)
		begin
			select @UserKey = min(UserKey)
			from tUser (nolock)
			where CompanyKey = @CompanyKey
			and UserKey > @UserKey
			and isnull(MonthlyCost, 0) > 0
			
			if @UserKey is null
				break
			
			select @MonthlyCost = MonthlyCost
			from tUser (nolock)
			where UserKey = @UserKey
						
			select @MonthlyHours = isnull(sum(isnull(ActualHours, 0)), 0)
			from tTime (nolock)
			where tTime.UserKey = @UserKey
			and WorkDate between @StartDate and @EndDate
			
			if @MonthlyHours > 0
				begin
					-- since this is a cost from tUser, the cost in in home currency
					select @HCostRate = @MonthlyCost / @MonthlyHours
					
					update tTime
					set HCostRate = @HCostRate
						-- and now convert to project currency
					   ,CostRate = case 
							when ExchangeRate = 0 then @HCostRate
							else @HCostRate / ExchangeRate 
									end 
					where tTime.UserKey = @UserKey
					and WorkDate between @StartDate and @EndDate
		
					insert #project (ProjectKey)
					select distinct ProjectKey
					from   tTime (nolock)
					where  UserKey = @UserKey
					and    WorkDate between @StartDate and @EndDate
		

				end
		end
		


-- Update the 2 rollup pieces of info which are affected by CostRate 

CREATE TABLE #rollup (ProjectKey INT, ServiceKey INT NULL, LaborNet MONEY NULL, LaborNetApproved MONEY NULL)					

INSERT #rollup
SELECT DISTINCT ProjectKey, ISNULL(ServiceKey, 0), 0, 0
FROM   tTime (NOLOCK)
WHERE  ProjectKey IN (SELECT DISTINCT ProjectKey FROM #project (NOLOCK))

UPDATE #rollup
SET    #rollup.LaborNet =
					ISNULL((
					SELECT SUM(ROUND(ActualHours * CostRate, 2)) 
					FROM  tTime (NOLOCK) 
					WHERE tTime.ProjectKey = #rollup.ProjectKey
					AND   isnull(tTime.ServiceKey, 0) = #rollup.ServiceKey
					), 0) 

UPDATE #rollup
SET    #rollup.LaborNetApproved =
					ISNULL((
					SELECT SUM(ROUND(ActualHours * CostRate, 2)) 
					FROM  tTime (NOLOCK) 
						INNER JOIN tTimeSheet (NOLOCK) ON tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
					WHERE tTime.ProjectKey = #rollup.ProjectKey
					AND   tTimeSheet.Status = 4 
					AND   isnull(tTime.ServiceKey, 0) = #rollup.ServiceKey
					), 0) 

UPDATE tProjectRollup
SET    tProjectRollup.LaborNet =
					ISNULL((SELECT SUM(#rollup.LaborNet) 
					FROM #rollup (NOLOCK) 
					WHERE #rollup.ProjectKey = tProjectRollup.ProjectKey), 0) 
WHERE tProjectRollup.ProjectKey in (SELECT DISTINCT ProjectKey  FROM #rollup)
					
UPDATE tProjectRollup
SET    tProjectRollup.LaborNetApproved =
					ISNULL((SELECT SUM(#rollup.LaborNetApproved) 
					FROM #rollup (NOLOCK) 
					WHERE #rollup.ProjectKey = tProjectRollup.ProjectKey), 0) 
WHERE tProjectRollup.ProjectKey in (SELECT DISTINCT ProjectKey FROM #rollup)

					
UPDATE tProjectItemRollup
SET    tProjectItemRollup.LaborNet = #rollup.LaborNet
      ,tProjectItemRollup.LaborNetApproved = #rollup.LaborNetApproved
FROM   #rollup
WHERE  tProjectItemRollup.ProjectKey = #rollup.ProjectKey
AND    tProjectItemRollup.EntityKey = #rollup.ServiceKey
AND    tProjectItemRollup.Entity = 'tService'


	return 1
GO
