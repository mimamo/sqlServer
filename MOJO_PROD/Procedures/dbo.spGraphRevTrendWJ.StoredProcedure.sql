USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGraphRevTrendWJ]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGraphRevTrendWJ]
		@CompanyKey int,
		@EntityKeys varchar(8000),
		@StartDate varchar(10),
		@GLCompanyKey int = null,
		@UserKey int = null

AS --Encrypt

  /*
  || When     Who Rel       What
  || 05/25/09 MAS 10.5.0.0  Created
  || 08/10/12 RLB 10.5.5.8  Changes for Added GL Company and HMI changes
  */

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
From   tPreference (nolock) 
Where  CompanyKey = @CompanyKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

Create Table #RevMonths(
	RevMonthsKey int,	
	MonthNum int,
	YearNum int,
	MonthTotal money
)

-- Create a temp table with our EntityKeys (UserKeys) if needed
Declare @IncludeAll int 
Declare @idx int 

if len(@EntityKeys)<1 or @EntityKeys is null 
  Set @IncludeAll = 1 -- If nothing is passed in, results will include all users
else
 Begin
	Set @IncludeAll = 0
	Create table #keys (Entitykey int)
	Declare @slice varchar(8000)       

	Select @idx = 1  
	While @idx!= 0       
	Begin       
		set @idx = charindex(',',@EntityKeys)       
		if @idx!=0       
			set @slice = left(@EntityKeys,@idx - 1)       
		else       
			set @slice = @EntityKeys       
	      
		if(len(@slice)>0)  
			Insert Into #keys(Entitykey) values(@slice)       

		set @EntityKeys = right(@EntityKeys,len(@EntityKeys) - @idx)       
		if len(@EntityKeys) = 0 break       
	End 
 End

-- Loop through the next 12 months and build a table with 0 MonthTotal for each month
Declare @CurrentDate as datetime

Set @CurrentDate = @StartDate
Set @idx = 0
While @idx < 12
BEGIN
	Set @CurrentDate = DateAdd(month, @idx, @StartDate)
	Insert Into #RevMonths (RevMonthsKey, MonthNum, YearNum, MonthTotal)
	Values (@idx, Month(@CurrentDate), Year(@CurrentDate), 0)
	Set @idx = @idx + 1
END

If @IncludeAll = 1 -- results will include all users
	Begin
		Update #RevMonths 
		Set MonthTotal = (
			Select SUM(ROUND(ISNULL(InvoiceTotalAmount,0),2))
			FROM tInvoice i
			JOIN tCompany c (nolock) ON c.CompanyKey = i.ClientKey 
			LEFT OUTER JOIN tUser u (nolock) on u.UserKey = c.AccountManagerKey
			WHERE  i.AdvanceBill = 0
			AND c.OwnerCompanyKey = @CompanyKey
			AND (@GLCompanyKey IS NULL OR i.GLCompanyKey = @GLCompanyKey)
			AND (@GLCompanyKey IS NOT NULL OR (@RestrictToGLCompany = 0 OR i.GLCompanyKey in (select uglca.GLCompanyKey from tUserGLCompanyAccess uglca (nolock) where uglca.UserKey = @UserKey)))
			AND #RevMonths.MonthNum = Month(i.PostingDate) AND #RevMonths.YearNum = Year(i.PostingDate)	)
	End
Else
	Begin
		Update #RevMonths 
		Set MonthTotal = (
			Select SUM(ROUND(ISNULL(InvoiceTotalAmount,0),2))
			FROM tInvoice i
			JOIN tCompany c (nolock) ON c.CompanyKey = i.ClientKey 
			LEFT OUTER JOIN tUser u (nolock) on u.UserKey = c.AccountManagerKey
			JOIN #keys on #keys.Entitykey = c.AccountManagerKey
			WHERE  i.AdvanceBill = 0
			AND c.OwnerCompanyKey = @CompanyKey
			AND (@GLCompanyKey IS NULL OR i.GLCompanyKey = @GLCompanyKey)
			AND (@GLCompanyKey IS NOT NULL OR (@RestrictToGLCompany = 0 OR i.GLCompanyKey in (select uglca.GLCompanyKey from tUserGLCompanyAccess uglca (nolock) where uglca.UserKey = @UserKey)))
			AND #RevMonths.MonthNum = Month(i.PostingDate) AND #RevMonths.YearNum = Year(i.PostingDate) )
	End

-- Update the #RevMonths setting each acumulating the monthly total
Declare @t int
Select @t =  MonthTotal from #RevMonths Where RevMonthsKey = 0

Set @idx = 1
While @idx < 12
BEGIN
	Select @t = Sum(MonthTotal) From #RevMonths Where RevMonthsKey in (@idx, @idx-1)
	
	Update #RevMonths
	Set MonthTotal = @t
	Where RevMonthsKey = @idx
	Set @idx = @idx + 1
END

-- Return the Temp Table	
Select YearNum, MonthNum, ISNULL(MonthTotal,0) AS MonthTotal from #RevMonths order by YearNum, MonthNum

-- Exec spGraphRevTrendWJ 100, '', '1/01/2005'
GO
