USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSkillValid]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSkillValid]
	@CompanyKey int,
	@SkillName varchar(500)
AS

DECLARE @SkillKey int
	
SELECT @SkillKey = SkillKey
FROM tSkill (nolock)
WHERE
	UPPER(SkillName) = UPPER(@SkillName) AND
	CompanyKey = @CompanyKey

RETURN ISNULL(@SkillKey, 0)
GO
