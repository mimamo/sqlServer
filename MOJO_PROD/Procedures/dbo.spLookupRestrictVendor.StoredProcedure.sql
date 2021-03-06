USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spLookupRestrictVendor]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLookupRestrictVendor]

	(
		@CompanyKey int
		,@SearchOption int	          -- 1 Vendor ID, 2 Company Name
		,@SearchPhrase varchar(200)
		,@GLCompanyKey int 
        ,@UserKey int	              -- obtained from session
	    ,@SearchMode varchar(20) = '' -- blank, reports, transactions
	)

AS

/*
|| When      Who Rel     What
|| 06/20/12  GHL 10.557  Creation for gl company security
*/

SELECT	@SearchPhrase = ISNULL(@SearchPhrase, '')

SELECT @SearchMode = isnull(@SearchMode, '')

if @SearchMode = 'transactions' and @GLCompanyKey <= 0
	select @SearchMode = 'reports'

if @SearchMode = 'reports' and @UserKey <= 0
	select @SearchMode = ''

if @SearchOption = 1
begin
	if @SearchMode = ''
		Select 
			CompanyKey,
			VendorID,
			CompanyName
		From
			tCompany (nolock)
		Where
			OwnerCompanyKey = @CompanyKey and
			Active = 1 and
			Vendor = 1 and
			VendorID like @SearchPhrase+'%'
		Order By VendorID

	-- for this mode, GLCompanyKey is required and we do not check the user's rights
	if @SearchMode = 'transactions'
		SELECT distinct c.CompanyKey, c.VendorID, c.CompanyName 
		FROM tCompany c (nolock)
			inner join tGLCompanyAccess glca (nolock) on c.CompanyKey = glca.EntityKey and glca.Entity = 'tCompany'
		where c.OwnerCompanyKey = @CompanyKey 
		and	  c.Active = 1
		and   c.Vendor = 1 
		and   c.VendorID like @SearchPhrase+'%'
		and   glca.GLCompanyKey =  @GLCompanyKey
		Order By c.VendorID

	-- for this mode, check user's rights, optionally check gl company
	if @SearchMode = 'reports'
		SELECT distinct c.CompanyKey, c.VendorID, c.CompanyName 
		FROM tCompany c (nolock)
			inner join tGLCompanyAccess glca (nolock) on c.CompanyKey = glca.EntityKey and glca.Entity = 'tCompany'
			inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey
		where c.OwnerCompanyKey = @CompanyKey 
		and	  c.Active = 1
		and   c.Vendor = 1 
		and   c.VendorID like @SearchPhrase+'%'
		and   uglca.UserKey = @UserKey
		and   (@GLCompanyKey <=0 -- optional
				or
			    glca.GLCompanyKey =  @GLCompanyKey 
			  )
		Order By c.VendorID

end
else
begin
	if @SearchMode = ''
		Select 
			CompanyKey,
			VendorID,
			CompanyName
		From
			tCompany (nolock)
		Where
			OwnerCompanyKey = @CompanyKey and
			Active = 1 and
			Vendor = 1 and
			CompanyName like @SearchPhrase+'%'
		Order By CompanyName

	-- for this mode, GLCompanyKey is required and we do not check the user's rights
	if @SearchMode = 'transactions'
		SELECT distinct c.CompanyKey, c.VendorID, c.CompanyName 
		FROM tCompany c (nolock)
			inner join tGLCompanyAccess glca (nolock) on c.CompanyKey = glca.EntityKey and glca.Entity = 'tCompany'
		where c.OwnerCompanyKey = @CompanyKey 
		and	  c.Active = 1
		and   c.Vendor = 1 
		and   c.CompanyName like @SearchPhrase+'%'
		and   glca.GLCompanyKey =  @GLCompanyKey
		Order By c.CompanyName

	-- for this mode, check user's rights, optionally check gl company
	if @SearchMode = 'reports'
		SELECT distinct c.CompanyKey, c.VendorID, c.CompanyName 
		FROM tCompany c (nolock)
			inner join tGLCompanyAccess glca (nolock) on c.CompanyKey = glca.EntityKey and glca.Entity = 'tCompany'
			inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey
		where c.OwnerCompanyKey = @CompanyKey 
		and	  c.Active = 1
		and   c.Vendor = 1 
		and   c.CompanyName like @SearchPhrase+'%'
		and   uglca.UserKey = @UserKey
		and   (@GLCompanyKey <=0 -- optional
				or
			    glca.GLCompanyKey =  @GLCompanyKey 
			  )
		Order By c.CompanyName

end
GO
