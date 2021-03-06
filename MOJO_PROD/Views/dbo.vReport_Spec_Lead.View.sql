USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_Spec_Lead]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE       VIEW [dbo].[vReport_Spec_Lead]
AS

/*
|| When      Who Rel      What
|| 03/17/09  RTC 10.5	  Removed user defined fields.
|| 05/18/09  MAS 10.5.0.0 Changed Stage to Left Outer join
*/


SELECT 
	l.CompanyKey, 
	ss.CustomFieldKey,
	l.Subject AS Subject, 
	c.CompanyName AS [Company Name], 
	u.FirstName + ' ' + u.LastName AS [Primary Contact],
	uAM.FirstName + ' ' + uAM.LastName AS [Account Manager],
	pt.ProjectTypeName AS [Project Type], 
	lst.LeadStatusName AS [Lead Status], 
	case when lst.Active = 1 then 'YES' else 'NO' end as [Lead Status Active],
	lst.DisplayOrder AS [Lead Status Display Order], 
	lsg.LeadStageName AS [Lead Stage], 
	lsg.DisplayOrder AS [Lead Stage Display Order], 
	lo.Outcome AS Outcome, 
	l.CurrentStatus AS [Current Status], 
	l.OutcomeComment AS [Outcome Comment],  
	l.Probability AS Probability, 
	l.SaleAmount AS [Sale Total Amount], 
	l.SaleAmount * l.Probability / 100 AS [Weighted Sale Amount],
	l.SubAmount AS [Sale Subcontract Amount], 
	l.SaleAmount - l.SubAmount as [Sale Self Perform Amount],
	l.Margin AS Margin, 
	l.SaleAmount * l.Margin / 100 AS [Margin Amount],
	case when l.Bid = 1 then 'YES' else 'NO' end AS [Bid Lead], 
	l.BidDate AS [Bid Due Date], 
	l.StartDate AS [Lead Start Date], 
	l.EstCloseDate AS [Close Date Est], 
	l.ActualCloseDate AS [Close Date Actual], 
	l.Comments AS Comments,
	ss.Subject as [Spec Sheet Subject],
	ss.Description as [Spec Sheet Description],
	ss.DisplayOrder as [Spec Sheet Display Order]
FROM 
	tLead l (nolock)
	INNER JOIN tLeadStatus lst (nolock) ON l.LeadStatusKey = lst.LeadStatusKey 
	LEFT OUTER JOIN tLeadStage lsg (nolock) ON l.LeadStageKey = lsg.LeadStageKey 
	INNER JOIN tCompany c (nolock) ON l.ContactCompanyKey = c.CompanyKey 
	INNER JOIN tUser uAM (nolock) ON l.AccountManagerKey = uAM.UserKey 
	LEFT OUTER JOIN tSpecSheet ss (nolock) on l.LeadKey = ss.EntityKey and ss.Entity = 'Lead'
	LEFT OUTER JOIN tUser u (nolock) ON l.ContactKey = u.UserKey 
	LEFT OUTER JOIN tLeadOutcome lo (nolock) ON l.LeadOutcomeKey = lo.LeadOutcomeKey
    	LEFT OUTER JOIN tProjectType pt (nolock) ON l.ProjectTypeKey = pt.ProjectTypeKey
GO
