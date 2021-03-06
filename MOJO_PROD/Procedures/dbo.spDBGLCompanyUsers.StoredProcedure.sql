USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spDBGLCompanyUsers]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDBGLCompanyUsers]
	@UserKey int,
	@GLCompanyKey int = 0
AS

/*
|| When      Who Rel      What
|| 08/20/12  MFT 10.5.5.9 Created to support OperationCompanyCalendar widget or other user lists that must be filterd
*/

------------------------------------------------------------
--GL Company restrictions
DECLARE @CompanyKey int
DECLARE @RestrictToGLCompany tinyint
DECLARE @tGLCompanies table (GLCompanyKey int)
SELECT @CompanyKey = CompanyKey
FROM tUser WHERE UserKey = @UserKey
SELECT @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey

IF ISNULL(@GLCompanyKey, 0) > 0
	INSERT INTO @tGLCompanies VALUES(@GLCompanyKey)
ELSE
	BEGIN --No @GLCompanyKey passed in
		IF @RestrictToGLCompany = 0
			BEGIN --@RestrictToGLCompany = 0
			 	--All GLCompanyKeys + 0 to get NULLs
				INSERT INTO @tGLCompanies VALUES(0)
				INSERT INTO @tGLCompanies
					SELECT GLCompanyKey
					FROM tGLCompany (nolock)
					WHERE CompanyKey = @CompanyKey
			END --@RestrictToGLCompany = 0
		ELSE
			BEGIN --@RestrictToGLCompany = 1
				 --Only GLCompanyKeys @UserKey has access to
				INSERT INTO @tGLCompanies
					SELECT GLCompanyKey
					FROM tUserGLCompanyAccess (nolock)
					WHERE UserKey = @UserKey
			END --@RestrictToGLCompany = 1
	END --No @GLCompanyKey passed in
--GL Company restrictions
------------------------------------------------------------

SELECT
	UserKey
FROM
	tUser u (nolock)
	INNER JOIN @tGLCompanies glc ON ISNULL(u.GLCompanyKey, 0) = glc.GLCompanyKey
GO
