USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMasterTaskAssignmentUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMasterTaskAssignmentUpdate]
	@MasterTaskAssignmentKey int,
	@MasterTaskKey int,
	@TaskAssignmentTypeKey int,
	@Priority smallint,
	@WorkOrder int,
	@Title varchar(500),
	@WorkDescription varchar(4000),
	@Duration int

AS --Encrypt

	UPDATE
		tMasterTaskAssignment
	SET
		MasterTaskKey = @MasterTaskKey,
		TaskAssignmentTypeKey = @TaskAssignmentTypeKey,
		Priority = @Priority,
		WorkOrder = @WorkOrder,
		Title = @Title,
		WorkDescription = @WorkDescription,
		Duration = @Duration
	WHERE
		MasterTaskAssignmentKey = @MasterTaskAssignmentKey 

	RETURN 1
GO
