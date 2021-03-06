USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetMoneyList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskGetMoneyList]
	(
		@ProjectKey int
	)
AS --Encrypt

/*
|| When     Who Rel   What
|| 12/14/06 GHL 8.4  Using now BudgetTaskType
*/

/*
On Budget screens, we cannot rely on TaskType = 1 to display bold on grids 
But rely on BudgetTaskType = 1

TaskType | TrackBudget | BudgetTaskType | Grid appearance
--------------------------------------------------------
1 Summary        0             1         Bold
1 Summary        1             2         Not Bold, like tracking       
2 Tracking       1             2         Not Bold, tracking
2 Tracking       0             2         NOT SHOWN MoneyTask = 0

All tasks below a TrackBudget task have MoneyTask = 0 so they will not be shown 
If a summary task tracks budget, it becomes in effect a tracking task
 
*/

Select tTask.* 
      ,case
		when TaskType=1 and isnull(TrackBudget,0)=0 then 1
		else 0
	   end as NonTrackSummary
      ,case when TaskType = 1 and isnull(TrackBudget,0) = 0 then 1
	   else 2 end as BudgetTaskType
from tTask (nolock) 
Where ProjectKey = @ProjectKey and MoneyTask = 1
Order By ProjectOrder
GO
