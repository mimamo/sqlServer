USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentUpdatePlanDates]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTaskAssignmentUpdatePlanDates]

	(
		@TaskAssignmentKey int,
		@PlanStart smalldatetime,
		@PlanComplete smalldatetime,
		@Duration int,
		@PredecessorsComplete tinyint
	)

AS --Encrypt

Update tTaskAssignment
Set
	PlanStart = @PlanStart,
	PlanComplete = @PlanComplete,
	Duration = @Duration,
	PredecessorsComplete = @PredecessorsComplete
Where
	TaskAssignmentKey = @TaskAssignmentKey
GO
