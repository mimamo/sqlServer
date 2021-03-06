USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavSecurityDeletePath]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavSecurityDeletePath]
	@CompanyKey int,
	@ProjectKey int = null,
	@ProjectNumber varchar(50) = null, --Either ProjectKey or ProjectNumber must be passed in
	@Path varchar(2000)
AS

/*
|| When      Who Rel      What
|| 8/30/11   CRG 10.5.4.7 Created
|| 10/9/12   CRG 10.5.6.1 Now calling sptWebDavGetProjectFromNumber
|| 1/2/13    CRG 10.5.6.3 (162465) Fixed bug where if a project is not found, it was deleting the company wide security
*/

	IF @ProjectKey IS NULL
		EXEC @ProjectKey = sptWebDavGetProjectFromNumber @CompanyKey, @ProjectNumber

	IF ISNULL(@ProjectKey, 0) = 0
		RETURN

	--Remove the / from the end of the path
	SELECT	@Path = ISNULL(@Path, '')
	IF CHARINDEX('/', @Path, LEN(@Path)) > 0
		SELECT @Path = SUBSTRING(@Path, 0, LEN(@Path) - 1)

	DELETE	tWebDavSecurity
	WHERE	CompanyKey = @CompanyKey
	AND		ProjectKey = @ProjectKey
	AND		UPPER(LEFT(Path, LEN(@Path))) = UPPER(@Path)
GO
