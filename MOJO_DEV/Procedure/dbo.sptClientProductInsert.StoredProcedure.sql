USE [MOJo_dev]
GO

/****** Object:  StoredProcedure [dbo].[sptClientProductInsert]    Script Date: 04/29/2016 16:46:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


alter PROCEDURE [dbo].[sptClientProductInsert]
	@CompanyKey int,
	@ClientKey int,
	@ProductName varchar(300),
	@ClientDivisionKey int,
	@Active tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tClientProduct
		(
		CompanyKey,
		ClientKey,
		ProductName,
		ClientDivisionKey,
		Active
		)

	VALUES
		(
		@CompanyKey,
		@ClientKey,
		@ProductName,
		@ClientDivisionKey,
		@Active
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
	


GO


