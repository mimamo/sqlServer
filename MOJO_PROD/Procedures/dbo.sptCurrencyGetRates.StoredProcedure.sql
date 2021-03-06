USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCurrencyGetRates]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCurrencyGetRates]
	(
	@CompanyKey int
	,@UserKey int
	,@GLCompanyKey int -- -1 All, 0 Blank, >0 specific gl comp
	,@CurrencyID varchar(10)
	,@StartDate smalldatetime 
	,@EndDate smalldatetime
	)

AS --Encrypt

	SET NOCOUNT ON

  /*
  || When     Who Rel      What
  || 09/04/13 GHL 10.572  Creation for multi currency functionality
  ||                      Used to maintain currency rates on the admin screens  
  || 09/06/13 GHL 10.572  Added GL Company info + security
  */

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)


	select cr.*
	      ,glc.GLCompanyID
		  ,glc.GLCompanyName

	from   tCurrencyRate cr (nolock)
		left join tGLCompany glc (nolock) on cr.GLCompanyKey = glc.GLCompanyKey 
	where  cr.CompanyKey = @CompanyKey
	and    (@GLCompanyKey = -1 or isnull(@GLCompanyKey, 0) = isnull(cr.GLCompanyKey, 0)) 
	-- effective dates contain times   
	and    CONVERT(smalldatetime, CONVERT(varchar(10), cr.EffectiveDate, 101), 101) >= @StartDate
	and    CONVERT(smalldatetime, CONVERT(varchar(10), cr.EffectiveDate, 101), 101) <= @EndDate
	and    cr.CurrencyID = @CurrencyID

	and     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(cr.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(cr.GLCompanyKey, 0) = @GLCompanyKey)
			)

	order by cr.EffectiveDate desc, cr.CurrencyRateKey desc

	RETURN 1
GO
