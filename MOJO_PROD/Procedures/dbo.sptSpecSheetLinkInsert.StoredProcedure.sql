USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSpecSheetLinkInsert]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSpecSheetLinkInsert]
	@SpecSheetKey int,
	@Entity varchar(50),
	@EntityKey int,
	@CompanyKey int,
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tSpecSheetLink
		(
		SpecSheetKey,
		Entity,
		EntityKey,
		CompanyKey
		)

	VALUES
		(
		@SpecSheetKey,
		@Entity,
		@EntityKey,
		@CompanyKey
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
