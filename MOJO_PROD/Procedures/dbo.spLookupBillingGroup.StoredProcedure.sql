USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spLookupBillingGroup]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLookupBillingGroup]

	(
		@CompanyKey int,
		@SearchPhrase varchar(200),
		@GLCompanyKey int,
		@UserKey int,
		@SearchMode varchar(50) -- transactions, reports, '' 
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 09/26/12  GHL 10.560 Created for HMI request of billing group code
*/

		select @SearchPhrase = upper(rtrim(ltrim(isnull(@SearchPhrase, ''))))


		declare @RestrictGLCompany int

		select @RestrictGLCompany = isnull(RestrictToGLCompany, 0)
		from   tPreference (nolock)
		where  CompanyKey = @CompanyKey


		if @RestrictGLCompany = 0
		begin
			if @SearchMode = 'transactions'

			Select * 
			From tBillingGroup (nolock)
			Where
				CompanyKey = @CompanyKey and
				Active = 1 and
				upper(BillingGroupCode) like @SearchPhrase + '%' and
				isnull(GLCompanyKey, 0) = isnull(@GLCompanyKey, 0)

			Order By BillingGroupCode

			else -- for reports

			Select * 
			From tBillingGroup (nolock)
			Where
				CompanyKey = @CompanyKey and
				Active = 1 and
				upper(BillingGroupCode) like @SearchPhrase + '%' 
				
			Order By BillingGroupCode

		end
		else 
		begin
			-- we restrict to gl company
			if @SearchMode = 'transactions'

			Select * 
			From tBillingGroup (nolock)
			Where
				CompanyKey = @CompanyKey and
				Active = 1 and
				upper(BillingGroupCode) like @SearchPhrase + '%' and
				isnull(GLCompanyKey, 0) = isnull(@GLCompanyKey, 0)

			Order By BillingGroupCode

			else -- for reports

			Select * 
			From tBillingGroup (nolock)
			Where
				CompanyKey = @CompanyKey and
				Active = 1 and
				upper(BillingGroupCode) like @SearchPhrase + '%' and
				(isnull(GLCompanyKey, 0) in (select GLCompanyKey from tUserGLCompanyAccess (nolock) where UserKey = @UserKey))

 			Order By BillingGroupCode

		end
GO
