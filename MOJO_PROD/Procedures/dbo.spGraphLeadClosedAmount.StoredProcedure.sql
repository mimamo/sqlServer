USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGraphLeadClosedAmount]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGraphLeadClosedAmount]

@CompanyKey int,
@StartDate Datetime,
@EndDate Datetime,
@AEKey int
AS --Encrypt




Select 

	

	sum(l.SaleAmount) as TotalSales,
	l.ActualCloseDate
	
	
		

FROM  

tLead l (nolock) Left Outer join
tLeadOutcome lo (nolock) on l.LeadOutcomeKey = lo.LeadOutcomeKey	



WHERE    
	l.CompanyKey = @CompanyKey and 
	l.ActualCloseDate Between @StartDate and @EndDate and l.AccountManagerKey = @AEKey 
	and l.LeadStatusKey in (SELECT LeadStatusKey FROM tLeadStatus (nolock) Where CompanyKey = @CompanyKey and Active=0 )
Group By 
	l.ActualCloseDate
RETURN
GO
