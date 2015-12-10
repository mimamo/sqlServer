USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetDiaryEmailList]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetDiaryEmailList]
	(
		@ProjectKey int,
		@CompanyKey int
	)
AS

/*
|| When      Who Rel      What
|| 01/09/12  MFT 10.5.5.2 Added ClientVendorLogin to result set
*/

-- using this in the mobile diary new post function

	--Next get the project team
	SELECT	v.UserKey,
			v.UserName,
			ISNULL(asn.SubscribeDiary, 0) as SubscribeD,
			ISNULL(asn.SubscribeToDo, 0) as SubscribeT,
			ISNULL(ClientVendorLogin, 0) AS ClientVendorLogin
	FROM	vUserName v (nolock) 
	INNER JOIN tAssignment asn (nolock) ON v.UserKey = asn.UserKey AND asn.ProjectKey = @ProjectKey
	ORDER BY UserName

	--Next get all employees
	SELECT	u.UserKey,
			u.FirstName + ' ' + u.LastName as UserName,
			0 as SubscribeD,
			0 as SubscribeT,
			ISNULL(ClientVendorLogin, 0) AS ClientVendorLogin
	FROM	tUser u (nolock)
	WHERE	(u.CompanyKey = @CompanyKey
	OR		(u.OwnerCompanyKey = @CompanyKey 
			AND u.ClientVendorLogin = 0 
			AND u.UserID is not null 
			AND u.Password is not null 
			AND u.Active = 1) ) AND
			u.UserKey not in (Select UserKey from tAssignment (nolock) Where ProjectKey = @ProjectKey)
	ORDER BY UserName

	--Next get client contacts (query copied from contact lookup for billing contacts)
	--IF @ProjectKey > 0
	--BEGIN
		DECLARE	@ClientKey int,
				@QueryCompanyKey int

		SELECT	@ClientKey = ClientKey
		FROM	tProject (nolock)
		WHERE	ProjectKey = @ProjectKey

		SELECT @QueryCompanyKey = ISNULL(ParentCompanyKey, CompanyKey) FROM tCompany (nolock) WHERE CompanyKey = @ClientKey

		SELECT	u.UserKey,
				u.FirstName + ' ' + u.LastName as UserName,
				0 as SubscribeD,
				0 as SubscribeT,
				ISNULL(ClientVendorLogin, 0) AS ClientVendorLogin
		FROM	tUser u (nolock)
				INNER JOIN tCompany c (nolock) on u.CompanyKey = c.CompanyKey
		WHERE	u.OwnerCompanyKey = @CompanyKey
		AND		u.Active = 1
		AND		(u.CompanyKey = @ClientKey
				OR c.ParentCompany = @QueryCompanyKey
				OR c.CompanyKey = @QueryCompanyKey)
		ORDER BY UserName
	--END
GO
