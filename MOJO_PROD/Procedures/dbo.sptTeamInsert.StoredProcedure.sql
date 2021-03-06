USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTeamInsert]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTeamInsert]
	@CompanyKey int,
	@TeamName varchar(200),
	@Active tinyint,
	@oIdentity INT OUTPUT
AS

	IF @Active IS NULL
		SELECT @Active = 1

	INSERT tTeam
		(
		CompanyKey,
		TeamName,
		Active
		)

	VALUES
		(
		@CompanyKey,
		@TeamName,
		@Active
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
