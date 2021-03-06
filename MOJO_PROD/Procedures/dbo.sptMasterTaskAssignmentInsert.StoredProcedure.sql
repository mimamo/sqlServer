USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMasterTaskAssignmentInsert]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMasterTaskAssignmentInsert]
	@MasterTaskKey int,
	@TaskAssignmentTypeKey int,
	@Priority smallint,
	@WorkOrder int,
	@Title varchar(500),
	@WorkDescription varchar(4000),
	@Duration int,
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tMasterTaskAssignment
		(
		MasterTaskKey,
		TaskAssignmentTypeKey,
		Priority,
		WorkOrder,
		Title,
		WorkDescription,
		Duration
		)

	VALUES
		(
		@MasterTaskKey,
		@TaskAssignmentTypeKey,
		@Priority,
		@WorkOrder,
		@Title,
		@WorkDescription,
		@Duration
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
