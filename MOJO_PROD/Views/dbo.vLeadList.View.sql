USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vLeadList]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  VIEW [dbo].[vLeadList]
AS
SELECT 
	tLead.LeadKey,
	tLead.CompanyKey, 
	tLead.Subject AS Subject, 
	tLead.ContactCompanyKey,
	tCompany.CompanyName,
	tCompany.UserDefined1 AS CUserDefined1,
	tCompany.UserDefined2 AS CUserDefined2,
	tCompany.UserDefined3 AS CUserDefined3,
	tCompany.UserDefined4 AS CUserDefined4,
	tCompany.UserDefined5 AS CUserDefined5,
	tCompany.UserDefined6 AS CUserDefined6,
	tCompany.UserDefined7 AS CUserDefined7,
	tCompany.UserDefined8 AS CUserDefined8,
	tCompany.UserDefined9 AS CUserDefined9,
	tCompany.UserDefined10 AS CUserDefined10,
	tUser.FirstName + ' ' + tUser.LastName AS PrimaryContact,
	tUser1.FirstName + ' ' + tUser1.LastName AS AccountManagerName,
	tLead.AccountManagerKey,
	tLead.ProjectTypeKey,
	tProjectType.ProjectTypeName AS ProjectTypeName, 
	tLead.LeadStatusKey,
	tLead.LeadStageKey,
	CASE when tLeadStatus.Active = 1 then 'YES' else 'NO' end AS [Lead Active],
	cast(tLeadStage.DisplayOrder as varchar) + ' - ' + tLeadStage.LeadStageName AS LeadStageName, 
	tLeadStage.DisplayOrder AS LeadStageDisplayOrder, 
	tLeadOutcome.Outcome AS LeadOutcome, 
	tLead.CurrentStatus AS CurrentStatus,
	tLead.OutcomeComment AS OutcomeComment, 
	tLead.User1 AS LUserDefined1, 
	tLead.User2 AS LUserDefined2,
	tLead.User3 AS LUserDefined3,
	tLead.User4 AS LUserDefined4,
	tLead.User5 AS LUserDefined5,
	tLead.User6 AS LUserDefined6,
	tLead.User7 AS LUserDefined7,
	tLead.User8 AS LUserDefined8,
	tLead.User9 AS LUserDefined9,
	tLead.User10 AS LUserDefined10, 
	tLead.Probability AS Probability, 
	tLead.SaleAmount, 
	tLead.SaleAmount * tLead.Probability / 100 AS WeightedSaleAmount,
	tLead.SubAmount, 
	tLead.SubAmount * tLead.Probability / 100 AS WeightedSubAmount,
	tLead.Margin AS Margin, 
	tLead.SaleAmount * tLead.Margin / 100 AS MarginAmount, 
	tLead.StartDate, 
	tLead.EstCloseDate,
	DATEPART("YYYY", tLead.EstCloseDate) AS EstCloseYear,
	DATEPART("mm", tLead.EstCloseDate) AS EstCloseMonth,
	tLead.ActualCloseDate,
	DATEPART("YYYY", tLead.ActualCloseDate) AS ActualCloseYear,
	DATEPART("mm", tLead.ActualCloseDate) AS ActualCloseMonth,
	tLead.Comments AS Comments
FROM tLead INNER JOIN
    tLeadStatus ON 
    tLead.LeadStatusKey = tLeadStatus.LeadStatusKey INNER JOIN
    tLeadStage ON 
    tLead.LeadStageKey = tLeadStage.LeadStageKey INNER JOIN
    tCompany ON 
    tLead.ContactCompanyKey = tCompany.CompanyKey INNER JOIN
    tUser tUser1 ON 
    tLead.AccountManagerKey = tUser1.UserKey LEFT OUTER JOIN
    tUser ON 
    tLead.ContactKey = tUser.UserKey LEFT OUTER JOIN
    tLeadOutcome ON 
    tLead.LeadOutcomeKey = tLeadOutcome.LeadOutcomeKey
     LEFT OUTER JOIN
    tProjectType ON 
    tLead.ProjectTypeKey = tProjectType.ProjectTypeKey
GO
