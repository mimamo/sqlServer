USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetDiaryClient]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetDiaryClient]
	@ProjectKey int	
AS

/*
|| When      Who Rel      What
|| 01/30/14  QMD 10.5.7.6 Created for the new app
*/

	--Next get client contacts (query copied from contact lookup for billing contacts)
	-- Should not be in the team

	DECLARE	@ClientKey int,
			@QueryCompanyKey int,
			@CompanyKey int

	SELECT	@CompanyKey = CompanyKey, @ClientKey = ClientKey
	FROM	tProject (nolock)
	WHERE	ProjectKey = @ProjectKey

	SELECT @QueryCompanyKey = ISNULL(ParentCompanyKey, CompanyKey) FROM tCompany (nolock) WHERE CompanyKey = @ClientKey
		
	SELECT	u.UserKey,
		    v.UserName,
				ISNULL(v.ClientVendorLogin, 0) AS ClientVendorLogin,
				v.Email
	FROM	tUser u (nolock)
	INNER JOIN vUserName v (nolock) ON u.UserKey = v.UserKey
	INNER JOIN tCompany c (nolock) ON v.CompanyKey = c.CompanyKey
	--LEFT JOIN tAssignment asn (nolock) ON v.UserKey = asn.UserKey AND asn.ProjectKey = @ProjectKey
	WHERE	v.OwnerCompanyKey = @CompanyKey
	AND		v.Active = 1
	AND		(v.CompanyKey = @ClientKey
			OR c.ParentCompany = @QueryCompanyKey
			OR c.CompanyKey = @QueryCompanyKey)
	AND u.UserKey not in (select a.UserKey from tAssignment a (nolock)
		                    where a.ProjectKey = @ProjectKey)
	
	ORDER BY v.UserName
GO
