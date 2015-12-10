USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWriteOffReasonInsert]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWriteOffReasonInsert]
	@CompanyKey int,
	@ReasonName varchar(200),
	@Description varchar(4000),
	@Active tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tWriteOffReason
		(
		CompanyKey,
		ReasonName,
		Description,
		Active
		)

	VALUES
		(
		@CompanyKey,
		@ReasonName,
		@Description,
		@Active
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
