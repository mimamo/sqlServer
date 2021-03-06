USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptClientProductInsert]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptClientProductInsert]
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
