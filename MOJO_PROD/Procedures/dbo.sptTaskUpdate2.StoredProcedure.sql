USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUpdate2]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUpdate2]
	@TaskKey int,
	@TaskName varchar(300),
	@PlanStart smalldatetime,
	@PlanComplete smalldatetime,
	@PlanDuration int,
	@TaskConstraint smallint,
	@ConstraintDate smalldatetime,
	@Priority smallint,
	@PercCompSeparate tinyint,
	@ActStart smalldatetime,
	@ActComplete smalldatetime,
	@PercComp int,
	@Comments varchar(1000),
	@Description text
AS

	UPDATE
		tTask
	SET
		TaskName = @TaskName,
		PlanStart = @PlanStart,
		PlanComplete = @PlanComplete,
		PlanDuration = @PlanDuration,
		TaskConstraint = @TaskConstraint,
		ConstraintDate = @ConstraintDate,
		Priority = @Priority,
		PercCompSeparate = @PercCompSeparate,
		ActStart = @ActStart,
		ActComplete = @ActComplete,
		PercComp = @PercComp,
		Comments = @Comments,
		Description = @Description
	      	  	
	WHERE
		TaskKey = @TaskKey 

	if @PlanDuration > 1 
		Update tTask Set EventStart = NULL, EventEnd = NULL, ShowOnCalendar = 0 Where TaskKey = @TaskKey
GO
