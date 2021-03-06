USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvExport_Vendors]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spvExport_Vendors]
	(
		@CompanyKey int,
		@IncludeDownloaded tinyint = 0
	)

AS --Encrypt

Declare @DefaultAPAccount as varchar(100)
Declare @DefaultCashAccount as Varchar(100)

Select @DefaultAPAccount = AccountNumber 
from tGLAccount gl (nolock)
	INNER JOIN tPreference p (nolock) on p.DefaultAPAccountKey = gl.GLAccountKey and p.CompanyKey = @CompanyKey

Select @DefaultCashAccount = AccountNumber 
from tGLAccount gl (nolock)
	INNER JOIN tPreference p (nolock) on p.DefaultCashAccountKey = gl.GLAccountKey and p.CompanyKey = @CompanyKey

if @IncludeDownloaded = 1
	Select 
		*, 
		@DefaultAPAccount as DefaultAPAccount,
		@DefaultCashAccount as DefaultCashAccount
 	from vExport_Contact (NOLOCK)
	Where
		OwnerCompanyKey = @CompanyKey and
		Vendor = 1
else
	Select 
		*, 
		@DefaultAPAccount as DefaultAPAccount,
		@DefaultCashAccount as DefaultCashAccount
    from vExport_Contact (NOLOCK)
	Where
		OwnerCompanyKey = @CompanyKey and
		Vendor = 1 and
		VendorDownloadFlag = 0
GO
