USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetToDoDetail]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetToDoDetail]
	@ActivityKey int
AS

/*
|| When      Who Rel      What
|| 12/10/10  CRG 10.5.3.9 Created for the To Do screen
|| 9/2/11    CRG 10.5.4.7 (120081) Added non employee project team members to the query to get employees and team members
*/

	--Get Attachments
	SELECT	*
	FROM	tAttachment (nolock)
	WHERE	AssociatedEntity = 'tActivity' 
	AND		EntityKey = @ActivityKey
	ORDER BY FileName

	--First get everyone currently on the email list
	SELECT	ae.*, v.UserName --Get the user name in case they have been removed from any of the following lists (we'll then list them under the "Other" group).
	FROM	tActivityEmail ae (nolock)
	INNER JOIN vUserName v (nolock) ON ae.UserKey = v.UserKey
	WHERE	ActivityKey = @ActivityKey

	DECLARE	@CompanyKey int,
			@ProjectKey int
			
	SELECT	@CompanyKey = CompanyKey,
			@ProjectKey = ProjectKey
	FROM	tActivity (nolock)
	WHERE	ActivityKey = @ActivityKey

	--Next get all employees, and other team members
	SELECT	u.UserKey,
			v.UserName,
			CASE
				WHEN asn.AssignmentKey IS NOT NULL THEN 1
				ELSE 0
			END AS Assigned
	FROM	tUser u (nolock)
	INNER JOIN vUserName v (nolock) ON u.UserKey = v.UserKey
	LEFT JOIN tAssignment asn (nolock) ON u.UserKey = asn.UserKey AND asn.ProjectKey = @ProjectKey
	WHERE	u.CompanyKey = @CompanyKey
	OR		(u.OwnerCompanyKey = @CompanyKey 
			AND u.ClientVendorLogin = 0 
			AND u.UserID is not null 
			AND u.Password is not null 
			AND u.Active = 1)
	OR		asn.ProjectKey = @ProjectKey
	ORDER BY UserName

	--Next get client contacts (query copied from contact lookup for billing contacts)
	IF @ProjectKey > 0
	BEGIN
		DECLARE	@ClientKey int,
				@QueryCompanyKey int

		SELECT	@ClientKey = ClientKey
		FROM	tProject (nolock)
		WHERE	ProjectKey = @ProjectKey

		SELECT @QueryCompanyKey = ISNULL(ParentCompanyKey, CompanyKey) FROM tCompany (nolock) WHERE CompanyKey = @ClientKey

		SELECT	v.*
		FROM	vUserName v (nolock)
		INNER JOIN tCompany c (nolock) ON v.CompanyKey = c.CompanyKey
		WHERE	v.OwnerCompanyKey = @CompanyKey
		AND		v.Active = 1
		AND		(v.CompanyKey = @ClientKey
				OR c.ParentCompany = @QueryCompanyKey
				OR c.CompanyKey = @QueryCompanyKey)
		ORDER BY UserName
	END
GO
