USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGraphCashOnHand]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGraphCashOnHand]
(
	@CompanyKey int,
	@GLCompanyKey int = null,
	@UserKey int = null
)

As --Emcrypt

/*
|| When     Who Rel     What
|| 8.10.09  GWG 10.5.0.7 Changed where clause so balance is as of today
|| 7/31/12  RLB 10.5.5.8 Added GL Company and made HMI changes
*/

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
From   tPreference (nolock) 
Where  CompanyKey = @CompanyKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

Declare @StartDate smalldatetime, @LoopDate smalldatetime, @ViewDate smalldatetime, @i int, @StartYear int, @StartMonth int

Select @StartDate = Cast(Cast(MONTH(GETDATE()) as Varchar) + '/1/' + Cast(Year(GETDATE()) as Varchar) as smalldatetime)
Select @ViewDate = @StartDate
Select @StartDate = DATEADD(mm, 1, @StartDate)
Select @LoopDate = @StartDate
	
Select @i = 1

Create Table #CashBal
 (
	MonthNum int,
	YearNum int,
	Balance money )
	

Delete #CashBal


	
While @i <= 6
BEGIN

	Insert Into #CashBal ( MonthNum, YearNum, Balance )
	Select MONTH(@ViewDate), YEAR(@ViewDate), 
	Sum(Debit - Credit) from tTransaction (nolock) 
	inner join tGLAccount (nolock) on tTransaction.GLAccountKey = tGLAccount.GLAccountKey
	Where
		tTransaction.CompanyKey = @CompanyKey 
		and tTransaction.TransactionDate < @LoopDate 
		and tTransaction.TransactionDate <= GETDATE() 
		and tGLAccount.AccountType = 10
		and (@GLCompanyKey IS NULL OR tTransaction.GLCompanyKey = @GLCompanyKey)
		and (@GLCompanyKey IS NOT NULL or (@RestrictToGLCompany = 0 or tTransaction.GLCompanyKey in (select uglca.GLCompanyKey from tUserGLCompanyAccess uglca (nolock) where uglca.UserKey = @UserKey))) 

	Select @i = @i + 1
	
	Select @LoopDate = DATEADD(mm, -1, @LoopDate), @ViewDate = DATEADD(mm, -1, @ViewDate)

END


Select * from #CashBal Order By YearNum, MonthNum
GO
