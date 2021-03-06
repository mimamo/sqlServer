USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentInsert]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentInsert]
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
	@ReviewedByKey int,
	@oIdentity INT OUTPUT
AS --Encrypt

Declare @ReviewedByDate smalldatetime

	if @ReviewedByTraffic = 1
		Select @ReviewedByDate = GETUTCDATE()
	else
		Select @ReviewedByKey = NULL
		
	INSERT tTaskAssignment
		(
		TaskKey,
		UserKey,
		AssignmentPercent,
		Title,
		DueBy,
		WorkDescription,
		MustStartOn,
		PlanStart,
		PlanComplete,
		ActStart,
		ActComplete,
		PercComp,
		Priority,
		WorkOrder,
		Duration,
		Comments,
		TaskAssignmentTypeKey,
		HideFromClient,
		ReviewedByTraffic,
		ReviewedByDate,
		ReviewedByKey
		)

	VALUES
		(
		@TaskKey,
		@UserKey,
		@AssignmentPercent,
		@Title,
		@DueBy,
		@WorkDescription,
		@MustStartOn,
		@ActStart,
		@ActComplete,
		@ActStart,
		@ActComplete,
		@PercComp,
		@Priority,
		@WorkOrder,
		@Duration,
		@Comments,
		@TaskAssignmentTypeKey,
		@HideFromClient,
		@ReviewedByTraffic,
		@ReviewedByDate,
		@ReviewedByKey
		)
	
	SELECT @oIdentity = @@IDENTITY
	
	exec sptTaskUpdatePercComp @TaskKey
		
	RETURN 1
GO
