USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetDfltSalesGLAcct]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGetDfltSalesGLAcct]
	@CompanyKey int,
	@ClientKey int
AS --Encrypt

declare @GLAccount int
Declare @GLAccountNumber varchar(100)

	Select @GLAccount = ISNULL(co.DefaultSalesAccountKey, 0)
		from tCompany co (nolock) 
			where co.CompanyKey = @ClientKey
			
	if @GLAccount = 0
		select @GLAccount = ISNULL(DefaultSalesAccountKey, 0)
		from tPreference p (nolock)
		where p.CompanyKey = @CompanyKey
	  
	if @GLAccount = 0
		Select @GLAccountNumber = ''
	else
		Select @GLAccountNumber = AccountNumber from tGLAccount (nolock) Where GLAccountKey = @GLAccount
		
		
	Select @GLAccountNumber as AccountNumber
GO
