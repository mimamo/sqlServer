USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectStatusInsert]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectStatusInsert]
	@CompanyKey int,
	@ProjectStatusID varchar(30),
	@ProjectStatus varchar(200),
	@DisplayOrder int,
	@StatusCategory smallint,
	@IsActive tinyint,
	@TimeActive tinyint,
	@ExpenseActive tinyint,
	@Locked tinyint,
	@OnHold tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

	IF EXISTS(
		SELECT 1
		FROM tProjectStatus (NOLOCK) 
		WHERE 	ProjectStatusID = @ProjectStatusID AND
			CompanyKey = @CompanyKey
		)
		RETURN -1

	INSERT tProjectStatus
		(
		CompanyKey,
		ProjectStatusID,
		ProjectStatus,
		DisplayOrder,
		StatusCategory,
		IsActive,
		TimeActive,
		ExpenseActive,
		Locked,
		OnHold
		)

	VALUES
		(
		@CompanyKey,
		@ProjectStatusID,
		@ProjectStatus,
		@DisplayOrder,
		@StatusCategory,
		@IsActive,
		@TimeActive,
		@ExpenseActive,
		@Locked,
		@OnHold
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
