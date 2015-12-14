USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeGetUnpaid]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeGetUnpaid]
	@VendorKey int
	,@UserKey int
	,@GLCompanyKey int
	,@CurrencyID varchar(10)
AS

/*
|| When     Who Rel     What
|| 08/04/11 MFT 10.545  Created to pull unbilled time for Voucher entry
|| 09/13/11 MFT 10.548  Added tm.TimeKey
|| 10/20/11 MFT 10.549  Removed @CompanyKey
|| 11/28/11 GHL 10.550  Filtering out transferred time entries
|| 01/17/12 GHL 10.552  Joining now tTime.UserKey = tUser.UserKey
||                      instead of thru tTimeSheet.UserKey
|| 05/30/12 GHL 10.556  (145013) Added Contractor filter
|| 05/31/12 GHL 10.556  Added GLCompanyKey security based on tUser.GLCompanyKey
|| 12/19/12 GHL 10.563  The GLCompany should be the same as the voucher, added GLCompanyKey param
|| 11/04/13 GHL 10.574  Added multicurrency info
*/

declare @CompanyKey int
select @CompanyKey = OwnerCompanyKey
from   tCompany (nolock)
where  CompanyKey = @VendorKey

Declare @UseGLCompany int
Declare @MultiCurrency int

Select @UseGLCompany = ISNULL(UseGLCompany, 0)
      ,@MultiCurrency = ISNULL(MultiCurrency, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @UseGLCompany = isnull(@UseGLCompany, 0)
      ,@MultiCurrency = isnull(@MultiCurrency, 0)

SELECT  
	u.FirstName + ' ' + u.LastName AS Person,
	u.UserKey,
	p.ProjectKey,
	p.ProjectNumber,
	p.ProjectName,
	t.TaskKey,
	t.TaskID,
	t.TaskName,
	s.ServiceKey,
	s.ServiceCode,
	s.Description AS Service,
	cast(tm.TimeKey as varchar(250)) as TimeKey, -- send as varchar cause Flex removes dashes
	tm.WorkDate,
	tm.ActualHours,
	tm.CostRate,
	tm.HCostRate,
	tm.DateBilled,
	ROUND(tm.ActualHours * tm.CostRate, 2) AS TotalCost
FROM
	tTime tm (nolock)
	INNER JOIN tTimeSheet ts (nolock)
		ON tm.TimeSheetKey = ts.TimeSheetKey
	INNER JOIN tUser u (nolock)
		ON tm.UserKey = u.UserKey
	LEFT JOIN tProject p (nolock)
		ON tm.ProjectKey = p.ProjectKey
	LEFT JOIN tTask t (nolock)
		ON tm.TaskKey = t.TaskKey
	LEFT JOIN tService s (nolock)
		ON tm.ServiceKey = s.ServiceKey
WHERE ts.CompanyKey = @CompanyKey
AND	  ts.Status = 4
AND   tm.VoucherKey IS NULL
AND   tm.TransferToKey is null -- not transfered
AND 	(
		u.CompanyKey = @VendorKey OR
		u.VendorKey = @VendorKey
		) 
AND   u.Contractor = 1
And (@UseGLCompany = 0
	OR isnull(p.GLCompanyKey,0) = @GLCompanyKey
	)

And (@MultiCurrency = 0
	OR isnull(tm.CurrencyID,'') = @CurrencyID
	)

ORDER BY
	u.LastName,
	u.FirstName,
	u.UserKey,
	tm.WorkDate
GO
