USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentTypeInsert]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentTypeInsert]
	@CompanyKey int,
	@TaskAssignmentType varchar(200),
	@CalendarColor varchar(20),
	@Active tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tTaskAssignmentType
		(
		CompanyKey,
		TaskAssignmentType,
		CalendarColor,
		Active
		)

	VALUES
		(
		@CompanyKey,
		@TaskAssignmentType,
		@CalendarColor,
		@Active
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
