USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptOfficeRestrictValid]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptOfficeRestrictValid]
	(
	@CompanyKey int
	,@OfficeID varchar(50)   -- can also be OfficeName
	,@SearchMode varchar(20) -- blank, reports, transactions
	,@GLCompanyKey int       -- 0 All, >0 specific GL company
	,@UserKey int 
	)
AS --Encrypt

/*
|| When      Who Rel     What
|| 6/8/12   GHL 10.556   Created to validate Office for a certain GL Company
||                       Originally needed for the imports i.e. SearchMode = transactions
||
||                       Search Mode = transactions
||                           GLCompanyKey required
||                           UserKey not required
||                       Search Mode = reports
||                           GLCompanyKey not required
||                           UserKey required
|| 6/12/12  GHL 10.557   Modified so that we return only 1 row (could have duplicates if the name is the same) 
*/
	select @OfficeID = upper(ltrim(rtrim(@OfficeID)))
	select @SearchMode = isnull(@SearchMode, '')
	select @GLCompanyKey = isnull(@GLCompanyKey, 0)

	Declare @OfficeKey int

	if @SearchMode = ''	
		SELECT @OfficeKey = OfficeKey
		FROM tOffice (nolock)
		WHERE
			CompanyKey = @CompanyKey AND
			(upper(OfficeID) = @OfficeID or upper(OfficeName) = @OfficeID) 

	if @SearchMode = 'reports'
		SELECT @OfficeKey = o.OfficeKey
		FROM tOffice o (nolock)
			inner join tGLCompanyAccess glca (nolock) on o.OfficeKey = glca.EntityKey and glca.Entity = 'tOffice'
			inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey 
		where o.CompanyKey = @CompanyKey 
		and   (upper(OfficeID) = @OfficeID or upper(OfficeName) = @OfficeID) 
		and   uglca.UserKey = @UserKey
		and   (@GLCompanyKey <=0
				or
			    glca.GLCompanyKey =  @GLCompanyKey
			  )

	-- for this mode, GLCompanyKey is required and we do not check the user's rights
	if @SearchMode = 'transactions'
		SELECT @OfficeKey = o.OfficeKey 
		FROM tOffice o (nolock)
			inner join tGLCompanyAccess glca (nolock) on o.OfficeKey = glca.EntityKey and glca.Entity = 'tOffice'
		where o.CompanyKey = @CompanyKey 
		and   (upper(OfficeID) = @OfficeID or upper(OfficeName) = @OfficeID) 
		and   glca.GLCompanyKey =  @GLCompanyKey

	select * from tOffice (nolock) where OfficeKey = @OfficeKey

	RETURN 1
GO
