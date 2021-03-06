USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentGridUpdate]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentGridUpdate]
	@TaskAssignmentKey int,
	@MustStartOn smalldatetime,
	@ActStart smalldatetime,
	@ActComplete smalldatetime,
	@PercComp int,
	@WorkOrder int,
	@Duration int

AS --Encrypt

	UPDATE
		tTaskAssignment
	SET
		MustStartOn = @MustStartOn,
		PlanStart = ISNULL(@ActStart, PlanStart),
		PlanComplete = ISNULL(@ActComplete, PlanComplete),
		ActStart = @ActStart,
		ActComplete = @ActComplete,
		PercComp = @PercComp,
		WorkOrder = @WorkOrder,
		Duration = @Duration
	WHERE
		TaskAssignmentKey = @TaskAssignmentKey 

	RETURN 1
GO
