USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLCompanyGetList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLCompanyGetList]

	@CompanyKey int
	,@UserKey int
	,@Active int = 1 -- -1: Show everything
	,@GLCompanyKey int = NULL


AS --Encrypt

/*
|| When      Who Rel     What
|| 6/25/07   GHL 8.5   Added optional Key parameter so that it will appear in list if it is not Active.
|| 6/23/08   CRG 8.5.1.4 Added ability to pass -1 for Active in order to get all values regardless of whether they were active or not.
|| 06/12/12  MFG 10557  Bypassed GL Company access restriction when user is administrator
*/


	declare @RestrictToGLCompany tinyint

	Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tPreference p (nolock) Where CompanyKey = @CompanyKey AND (SELECT ISNULL(Administrator, 0) from tUser (nolock) Where UserKey = @UserKey) = 0


	if ISNULL(@RestrictToGLCompany, 0) = 0
		SELECT *
		FROM tGLCompany (nolock)
		WHERE
		CompanyKey = @CompanyKey
		AND		((@Active = -1) OR (ISNULL(Active, 1) = @Active) OR (GLCompanyKey = @GLCompanyKey))
		Order By Active DESC, GLCompanyName

	else
		SELECT gl.*
		FROM tGLCompany gl (nolock)
		INNER JOIN tUserGLCompanyAccess gla (nolock) on gl.GLCompanyKey = gla.GLCompanyKey
		WHERE	gl.CompanyKey = @CompanyKey
		AND		gla.UserKey = @UserKey
		AND		((@Active = -1) OR (ISNULL(Active, 1) = @Active) OR (gl.GLCompanyKey = @GLCompanyKey))
		Order By Active DESC, GLCompanyName

	RETURN 1
GO
