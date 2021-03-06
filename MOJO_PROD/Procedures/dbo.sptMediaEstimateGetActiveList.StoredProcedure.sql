USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaEstimateGetActiveList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaEstimateGetActiveList]

	(
		@CompanyKey int
		,@SearchOption smallint		 -- 1 ID, 2 Name
		,@SearchPhrase varchar(200)
		,@UserKey int = null	      -- obtained from session
	    ,@SearchMode varchar(20) = '' -- blank, reports, transactions
	)

AS --Encrypt

  /*
  || When     Who Rel    What
  || 08/03/07 GHL 8.5    Added FilterGLCompanyKey to be used as filter in lookup 
  || 07/11/12 GHL 10.558 Added logic for restrict to gl company
  */
  
Declare @RestrictToGLCompany int
select @RestrictToGLCompany = isnull(RestrictToGLCompany, 0)
from   tPreference (nolock)
where  CompanyKey = @CompanyKey


if @SearchOption = 1
begin
	if @RestrictToGLCompany = 1 And @SearchMode <> 'transactions'
		Select *
			  ,isnull(GLCompanyKey, 0) as FilterGLCompanyKey
			   from tMediaEstimate (nolock)
		Where
			Active = 1 and
			CompanyKey = @CompanyKey and
			EstimateID Like @SearchPhrase + '%'
		And isnull(GLCompanyKey, 0) in (
			select GLCompanyKey from tUserGLCompanyAccess (nolock) where UserKey = @UserKey
		)
		Order By EstimateID
	
	else
		Select *
			  ,isnull(GLCompanyKey, 0) as FilterGLCompanyKey
			   from tMediaEstimate (nolock)
		Where
			Active = 1 and
			CompanyKey = @CompanyKey and
			EstimateID Like @SearchPhrase + '%'
		Order By EstimateID
end
	
else
begin
	if @RestrictToGLCompany = 1 And @SearchMode <> 'transactions'

		Select * 
			  ,isnull(GLCompanyKey, 0) as FilterGLCompanyKey
		from tMediaEstimate (nolock)
		Where
			Active = 1 and
			CompanyKey = @CompanyKey and
			EstimateName Like @SearchPhrase + '%'
		And isnull(GLCompanyKey, 0) in (
			select GLCompanyKey from tUserGLCompanyAccess (nolock) where UserKey = @UserKey
		)
		Order By EstimateName

else
	Select * 
			  ,isnull(GLCompanyKey, 0) as FilterGLCompanyKey
		from tMediaEstimate (nolock)
		Where
			Active = 1 and
			CompanyKey = @CompanyKey and
			EstimateName Like @SearchPhrase + '%'
		Order By EstimateName

end
GO
