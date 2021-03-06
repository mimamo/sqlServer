USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentTypeServiceInsert]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentTypeServiceInsert]
	@TaskAssignmentTypeKey int,
	@ServiceKey int,
	@Used tinyint,
	@Notify tinyint
AS

	INSERT tTaskAssignmentTypeService
		(
		TaskAssignmentTypeKey,
		ServiceKey,
		Used,
		Notify
		)

	VALUES
		(
		@TaskAssignmentTypeKey,
		@ServiceKey,
		@Used,
		@Notify
		)

	RETURN 1
GO
