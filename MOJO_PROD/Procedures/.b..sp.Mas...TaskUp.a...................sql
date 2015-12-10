USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMasterTaskUpdate]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMasterTaskUpdate]
	@MasterTaskKey int,
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
	@SummaryMasterTaskKey int	

AS --Encrypt

	IF EXISTS(SELECT 1 FROM tMasterTask (NOLOCK) WHERE TaskID = @TaskID AND CompanyKey = @CompanyKey
				AND MasterTaskKey <> @MasterTaskKey)
		RETURN -1

	UPDATE
		tMasterTask
	SET
		CompanyKey = @CompanyKey,
		TaskID = @TaskID,
		TaskName = @TaskName,
		Description = @Description,
		HourlyRate = @HourlyRate,
		Markup = @Markup,
		IOCommission = @IOCommission,
		BCCommission = @BCCommission,
		ShowDescOnEst = @ShowDescOnEst,
		Taxable = @Taxable,
		Taxable2 = @Taxable2,
		WorkTypeKey = @WorkTypeKey,
		ScheduleTask = @ScheduleTask,
		MoneyTask = @MoneyTask,
		HideFromClient = @HideFromClient,
		Active = @Active,
		TaskType = @TaskType,
		PlanDuration = @PlanDuration,
		TrackBudget = @TrackBudget,
		AllowAnyone = @AllowAnyone,
		WorkAnyDay = @WorkAnyDay,
		PercCompSeparate = @PercCompSeparate,
		TaskAssignmentTypeKey = @TaskAssignmentTypeKey,
		Priority = @Priority,
		WorkOrder = @WorkOrder,
		SummaryMasterTaskKey = @SummaryMasterTaskKey	
	WHERE
		MasterTaskKey = @MasterTaskKey 

	RETURN 1
GO
