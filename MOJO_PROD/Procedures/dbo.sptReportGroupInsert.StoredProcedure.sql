USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportGroupInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReportGroupInsert]
	@CompanyKey int,
	@GroupName varchar(300),
	@GroupType smallint,
	@DisplayOrder int,
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tReportGroup
		(
		CompanyKey,
		GroupName,
		GroupType,
		DisplayOrder
		)

	VALUES
		(
		@CompanyKey,
		@GroupName,
		@GroupType,
		@DisplayOrder
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
