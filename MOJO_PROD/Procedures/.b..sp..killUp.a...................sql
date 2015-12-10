USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSkillUpdate]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSkillUpdate]
	@SkillKey int,
	@CompanyKey int,
	@SkillName varchar(300),
	@Keywords varchar(300),
	@Description varchar(1000)

AS --Encrypt

	UPDATE
		tSkill
	SET
		CompanyKey = @CompanyKey,
		SkillName = @SkillName,
		Keywords = @Keywords,
		Description = @Description
	WHERE
		SkillKey = @SkillKey 

	RETURN 1
GO
