USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMasterTaskUpdateTasks]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMasterTaskUpdateTasks]
	(
		@MasterTaskKey int
	)
	
AS --Encrypt

/**
	we cannot realistically update the following fields, so only update those that can be done in SQL:
		TrackBudget/MoneyTask - recusrsive validation required
		Assignment Type - drives custom fields
		Percent Complete Separate - may conflict with current task settings
		
07/13/09 RLB  (53542) Only updates task descriptions when something is entered into the master task description field.	

**/

Declare @OrginalDescription varchar (4000)

Select @OrginalDescription = mt.Description from tMasterTask mt (nolock) where MasterTaskKey = @MasterTaskKey

If @OrginalDescription is null
   Update tTask
Set 
	TaskID = tMasterTask.TaskID,
	TaskName = tMasterTask.TaskName,
	HourlyRate = tMasterTask.HourlyRate,
	Markup = tMasterTask.Markup,
	IOCommission = tMasterTask.IOCommission,
	BCCommission = tMasterTask.BCCommission,
	ShowDescOnEst = tMasterTask.ShowDescOnEst,
	Taxable = tMasterTask.Taxable,
	Taxable2 = tMasterTask.Taxable2,
	WorkTypeKey = tMasterTask.WorkTypeKey,
	ScheduleTask = tMasterTask.ScheduleTask,
	HideFromClient = tMasterTask.HideFromClient,
	AllowAnyone = tMasterTask.AllowAnyone,
	Priority = tMasterTask.Priority,
	PlanDuration = tMasterTask.PlanDuration,
	WorkAnyDay = tMasterTask.WorkAnyDay
 
From tMasterTask (nolock)
Where
	tMasterTask.MasterTaskKey = tTask.MasterTaskKey and
	tTask.MasterTaskKey = @MasterTaskKey
 
else

   Update tTask
Set 
	TaskID = tMasterTask.TaskID,
	TaskName = tMasterTask.TaskName,
	Description = tMasterTask.Description,
	HourlyRate = tMasterTask.HourlyRate,
	Markup = tMasterTask.Markup,
	IOCommission = tMasterTask.IOCommission,
	BCCommission = tMasterTask.BCCommission,
	ShowDescOnEst = tMasterTask.ShowDescOnEst,
	Taxable = tMasterTask.Taxable,
	Taxable2 = tMasterTask.Taxable2,
	WorkTypeKey = tMasterTask.WorkTypeKey,
	ScheduleTask = tMasterTask.ScheduleTask,
	HideFromClient = tMasterTask.HideFromClient,
	AllowAnyone = tMasterTask.AllowAnyone,
	Priority = tMasterTask.Priority,
	PlanDuration = tMasterTask.PlanDuration,
	WorkAnyDay = tMasterTask.WorkAnyDay
 
From tMasterTask (nolock)
Where
	tMasterTask.MasterTaskKey = tTask.MasterTaskKey and
	tTask.MasterTaskKey = @MasterTaskKey
GO
