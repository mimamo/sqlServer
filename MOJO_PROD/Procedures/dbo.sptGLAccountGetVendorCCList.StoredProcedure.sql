USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountGetVendorCCList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountGetVendorCCList]
	(
	@CompanyKey int
	,@UserKey int = null
	)
AS --Encrypt

	SET NOCOUNT ON

/*
|| When      Who Rel     What
|| 05/14/12  GHL 10.556  Created for the credit card payment screen
||                       We need a list of vendors like AMEX, CHASE
||                       The AMEX vendor is required for the payment
|| 10/01/12 GHL 10.560   Removed join with tGLAccount.GLCompanyKey
*/



	select  distinct gla.VendorKey 
	       ,vend.VendorID
		   ,vend.CompanyName
		   ,isnull(vend.VendorID + ' - ', '') + vend.CompanyName as FormattedName
	from    tGLAccount gla (nolock)
		inner join tCompany vend (nolock) on gla.VendorKey = vend.CompanyKey
	where   gla.CompanyKey = @CompanyKey
	and		gla.AccountType = 23

	And   (isnull(gla.RestrictToGLCompany, 0) = 0
					Or 
					gla.GLAccountKey in (
                           select glca.EntityKey 
						   from tGLCompanyAccess glca (nolock) 
								inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey
							where glca.Entity = 'tGLAccount'
							and  uglca.UserKey = @UserKey
						  )
				  )

	order by VendorID

	RETURN 1
GO
