USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavGetProjectFromNumber]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavGetProjectFromNumber]
	@CompanyKey int,
	@ProjectNumber varchar(50)
AS

/*
|| When      Who Rel      What
|| 10/9/12   CRG 10.5.6.1 Created
*/

	DECLARE	@ProjectKey int

	SELECT	@ProjectKey = ProjectKey
	FROM	tProject (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		UPPER(LTRIM(RTRIM(WebDavProjectNumber))) = UPPER(LTRIM(RTRIM(@ProjectNumber)))

	IF @ProjectKey IS NULL
	BEGIN
		SELECT	@ProjectKey = ProjectKey
		FROM	tProject (nolock)
		WHERE	CompanyKey = @CompanyKey
		AND		UPPER(LTRIM(RTRIM(ProjectNumber))) = UPPER(LTRIM(RTRIM(@ProjectNumber)))
	END

	RETURN @ProjectKey
GO
