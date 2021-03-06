USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentTypeUpdate]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentTypeUpdate]
	@TaskAssignmentTypeKey int,
	@CompanyKey int,
	@TaskAssignmentType varchar(200),
	@CalendarColor varchar(20),
	@Active tinyint

AS --Encrypt

	UPDATE
		tTaskAssignmentType
	SET
		CompanyKey = @CompanyKey,
		TaskAssignmentType = @TaskAssignmentType,
		CalendarColor = @CalendarColor,
		Active = @Active
	WHERE
		TaskAssignmentTypeKey = @TaskAssignmentTypeKey 

	RETURN 1
GO
