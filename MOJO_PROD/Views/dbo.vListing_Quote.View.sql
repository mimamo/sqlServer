USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Quote]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    VIEW [dbo].[vListing_Quote]
AS

/*
|| When      Who Rel     What
|| 10/10/07  CRG 8.5     Added GLCompany
|| 11/19/10  RLB 10538   (94513) Added New Quote Status
|| 03/15/12  GHL 10554   Added estimate info
|| 04/25/12 GHL 10555    Added GLCompanyKey for map/restrict
|| 05/22/12 GHL 10556    If there is no estimate, default Estimate Entity to Project
|| 01/27/15 WDF 10588    (Abelson Taylor) Added Division and Product
*/

SELECT 
	q.QuoteKey,
	q.CompanyKey,
	q.GLCompanyKey,
	pot.PurchaseOrderTypeName AS [Purchase Order Type],
	q.QuoteNumber AS [Quote Number],
	p.ProjectName AS [Project Name],
	p.ProjectNumber as [Project Number],
	t.TaskName AS Task,
	i.ItemName AS Item,
	q.Subject,
	q.QuoteDate AS [Quote Date],
	q.DueDate AS [Due Date],
	q.Description,
	CASE q.Status
		when 1 then 'Not Sent For Approval'
		when 2 then 'Sent - Pending Replies'
		when 3 then 'Closed'
		when 4 then 'Sent - Not All Replies Completed'
	END as Status,
	ISNULL(u.FirstName,'') + ISNULL(u.LastName,'') AS [Send Replies To],
	st1.StandardText AS [Header Text],
	st2.StandardText AS [Footer Text],
	glc.GLCompanyID as [Company ID],
	glc.GLCompanyName as [Company Name],
	
	e.EstimateName as [Estimate Name],
	case when e.ProjectKey > 0 then 'Project' 
	     when e.CampaignKey > 0 then 'Campaign'
		 when e.LeadKey > 0 then 'Opportunity'
	end as [Estimate Entity],
	case when e.ProjectKey > 0		then cast(ep.ProjectNumber + ' - ' + ep.ProjectName as varchar(255))
	     when e.CampaignKey > 0		then cast(ec.CampaignID + ' - ' + ec.CampaignName as varchar(255))
		 when e.LeadKey > 0			then cast(el.Subject as varchar(255))
	end as [Estimate Entity Name],
	cd.DivisionID as [Client Division ID],
    cd.DivisionName as [Client Division],
    cp.ProductID as [Client Product ID],
    cp.ProductName as [Client Product]
FROM 	tQuote q (NOLOCK)
INNER JOIN tCompany c (NOLOCK) ON q.CompanyKey = c.CompanyKey
LEFT JOIN tPurchaseOrderType pot (NOLOCK) ON q.PurchaseOrderTypeKey = pot.PurchaseOrderTypeKey
LEFT JOIN tProject p (NOLOCK) ON q.ProjectKey = p.ProjectKey
LEFT JOIN tTask t (NOLOCK) ON q.TaskKey = t.TaskKey
LEFT JOIN tItem i (NOLOCK) ON q.ItemKey = i.ItemKey
LEFT JOIN tUser u (NOLOCK) ON q.SendRepliesTo = u.UserKey
LEFT JOIN tStandardText st1 (NOLOCK) ON q.HeaderTextKey = st1.StandardTextKey
LEFT JOIN tStandardText st2 (NOLOCK) ON q.HeaderTextKey = st2.StandardTextKey
left outer join tGLCompany glc (nolock) on q.GLCompanyKey = glc.GLCompanyKey
left outer join tEstimate e (nolock) on q.EstimateKey = e.EstimateKey
left outer join tProject ep (nolock) on ep.ProjectKey = e.ProjectKey
left outer join tCampaign ec (nolock) on ec.CampaignKey = e.CampaignKey
left outer join tLead el (nolock) on el.LeadKey = e.LeadKey
left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
left outer join tClientProduct  cp (nolock) on p.ClientProductKey  = cp.ClientProductKey
GO
