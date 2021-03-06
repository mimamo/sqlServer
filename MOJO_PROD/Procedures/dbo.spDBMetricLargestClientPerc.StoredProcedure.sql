USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spDBMetricLargestClientPerc]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDBMetricLargestClientPerc]
	@CompanyKey int,
	@FromDate datetime,
	@ToDate datetime,
	@GLCompanyKey int,
	@UserKey int,
	@ClientCompanyKey int output,
	@CompanyName varchar(200) output,
	@Percent decimal(9,2) output

AS --Encrypt

  /*
  || When     Who Rel			  What
  || 03/15/12 RLB 10.5.5.4  (137083) add some protection for getting a divided by 0 error
  || 07/31/12 MFT 10.5.5.8  Added @GLCompanyKey & @UserKey params and GL Company restrictions	
  || 03/14/14 GHL 10.5.7.8  Added conversion to home currency  
  || 07/15/14 GWG 10.5.8.2  Fixed the join on invoice GL company restrictions was pointing to the gl company on the company, not the invoice
  */

declare @TotalInvoiceAmount decimal(24,4)
declare @MaxInvoiceAmount decimal(24,4)

------------------------------------------------------------
--GL Company restrictions
DECLARE @RestrictToGLCompany tinyint
DECLARE @tGLCompanies table (GLCompanyKey int)
SELECT @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey

IF ISNULL(@GLCompanyKey, 0) > 0
	INSERT INTO @tGLCompanies VALUES(@GLCompanyKey)
ELSE
	BEGIN --No @GLCompanyKey passed in
		IF @RestrictToGLCompany = 0
			BEGIN --@RestrictToGLCompany = 0
			 	--All GLCompanyKeys + 0 to get NULLs
				INSERT INTO @tGLCompanies VALUES(0)
				INSERT INTO @tGLCompanies
					SELECT GLCompanyKey
					FROM tGLCompany (nolock)
					WHERE CompanyKey = @CompanyKey
			END --@RestrictToGLCompany = 0
		ELSE
			BEGIN --@RestrictToGLCompany = 1
				 --Only GLCompanyKeys @UserKey has access to
				INSERT INTO @tGLCompanies
					SELECT GLCompanyKey
					FROM tUserGLCompanyAccess (nolock)
					WHERE UserKey = @UserKey
			END --@RestrictToGLCompany = 1
	END --No @GLCompanyKey passed in
--GL Company restrictions
------------------------------------------------------------

create table #tLargestClient (CompanyKey int null, InvoiceAmount decimal(24,4) null)

insert #tLargestClient (CompanyKey, InvoiceAmount)
select isnull(c.ParentCompanyKey,c.CompanyKey), isnull(sum(
	isnull(TotalNonTaxAmount,0) * isnull(ExchangeRate,1) -- convert to home currency
	),0)
from
	tInvoice i (nolock)
	inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
	INNER JOIN @tGLCompanies glc ON ISNULL(i.GLCompanyKey, 0) = glc.GLCompanyKey
where
	i.CompanyKey = @CompanyKey
	and i.InvoiceDate >= @FromDate
	and i.InvoiceDate < @ToDate
	and i.AdvanceBill = 0
group by isnull(c.ParentCompanyKey,c.CompanyKey)

select @MaxInvoiceAmount = max(InvoiceAmount)
from #tLargestClient

select top 1 @ClientCompanyKey = CompanyKey
from #tLargestClient 
where InvoiceAmount = @MaxInvoiceAmount

select @TotalInvoiceAmount = sum(InvoiceAmount)
from #tLargestClient

-- because of conversion to home currency, round at 2
select @MaxInvoiceAmount = round(@MaxInvoiceAmount, 2)
		,@TotalInvoiceAmount = round(@TotalInvoiceAmount, 2)

select @CompanyName = CompanyName
from tCompany (nolock)
where CompanyKey = @ClientCompanyKey

if @TotalInvoiceAmount <> 0
	select @Percent = round(@MaxInvoiceAmount/@TotalInvoiceAmount,2)
else
	select @Percent = 0

return 1
GO
