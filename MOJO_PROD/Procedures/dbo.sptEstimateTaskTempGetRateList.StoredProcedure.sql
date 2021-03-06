USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskTempGetRateList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskTempGetRateList]
	(
		 @Entity varchar(50)
		,@EntityKey int 
		,@ProjectKey int -- not required, in case we cannot find records for @Entity/@EntityKey
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 04/8/10   GHL 10.5.2.1 Clone of sptTaskGetRateList for the item rate manager and opportunities
*/

	If (select count(*) from tEstimateTaskTemp (nolock) where EntityKey = @EntityKey 
	and   Entity = @Entity) > 0
	
	Select 
		TaskKey,
		TaskID,   -- rolled back ltrim(rtrim(TaskID)) as TaskID,
		TrackBudget,
		ScheduleTask,
		TaskName,
		HourlyRate,
		Markup,
		IOCommission,
		BCCommission

	from tEstimateTaskTemp (nolock) 
	Where EntityKey = @EntityKey 
	and   Entity = @Entity
	and TrackBudget = 1
	Order By ProjectOrder

	Else
	
	Select 
		TaskKey,
		TaskID,   -- rolled back ltrim(rtrim(TaskID)) as TaskID,
		TrackBudget,
		ScheduleTask,
		TaskName,
		HourlyRate,
		Markup,
		IOCommission,
		BCCommission

	from tTask (nolock) 
	Where ProjectKey = @ProjectKey 
	and TrackBudget = 1
	Order By ProjectOrder
GO
