USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetDiaryEmployees]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetDiaryEmployees]
	@ProjectKey int	
AS

/*
|| When      Who Rel      What
|| 01/30/14  QMD 10.5.7.6 Created for the new app
*/

	DECLARE	@CompanyKey int
			
	SELECT	@CompanyKey = CompanyKey
	FROM	tProject (nolock)
	WHERE	ProjectKey = @ProjectKey

	--Next get all employees not in the project team
	SELECT	u.UserKey,
			v.UserName,
			ISNULL(v.ClientVendorLogin, 0) AS ClientVendorLogin,
			v.Email
	FROM	tUser u (nolock)
	INNER JOIN vUserName v (nolock) ON u.UserKey = v.UserKey
	--LEFT JOIN tAssignment asn (nolock) ON u.UserKey = asn.UserKey AND asn.ProjectKey = @ProjectKey
	WHERE	(
		u.CompanyKey = @CompanyKey
		OR		(u.OwnerCompanyKey = @CompanyKey 
				AND u.ClientVendorLogin = 0 
				AND u.UserID is not null 
				AND u.Password is not null 
				AND u.Active = 1)
		)
	AND u.UserKey not in (select a.UserKey from tAssignment a (nolock)
		                     where a.ProjectKey = @ProjectKey)
	AND v.Active = 1
	ORDER BY v.UserName
GO
