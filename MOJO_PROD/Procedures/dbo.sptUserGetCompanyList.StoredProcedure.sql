USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetCompanyList]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptUserGetCompanyList]
 (
	@CompanyKey int,
	@Name varchar(100),
	@Active tinyint,
	@UserKey int = NULL,
	@GLCompanyKey int = NULL
 )
AS --Encrypt

/*
|| When     Who Rel    What
|| 04/19/07 RLB 8.42   Change drop listing from first name to last name                 
|| 5/16/07  CRG 8.4.3  (8815) Added optional Key parameter so that it will appear in list if it is not Active.
|| 08/14/12 RLB 10.559 (151612) Added optional GLCompanyKey For HMI changes
*/

IF @Name IS NULL
	SELECT	tUser.*,
			ISNULL(tUser.FirstName, '') + ' ' + ISNULL(tUser.LastName, '') AS UserName
	FROM	tUser (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	AND		((Active = @Active OR @Active IS NULL) OR (UserKey = @UserKey))
	AND     (@GLCompanyKey IS NULL OR tUser.GLCompanyKey = @GLCompanyKey)
	ORDER BY Active DESC, LastName, FirstName
ELSE
	SELECT	*
	FROM	tUser (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	AND		((Active = @Active OR @Active IS NULL) OR (UserKey = @UserKey))
	AND     (@GLCompanyKey IS NULL OR tUser.GLCompanyKey = @GLCompanyKey)
	AND		UPPER(LTRIM(RTRIM(LastName))) LIKE UPPER(LTRIM(RTRIM(@Name))) + '%' 
	ORDER BY Active DESC, LastName, FirstName
 
return 1
GO
