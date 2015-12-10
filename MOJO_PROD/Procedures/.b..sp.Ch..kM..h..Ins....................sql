USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckMethodInsert]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckMethodInsert]
	@CompanyKey int,
	@CheckMethod varchar(100),
	@Active tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tCheckMethod
		(
		CompanyKey,
		CheckMethod,
		Active
		)

	VALUES
		(
		@CompanyKey,
		@CheckMethod,
		@Active
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
