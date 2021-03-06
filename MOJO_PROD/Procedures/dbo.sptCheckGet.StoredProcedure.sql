USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckGet]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckGet]
 @CheckKey int
AS --Encrypt

  /*
  || When     Who Rel    What
  || 01/02/07 GHL 8.4    Changed logic for determining @Cleared flag to fix Issue 7671
  ||                     (Uncleared transactions showing receipt but receipt says cleared)
  || 10/5/07  GWG 8.5    Added GL Company Stuff
  || 02/16/10 MFT 10.518 Removed the reference to the OwnerCompanyKey aliased as CompanyKey (tCheck now has CompanyKey field)
  */
    
Declare @Cleared int
Declare @NumCleared int

Select @NumCleared = Count(*) 
from  tTransaction (NOLOCK) 
Where Entity = 'RECEIPT' And EntityKey = @CheckKey
And   Cleared = 1

If @NumCleared > 0
Begin
	-- Make sure that all transactions cleared
	If @NumCleared = (Select Count(*) 
	        from  tTransaction (NOLOCK) 
			Where Entity = 'RECEIPT' And EntityKey = @CheckKey)
		Select @Cleared = 1		
End
	
  SELECT 
	tCheck.*,
	c.CustomerID as ClientID,
	c.CompanyName,
	gl.AccountNumber as CashAccountNumber,
	gl2.AccountNumber as PrepayAccountNumber,
	cl.ClassID,
	d.DepositID,
	pr.CCProcessor,
	u.Phone1,
	u.Email,
	case when c.BillingAddressKey IS NOT NULL then bad.Country else ad.Country end as BCountry,
	ISNULL((Select Sum(Amount) from tCheckAppl (nolock) Where CheckKey = @CheckKey and InvoiceKey is not null), 0) as AppliedAmount,
	ISNULL((Select Sum(Amount) from tCheckAppl (nolock) Where CheckKey = @CheckKey and InvoiceKey is null), 0) as AppliedAmountGL,
	ISNULL(@Cleared, 0) As Cleared,
	glc.GLCompanyName,
	(Select count(*) from tCheckAppl (nolock) Where CheckKey = @CheckKey and InvoiceKey > 0) as LineCount
  FROM tCheck (nolock)
	inner join tCompany c (nolock) on tCheck.ClientKey = c.CompanyKey
	inner join tPreference pr (nolock) on c.OwnerCompanyKey = pr.CompanyKey
	left outer join tGLAccount gl (nolock) on tCheck.CashAccountKey = gl.GLAccountKey
	left outer join tGLAccount gl2 (nolock) on tCheck.PrepayAccountKey = gl2.GLAccountKey
	left outer join tClass cl (nolock) on tCheck.ClassKey = cl.ClassKey
	left outer join tDeposit d (nolock) on tCheck.DepositKey = d.DepositKey
	left outer join tUser u (nolock) on tCheck.CustomerContactKey = u.UserKey
	left outer join tAddress ad (nolock) on c.DefaultAddressKey = ad.AddressKey
	left outer join tAddress bad (nolock) on c.BillingAddressKey = bad.AddressKey
	left outer join tGLCompany glc (nolock) on tCheck.GLCompanyKey = glc.GLCompanyKey
  WHERE
   tCheck.CheckKey = @CheckKey
 RETURN 1
GO
