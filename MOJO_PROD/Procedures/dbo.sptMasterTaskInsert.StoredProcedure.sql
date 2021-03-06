USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMasterTaskInsert]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMasterTaskInsert]
	@CompanyKey int,
	@TaskID varchar(30),
	@TaskName varchar(300),
	@Description varchar(4000),
	@HourlyRate money,
	@Markup decimal(13),
	@IOCommission decimal(13),
	@BCCommission decimal(13),
	@ShowDescOnEst tinyint,
	@Taxable tinyint,
	@Taxable2 tinyint,
	@WorkTypeKey int,
	@ScheduleTask tinyint,
	@MoneyTask tinyint,
	@HideFromClient tinyint,
	@Active tinyint,
	@TaskType smallint,
	@PlanDuration int,
	@TrackBudget tinyint,
	@AllowAnyone tinyint,
	@WorkAnyDay tinyint,
	@PercCompSeparate tinyint,
	@TaskAssignmentTypeKey int,
	@Priority smallint,
	@WorkOrder int,
	@SummaryMasterTaskKey int,
	@oIdentity INT OUTPUT
	
AS --Encrypt

	if @TaskType = 1
		IF EXISTS(SELECT 1 FROM tMasterTask (NOLOCK) WHERE TaskID = @TaskID AND CompanyKey = @CompanyKey)
			RETURN -1
	else
		IF EXISTS(SELECT 1 FROM tMasterTask (NOLOCK) WHERE TaskID = @TaskID AND SummaryMasterTaskKey = @SummaryMasterTaskKey and CompanyKey = @CompanyKey)
			RETURN -1	

	INSERT tMasterTask
		(
		CompanyKey,
		TaskID,
		TaskName,
		Description,
		HourlyRate,
		Markup,
		IOCommission,
		BCCommission,
		ShowDescOnEst,
		Taxable,
		Taxable2,
		WorkTypeKey,
		ScheduleTask,
		MoneyTask,
		HideFromClient,
		Active,
		TaskType,
		PlanDuration,
		TrackBudget,
		AllowAnyone,
		WorkAnyDay,
		PercCompSeparate,
		TaskAssignmentTypeKey,
		Priority,
		WorkOrder,
		SummaryMasterTaskKey
		)

	VALUES
		(
		@CompanyKey,
		@TaskID,
		@TaskName,
		@Description,
		@HourlyRate,
		@Markup,
		@IOCommission,
		@BCCommission,
		@ShowDescOnEst,
		@Taxable,
		@Taxable2,
		@WorkTypeKey,
		@ScheduleTask,
		@MoneyTask,
		@HideFromClient,
		@Active,
		@TaskType,
		@PlanDuration,
		@TrackBudget,
		@AllowAnyone,
		@WorkAnyDay,
		@PercCompSeparate,
		@TaskAssignmentTypeKey,
		@Priority,
		@WorkOrder,
		@SummaryMasterTaskKey		
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
