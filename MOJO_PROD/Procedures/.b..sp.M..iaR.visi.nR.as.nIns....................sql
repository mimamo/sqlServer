USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaRevisionReasonInsert]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaRevisionReasonInsert]
	@CompanyKey int,
	@ReasonID varchar(6),
	@Description varchar(100),
	@Active smallint,
	@oIdentity INT OUTPUT
AS  -- Encrypt

	IF @Active IS NULL
		SELECT @Active = 1

	IF EXISTS (SELECT 1
				FROM tMediaRevisionReason (NOLOCK)
				WHERE CompanyKey = @CompanyKey
				AND   ReasonID = @ReasonID)
			RETURN -1
				
	INSERT tMediaRevisionReason
		(
		CompanyKey,
		ReasonID,
		Description,
		Active
		)

	VALUES
		(
		@CompanyKey,
		@ReasonID,
		@Description,
		@Active
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
