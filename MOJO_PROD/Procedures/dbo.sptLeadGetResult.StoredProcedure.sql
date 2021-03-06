USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadGetResult]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadGetResult]

@LeadStatusKey int,
@CompanyKey int,
@Active int

AS

SELECT     
	l.*,
	ls.LeadStatusName,
	lo.Outcome
	

	FROM  
		 tLead  l (nolock) LEFT OUTER JOIN
	     tLeadStatus ls (nolock) ON l.LeadStatusKey = ls.LeadStatusKey Left Outer join
	     tLeadOutcome lo (nolock) on l.LeadOutcomeKey = lo.LeadOutcomeKey	
WHERE    ls.Active = @Active 
		 and l.LeadStatusKey = @LeadStatusKey
		 and l.CompanyKey = @CompanyKey


	RETURN
GO
