USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStandardTextInsert]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStandardTextInsert]
	@CompanyKey int,
	@Type varchar(20),
	@TextName varchar(100),
	@StandardText text,
	@Active tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tStandardText
		(
		CompanyKey,
		Type,
		TextName,
		StandardText,
		Active
		)

	VALUES
		(
		@CompanyKey,
		@Type,
		@TextName,
		@StandardText,
		@Active
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
