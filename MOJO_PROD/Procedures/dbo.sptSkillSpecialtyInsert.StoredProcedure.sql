USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSkillSpecialtyInsert]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSkillSpecialtyInsert]
	@SkillKey int,
	@SpecialtyName varchar(300),
	@Keywords varchar(300),
	@Description varchar(1000),
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tSkillSpecialty
		(
		SkillKey,
		SpecialtyName,
		Keywords,
		Description
		)

	VALUES
		(
		@SkillKey,
		@SpecialtyName,
		@Keywords,
		@Description
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
