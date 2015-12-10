USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptOfficeRestrictGetList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptOfficeRestrictGetList]

	@CompanyKey int
	,@Active int = 1 -- -1: Show everything
	,@OfficeKey int = NULL
	,@GLCompanyKey int 
    ,@UserKey int
	,@SearchMode varchar(20) = '' -- blank, reports, transactions

AS --Encrypt

/*
|| When      Who Rel     What
|| 6/19/12   GHL 10.557  cloned sptOfficeGetList for gl company security
||                       SearchMode = transactions
||                           situations where we enter a transaction like a client invoice
||                           we assume that user security was used to check access gl company key
||                           we only check tGLCompanyAccess 
||                       SearchMode = reports
||                           other situations 
||                           we check tGLCompanyAccess/tUserGLCompanyAccess
*/

	SELECT @Active = isnull(@Active, -1) -- All
	SELECT @SearchMode = isnull(@SearchMode, '')

	if @SearchMode = 'transactions' and @GLCompanyKey <= 0
		select @SearchMode = 'reports'

	if @SearchMode = 'reports' and @UserKey <= 0
		select @SearchMode = ''

	if @SearchMode = ''
		SELECT	OfficeKey, CompanyKey, OfficeName, ProjectNumPrefix, NextProjectNum, 
				ISNULL(Active, 1) AS Active, OfficeID
		FROM	tOffice (NOLOCK)
		WHERE	CompanyKey = @CompanyKey
		AND		(@Active = -1 OR ISNULL(Active, 1) = @Active OR (OfficeKey = @OfficeKey))
		ORDER BY OfficeName

	-- for this mode, GLCompanyKey is required and we do not check the user's rights
	if @SearchMode = 'transactions'
		SELECT distinct o.OfficeKey, o.CompanyKey, o.OfficeName, o.ProjectNumPrefix, o.NextProjectNum, 
				ISNULL(o.Active, 1) AS Active, o.OfficeID
		FROM tOffice o (nolock)
			inner join tGLCompanyAccess glca (nolock) on o.OfficeKey = glca.EntityKey and glca.Entity = 'tOffice'
		where o.CompanyKey = @CompanyKey 
		AND	  (@Active = -1 OR ISNULL(Active, 1) = @Active)
		and   glca.GLCompanyKey =  @GLCompanyKey
		
		union -- not union all, will remove duplicates

		SELECT o.OfficeKey, o.CompanyKey, o.OfficeName, o.ProjectNumPrefix, o.NextProjectNum, 
				ISNULL(o.Active, 1) AS Active, o.OfficeID
		FROM tOffice o (nolock)
		where o.OfficeKey = @OfficeKey 
		
		ORDER BY OfficeName
		 
	if @SearchMode = 'reports'
		SELECT distinct o.OfficeKey, o.CompanyKey, o.OfficeName, o.ProjectNumPrefix, o.NextProjectNum, 
				ISNULL(o.Active, 1) AS Active, o.OfficeID
		FROM tOffice o (nolock)
			inner join tGLCompanyAccess glca (nolock) on o.OfficeKey = glca.EntityKey and glca.Entity = 'tOffice'
			inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey
		where o.CompanyKey = @CompanyKey 
		AND	  (@Active = -1 OR ISNULL(Active, 1) = @Active)
		and   uglca.UserKey = @UserKey
		and   (@GLCompanyKey <=0 -- optional
				or
			    glca.GLCompanyKey =  @GLCompanyKey 
			  )
		
		union -- not union all, will remove duplicates

		SELECT o.OfficeKey, o.CompanyKey, o.OfficeName, o.ProjectNumPrefix, o.NextProjectNum, 
				ISNULL(o.Active, 1) AS Active, o.OfficeID
		FROM tOffice o (nolock)
		where o.OfficeKey = @OfficeKey 
		
		ORDER BY OfficeName

	RETURN 1
GO
