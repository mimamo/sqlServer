USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskQuickUpdate]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTaskQuickUpdate]

	(
		@TaskKey int,
		@PlanDuration int,
		@PlanStart smalldatetime,
		@PlanComplete smalldatetime,
		@ActStart smalldatetime,
		@ActComplete smalldatetime,
		@PercComp int
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 10/13/06 GHL 8.4   Removed reference to assignments 
  ||                    
  */

Update tTask
Set
	PlanDuration = @PlanDuration,
	PlanStart = ISNULL(@PlanStart, PlanStart),
	PlanComplete = ISNULL(@PlanComplete, PlanComplete),
	ActStart = @ActStart,
	ActComplete = @ActComplete,
	PercComp = @PercComp
Where
	TaskKey = @TaskKey
GO
