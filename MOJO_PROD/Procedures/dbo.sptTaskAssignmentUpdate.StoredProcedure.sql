USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentUpdate]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentUpdate]
	@TaskAssignmentKey int,
	@TaskKey int,
	@UserKey int,
	@AssignmentPercent int,
	@Title varchar(500),
	@DueBy varchar(200),
	@WorkDescription varchar(4000),
	@MustStartOn smalldatetime,
	@ActStart smalldatetime,
	@ActComplete smalldatetime,
	@PercComp int,
	@Priority smallint,
	@WorkOrder int,
	@Duration int,
	@Comments varchar(4000),
	@TaskAssignmentTypeKey int,
	@HideFromClient tinyint,
	@ReviewedByTraffic tinyint,
	@ReviewedByKey int


AS --Encrypt

Declare @ReviewedByDate smalldatetime, @OldReview tinyint

	Select @OldReview = ISNULL(ReviewedByTraffic, 0) from tTaskAssignment (NOLOCK) WHERE TaskAssignmentKey = @TaskAssignmentKey

	if @OldReview <> @ReviewedByTraffic
	BEGIN
		if @ReviewedByTraffic = 1
			Select @ReviewedByDate = GETUTCDATE()
		else
			Select @ReviewedByKey = NULL
			
		UPDATE
			tTaskAssignment
		SET
			TaskKey = @TaskKey,
			UserKey = @UserKey,
			AssignmentPercent = @AssignmentPercent,
			Title = @Title,
			DueBy = @DueBy,
			WorkDescription = @WorkDescription,
			MustStartOn = @MustStartOn,
			PlanStart = ISNULL(@ActStart, PlanStart),
			PlanComplete = ISNULL(@ActComplete, PlanComplete),
			ActStart = @ActStart,
			ActComplete = @ActComplete,
			PercComp = @PercComp,
			Priority = @Priority,
			WorkOrder = @WorkOrder,
			Duration = @Duration,
			Comments = @Comments,
			TaskAssignmentTypeKey = @TaskAssignmentTypeKey,
			HideFromClient = @HideFromClient,
			ReviewedByTraffic = @ReviewedByTraffic,
			ReviewedByDate = @ReviewedByDate,
			ReviewedByKey = @ReviewedByKey
		WHERE
			TaskAssignmentKey = @TaskAssignmentKey 
	END
	ELSE
	BEGIN
		UPDATE
			tTaskAssignment
		SET
			TaskKey = @TaskKey,
			UserKey = @UserKey,
			AssignmentPercent = @AssignmentPercent,
			Title = @Title,
			DueBy = @DueBy,
			WorkDescription = @WorkDescription,
			MustStartOn = @MustStartOn,
			PlanStart = ISNULL(@ActStart, PlanStart),
			PlanComplete = ISNULL(@ActComplete, PlanComplete),
			ActStart = @ActStart,
			ActComplete = @ActComplete,
			PercComp = @PercComp,
			Priority = @Priority,
			WorkOrder = @WorkOrder,
			Duration = @Duration,
			Comments = @Comments,
			TaskAssignmentTypeKey = @TaskAssignmentTypeKey,
			HideFromClient = @HideFromClient 
		WHERE
			TaskAssignmentKey = @TaskAssignmentKey 
	
	END
	

		

		
	exec sptTaskUpdatePercComp @TaskKey

	RETURN 1
GO
