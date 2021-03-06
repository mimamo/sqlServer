USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptClientDivisionInsert]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptClientDivisionInsert]
	@CompanyKey int,
	@ClientKey int,
	@DivisionName varchar(300),
	@ProjectNumPrefix varchar(20),
	@NextProjectNum int,
	@Active tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tClientDivision
		(
		CompanyKey,
		ClientKey,
		DivisionName,
		ProjectNumPrefix,
		NextProjectNum,
		Active
		)

	VALUES
		(
		@CompanyKey,
		@ClientKey,
		@DivisionName,
		@ProjectNumPrefix,
		@NextProjectNum,
		@Active
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
