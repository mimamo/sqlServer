USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingGroupValid]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingGroupValid]
	(
	@CompanyKey int
	,@BillingGroupCode varchar(200)  
	,@SearchMode varchar(20) -- blank, reports, transactions
	,@GLCompanyKey int       -- 0 All, >0 specific GL company
	,@UserKey int 
	,@ActiveOnly int 
	)
AS --Encrypt

/*
|| When      Who Rel     What
|| 6/15/12   GHL 10.557   Created to validate billing group for a certain GL Company
||                       Originally needed for the imports i.e. SearchMode = transactions
||
||                       Search Mode = transactions
||                           GLCompanyKey required
||                           UserKey not required
||                       Search Mode = reports
||                           GLCompanyKey not required
||                           UserKey required
*/
	select @SearchMode = isnull(@SearchMode, '')
	select @GLCompanyKey = isnull(@GLCompanyKey, 0)
	select @ActiveOnly = isnull(@ActiveOnly, 0)
	select @BillingGroupCode = upper(ltrim(rtrim(@BillingGroupCode))) 

	declare @RestrictGLCompany int

	select @RestrictGLCompany = isnull(RestrictToGLCompany, 0)
	from   tPreference (nolock)
	where  CompanyKey = @CompanyKey

	Declare @SearchBillingGroupKey int

	if @RestrictGLCompany = 0	
	begin
		SELECT @SearchBillingGroupKey = BillingGroupKey
		FROM tBillingGroup (nolock)
		WHERE
			CompanyKey = @CompanyKey AND
			upper(BillingGroupCode) = @BillingGroupCode  AND
			(@ActiveOnly = 0 OR Active = 1)
	end
	else
	begin
		-- we restrict to GL companies
		if @SearchMode = 'reports'
		begin
			SELECT @SearchBillingGroupKey = bg.BillingGroupKey
			FROM  tBillingGroup bg (nolock)
				inner join tUserGLCompanyAccess uglca (nolock) on bg.GLCompanyKey = uglca.GLCompanyKey 
			where bg.CompanyKey = @CompanyKey 
			and upper(BillingGroupCode) = @BillingGroupCode  
			and uglca.UserKey = @UserKey
			and   (@GLCompanyKey <=0
					or
					uglca.GLCompanyKey =  @GLCompanyKey
				  )
			and (@ActiveOnly = 0 OR Active = 1)

		end

		-- for this mode, GLCompanyKey is required and we do not check the user's rights
		if @SearchMode = 'transactions'
		begin
			SELECT @SearchBillingGroupKey = bg.BillingGroupKey
			FROM  tBillingGroup bg (nolock)
			where bg.CompanyKey = @CompanyKey 
			and upper(BillingGroupCode) = @BillingGroupCode  
			and   bg.GLCompanyKey = @GLCompanyKey 
			and (@ActiveOnly = 0 OR Active = 1)

		end

	end

	Return isnull(@SearchBillingGroupKey, 0)
GO
