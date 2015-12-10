USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportProjectStatus]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportProjectStatus]
	@CompanyKey int,
	@ProjectStatusID varchar(30),
	@ProjectStatus varchar(200),
	@DisplayOrder int,
	@StatusCategory smallint,
	@IsActive tinyint
AS --Encrypt

	IF EXISTS(
		SELECT 1
		FROM tProjectStatus (nolock)
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
		IsActive
		)

	VALUES
		(
		@CompanyKey,
		@ProjectStatusID,
		@ProjectStatus,
		@DisplayOrder,
		@StatusCategory,
		@IsActive
		)
	
	RETURN 1
GO
