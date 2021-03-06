USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDepositGetUnSelectedList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDepositGetUnSelectedList]

	(
		@DepositKey int
	)

AS

Declare @CompanyKey int
Declare @GLAccountKey int

	Select @CompanyKey = CompanyKey, @GLAccountKey = GLAccountKey from tDeposit (nolock) Where DepositKey = @DepositKey
	
	Select 
		ch.*,
		c.CustomerID,
		c.CompanyName
	From 
		tCheck ch (nolock)
		inner join tCompany c (nolock) on ch.ClientKey = c.CompanyKey
	Where
		ch.DepositKey is null and
		c.OwnerCompanyKey = @CompanyKey and
		ch.Posted = 0 and
		ch.CashAccountKey = @GLAccountKey
GO
