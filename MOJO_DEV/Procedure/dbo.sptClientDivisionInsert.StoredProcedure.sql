USE [MOJo_dev]
GO

/****** Object:  StoredProcedure [dbo].[sptClientDivisionInsert]    Script Date: 04/29/2016 16:44:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


alter PROCEDURE [dbo].[sptClientDivisionInsert]
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


