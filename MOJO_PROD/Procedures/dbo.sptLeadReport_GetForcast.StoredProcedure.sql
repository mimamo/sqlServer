USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadReport_GetForcast]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptLeadReport_GetForcast]

	(
		@CompanyKey int,
		@AccountManagerKey int
	)

AS --Encrypt

if @AccountManagerKey =0 
	Select
		
		DATEPART(Year,l.EstCloseDate) as LeadYear,
		DATEPART(Month,l.EstCloseDate) as LeadMonth,
		Sum(l.SaleAmount) as SaleAmount,
		Sum(l.SubAmount) as SubAmount,
		Count(*) as ItemCount,
		Sum(l.SaleAmount * (l.Probability/100.00)) as WeightSaleAmount
	From
		tLead l (nolock),
		tLeadStatus ls (nolock)
	Where
		l.CompanyKey = @CompanyKey and
		l.LeadStatusKey = ls.LeadStatusKey and
		ls.Active = 1
	Group By
		DATEPART(Year,l.EstCloseDate), DATEPART(Month,l.EstCloseDate)
	Order By
		DATEPART(Year,l.EstCloseDate), DATEPART(Month,l.EstCloseDate)

else
	Select
		
		DATEPART(Year,l.EstCloseDate) as LeadYear,
		DATEPART(Month,l.EstCloseDate) as LeadMonth,
		Sum(l.SaleAmount) as SaleAmount,
		Sum(l.SubAmount) as SubAmount,
		Count(*) as ItemCount,
		Sum(l.SaleAmount * (l.Probability/100.00)) as WeightSaleAmount
	From
		tLead l (nolock),
		tLeadStatus ls (nolock)
	Where
		l.CompanyKey = @CompanyKey and
		l.LeadStatusKey = ls.LeadStatusKey and
		ls.Active = 1 AND
		l.AccountManagerKey = @AccountManagerKey
	Group By
		DATEPART(Year,l.EstCloseDate), DATEPART(Month,l.EstCloseDate)
	Order By
		DATEPART(Year,l.EstCloseDate), DATEPART(Month,l.EstCloseDate)
GO
