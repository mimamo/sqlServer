USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSkillSpecialtyUpdate]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSkillSpecialtyUpdate]
	@SkillSpecialtyKey int,
	@SkillKey int,
	@SpecialtyName varchar(300),
	@Keywords varchar(300),
	@Description varchar(1000)

AS --Encrypt

	UPDATE
		tSkillSpecialty
	SET
		SkillKey = @SkillKey,
		SpecialtyName = @SpecialtyName,
		Keywords = @Keywords,
		Description = @Description
	WHERE
		SkillSpecialtyKey = @SkillSpecialtyKey 

	RETURN 1
GO
