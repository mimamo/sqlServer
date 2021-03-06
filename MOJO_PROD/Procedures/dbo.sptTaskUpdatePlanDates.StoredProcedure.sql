USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUpdatePlanDates]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTaskUpdatePlanDates]

	(
		@TaskKey int,
		@PlanStart smalldatetime,
		@PlanComplete smalldatetime,
		@PlanDuration int,
		@TaskStatus smallint,
		@ScheduleNote varchar(200)
	)

AS --Encrypt

Update tTask
Set
	PlanStart = @PlanStart,
	PlanComplete = @PlanComplete,
	PlanDuration = @PlanDuration,
	TaskStatus = @TaskStatus,
	ScheduleNote = @ScheduleNote
Where
	TaskKey = @TaskKey
GO
