USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLCompanyRestrictValid]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLCompanyRestrictValid]
	(
	@CompanyKey int
	,@GLCompanyNameOrID varchar(500)
	,@UserKey int 
	)
AS --Encrypt

/*
|| When     Who Rel     What
|| 06/18/12 GHL 10.557  Created for gl company validation during import processes 
*/
	SET NOCOUNT ON

	declare @RestrictToGLCompany tinyint

	Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tPreference p (nolock) Where CompanyKey = @CompanyKey 
	AND (SELECT ISNULL(Administrator, 0) from tUser (nolock) Where UserKey = @UserKey) = 0

	select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

	DECLARE @key int

	
if @RestrictToGLCompany = 0
begin
	SELECT @key = GLCompanyKey
	FROM tGLCompany (nolock)
	WHERE
		UPPER(GLCompanyID) = UPPER(@GLCompanyNameOrID) AND
		CompanyKey = @CompanyKey

	IF @key IS NULL
		SELECT @key = GLCompanyKey
		FROM tGLCompany (nolock)
		WHERE
			UPPER(GLCompanyName) = UPPER(@GLCompanyNameOrID) AND
			CompanyKey = @CompanyKey

end

else 

begin
	SELECT @key = gl.GLCompanyKey
	FROM tGLCompany gl (nolock)
	INNER JOIN tUserGLCompanyAccess gla (nolock) on gl.GLCompanyKey = gla.GLCompanyKey
	WHERE
		UPPER(gl.GLCompanyID) = UPPER(@GLCompanyNameOrID) AND
		gl.CompanyKey = @CompanyKey
	AND	gla.UserKey = @UserKey

	IF @key IS NULL
		SELECT @key = gl.GLCompanyKey
		FROM tGLCompany gl (nolock)
		INNER JOIN tUserGLCompanyAccess gla (nolock) on gl.GLCompanyKey = gla.GLCompanyKey
		WHERE
			UPPER(gl.GLCompanyName) = UPPER(@GLCompanyNameOrID) AND
			gl.CompanyKey = @CompanyKey
		AND	gla.UserKey = @UserKey
end

	SELECT *
	FROM tGLCompany (nolock)
	WHERE GLCompanyKey = @key

	RETURN
GO
