USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavSecurityResetToDefault]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavSecurityResetToDefault]
	@CompanyKey int,
	@ProjectKey int, -- -1 indicates all project level security should be deleted
	@Path varchar(2000)
AS

/*
|| When      Who Rel      What
|| 1/16/13   CRG 10.5.6.4 Created
*/

	SELECT @Path = UPPER(ISNULL(@Path, ''))
	
	DECLARE	@PathLen int
	SELECT	@PathLen = LEN(@Path)

	IF @ProjectKey = 0
		RETURN --If the ProjectKey is 0, then something is wrong. This protects the company level security from being deleted

	IF @ProjectKey < 0
		DELETE	tWebDavSecurity
		WHERE	CompanyKey = @CompanyKey
		AND		ProjectKey > 0
	ELSE
		DELETE	tWebDavSecurity
		WHERE	CompanyKey = @CompanyKey
		AND		ProjectKey = @ProjectKey
		AND		LEFT(UPPER(Path), @PathLen) = UPPER(ISNULL(@Path, ''))
GO
