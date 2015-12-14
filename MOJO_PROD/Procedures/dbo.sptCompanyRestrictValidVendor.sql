USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyRestrictValidVendor]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyRestrictValidVendor]
	(
	@CompanyKey int
	,@VendorID varchar(50)   -- can also be CompanyName
	,@SearchMode varchar(20) -- blank, reports, transactions
	,@GLCompanyKey int       -- 0 All, >0 specific GL company
	,@UserKey int 
	,@ActiveOnly int 
	)
AS --Encrypt

/*
|| When      Who Rel     What
|| 6/15/12   GHL 10.557   Created to validate Vendor for a certain GL Company
||                       Originally needed for the imports i.e. SearchMode = transactions
||
||                       Search Mode = transactions
||                           GLCompanyKey required
||                           UserKey not required
||                       Search Mode = reports
||                           GLCompanyKey not required
||                           UserKey required
*/
	select @VendorID = upper(ltrim(rtrim(@VendorID)))
	select @SearchMode = isnull(@SearchMode, '')
	select @GLCompanyKey = isnull(@GLCompanyKey, 0)
	select @ActiveOnly = isnull(@ActiveOnly, 0)

	Declare @SearchCompanyKey int

	if @SearchMode = ''	
	begin
		SELECT @SearchCompanyKey = CompanyKey
		FROM tCompany (nolock)
		WHERE
			OwnerCompanyKey = @CompanyKey AND
			upper(VendorID) = @VendorID  AND
			Vendor = 1 AND
			(@ActiveOnly = 0 OR Active = 1)

		IF @SearchCompanyKey is null
		SELECT @SearchCompanyKey = CompanyKey
		FROM tCompany (nolock)
		WHERE
			OwnerCompanyKey = @CompanyKey AND
			upper(CompanyName) = @VendorID AND
			Vendor = 1 AND
			(@ActiveOnly = 0 OR Active = 1)

	end

	if @SearchMode = 'reports'
	begin
		SELECT @SearchCompanyKey = c.CompanyKey
		FROM tCompany c (nolock)
			inner join tGLCompanyAccess glca (nolock) on c.CompanyKey = glca.EntityKey and glca.Entity = 'tCompany'
			inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey 
		where c.OwnerCompanyKey = @CompanyKey 
		and   upper(VendorID) = @VendorID  
		and   c.Vendor = 1
		and   uglca.UserKey = @UserKey
		and   (@GLCompanyKey <=0
				or
			    glca.GLCompanyKey =  @GLCompanyKey
			  )
		and (@ActiveOnly = 0 OR Active = 1)

		IF @SearchCompanyKey is null
		SELECT @SearchCompanyKey = c.CompanyKey
		FROM tCompany c (nolock)
			inner join tGLCompanyAccess glca (nolock) on c.CompanyKey = glca.EntityKey and glca.Entity = 'tCompany'
			inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey 
		where c.OwnerCompanyKey = @CompanyKey 
		and   upper(CompanyName) = @VendorID 
		and   uglca.UserKey = @UserKey
		and   c.Vendor = 1
		and   (@GLCompanyKey <=0
				or
			    glca.GLCompanyKey =  @GLCompanyKey
			  )
		and (@ActiveOnly = 0 OR Active = 1)
	end

	-- for this mode, GLCompanyKey is required and we do not check the user's rights
	if @SearchMode = 'transactions'
	begin
		SELECT @SearchCompanyKey = c.CompanyKey 
		FROM tCompany c (nolock)
			inner join tGLCompanyAccess glca (nolock) on c.CompanyKey = glca.EntityKey and glca.Entity = 'tCompany'
		where c.OwnerCompanyKey = @CompanyKey 
		and   upper(VendorID) = @VendorID 
		and   glca.GLCompanyKey =  @GLCompanyKey
		and   c.Vendor = 1
		and   (@ActiveOnly = 0 OR Active = 1)

		IF @SearchCompanyKey is null
		SELECT @SearchCompanyKey = c.CompanyKey 
		FROM tCompany c (nolock)
			inner join tGLCompanyAccess glca (nolock) on c.CompanyKey = glca.EntityKey and glca.Entity = 'tCompany'
		where c.OwnerCompanyKey = @CompanyKey 
		and   upper(CompanyName) = @VendorID
		and   glca.GLCompanyKey =  @GLCompanyKey
		and   c.Vendor = 1
		and   (@ActiveOnly = 0 OR Active = 1)
	end

	Return isnull(@SearchCompanyKey, 0)
GO
