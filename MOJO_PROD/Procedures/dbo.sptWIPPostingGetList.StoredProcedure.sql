USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWIPPostingGetList]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWIPPostingGetList]

	@CompanyKey int
	,@GLCompanyKey int -- -1 All, 0 Blank, >0 valid gl company
	,@UserKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 09/18/07 GHL 8.5     Added GLCompanyName 
|| 12/12/07 GHL 8.5     Added second order by in case the posting dates are the same 
|| 05/13/08 GHL 8.510   Added a flag AllowUnpost so that we can only unpost the last wip batch
|| 08/23/12 GHL 10.559  Added filter by gl company and security
*/


	DECLARE @RestrictToGLCompany INT
	SELECT @RestrictToGLCompany = isnull(RestrictToGLCompany, 0)
	FROM   tPreference (NOLOCK)
	WHERE  CompanyKey = @CompanyKey

	DECLARE @MaxWIPPostingKey INT

	SELECT @MaxWIPPostingKey = MAX(WIPPostingKey)
	FROM   tWIPPosting (nolock)
	WHERE  CompanyKey = @CompanyKey
	AND  ( (@GLCompanyKey = -1 -- All
			AND
				(
				@RestrictToGLCompany = 0 
					OR 
				isnull(GLCompanyKey, 0) in (select GLCompanyKey from tUserGLCompanyAccess (nolock) where UserKey = @UserKey)
				)
			)
		    OR
			isnull(GLCompanyKey, 0) = @GLCompanyKey
			)


	SELECT @MaxWIPPostingKey = ISNULL(@MaxWIPPostingKey, 0)
	
	
	SELECT wpd.*
			,glc.GLCompanyName
			,CASE WHEN wpd.WIPPostingKey = @MaxWIPPostingKey THEN 1 ELSE 0 END AS AllowUnpost
	FROM tWIPPosting wpd (NOLOCK)
		LEFT OUTER JOIN tGLCompany glc (NOLOCK) ON wpd.GLCompanyKey = glc.GLCompanyKey
	WHERE wpd.CompanyKey = @CompanyKey
	AND  ( (@GLCompanyKey = -1 -- All
			AND
				(
				@RestrictToGLCompany = 0 
					OR 
				isnull(wpd.GLCompanyKey, 0) in (select GLCompanyKey from tUserGLCompanyAccess (nolock) where UserKey = @UserKey)
				)
			)
		    OR
			isnull(wpd.GLCompanyKey, 0) = @GLCompanyKey
			)
			
	
		Order By wpd.PostingDate DESC, wpd.WIPPostingKey DESC

	RETURN 1
GO
