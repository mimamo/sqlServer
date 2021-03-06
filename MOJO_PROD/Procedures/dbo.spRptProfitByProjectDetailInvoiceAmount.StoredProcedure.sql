USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProfitByProjectDetailInvoiceAmount]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProfitByProjectDetailInvoiceAmount]
    @GLCompanyKey int,
    @ProjectKey int,
    @StartDate smalldatetime,
    @EndDate smalldatetime,
	@UserKey int = null,
    @InvoiceAmount money OUTPUT
AS --Encrypt

/*
|| When      Who Rel      What
|| 10/27/08  CRG 10.0.1.1 (33250) Created for the Profit By Project Detail report
|| 04/11/12  GHL 10.555  Added UserKey for UserGLCompanyAccess
|| 01/02/14 GHL 10.575  Reading now vHTransaction for home currency amount
*/

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)


	SELECT   @InvoiceAmount = sum(Credit - Debit)
	from vHTransaction t (nolock) 
	inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
	where t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
	and gl.AccountType = 40
	and isnull(t.Overhead, 0) = 0
	and t.ProjectKey = @ProjectKey
  
	--AND (@GLCompanyKey is null or ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			)
GO
