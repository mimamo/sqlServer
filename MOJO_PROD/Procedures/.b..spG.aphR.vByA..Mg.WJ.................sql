USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGraphRevByActMgrWJ]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGraphRevByActMgrWJ]
		@CompanyKey int,
		@StartDate varchar(10), -- The Date Range is calculated by Flex
		@EndDate   varchar(10),
		@UserKey int = null


AS --Encrypt

  /*
  || When     Who Rel       What
  || 05/20/09 MAS 10.5.0.0  Created
  || 07/27/12 RLB 10.5.5.8  Added HMI Restrict GL Company
  */


Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
From   tPreference (nolock) 
Where  CompanyKey = @CompanyKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)


SELECT SUM(ROUND(InvoiceTotalAmount,2)) AS RevAmount, 
	   ISNULL(u.FirstName + ' ' + u.LastName, 'No Manager Specified') AS AccountManagerName
FROM tInvoice i (nolock)
JOIN tCompany c (nolock) ON c.CompanyKey = i.ClientKey 
LEFT OUTER JOIN tUser u (nolock) on u.UserKey = c.AccountManagerKey
WHERE i.PostingDate >= @StartDate AND i.PostingDate <= @EndDate
AND i.AdvanceBill = 0
AND c.OwnerCompanyKey = @CompanyKey
AND (@RestrictToGLCompany = 0 or i.GLCompanyKey in (select uglca.GLCompanyKey from tUserGLCompanyAccess uglca (nolock) where uglca.UserKey = @UserKey))
Group by ISNULL(u.FirstName + ' ' + u.LastName, 'No Manager Specified')
ORDER BY RevAmount DESC
GO
