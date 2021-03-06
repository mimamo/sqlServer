USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProfitByClientDetailInvoiceAmount]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProfitByClientDetailInvoiceAmount]

            @GLCompanyKey int,
            @ClientKey int,
            @StartDate smalldatetime,
            @EndDate smalldatetime,
			@UserKey int = null,
            @InvoiceAmount money OUTPUT

AS --Encrypt

/*
|| When      Who Rel     What
|| 10/16/07  CRG 8.5     Created for the Profit By Client Detail report
|| 09/26/08  GHL 10.0.0.9 (33946) Calculating now InvoiceAmount exactly as Revenue in spRptProfitClientMulti
||                       This value is only used to calculate Overhead Allocation
|| 04/10/12  GHL 10.555  Added UserKey for UserGLCompanyAccess
|| 01/02/14  GHL 10.575  Reading now vHTransaction for home currency amounts
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
and t.ClientKey = @ClientKey
--and (@GLCompanyKey is null or ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
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
 
/*
            SELECT            @InvoiceAmount = SUM(ISNULL(i.Amount + i.SalesTaxAmount, 0))
            FROM   tInvoiceSummary i (nolock)
            INNER JOIN tInvoice inv (nolock) ON i.InvoiceKey = inv.InvoiceKey
            INNER JOIN tProject p (nolock) ON i.ProjectKey = p.ProjectKey
            WHERE            inv.PostingDate >= @StartDate
            AND                 inv.PostingDate <= @EndDate
            AND                 inv.AdvanceBill = 0
            AND                 p.ClientKey = @ClientKey
            AND                 (ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
*/
GO
