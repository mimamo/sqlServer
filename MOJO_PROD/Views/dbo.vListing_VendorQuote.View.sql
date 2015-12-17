USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_VendorQuote]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_VendorQuote]
AS

/*
|| When      Who Rel     What
|| 10/10/07  CRG 8.5     Added GLCompany
|| 04/25/12  GHL 10.555  Added GLCompanyKey for map/restrict
*/

SELECT 
	q.QuoteKey,
	q.CompanyKey,
	q.GLCompanyKey,
	pot.PurchaseOrderTypeName AS [Purchase Order Type],
	q.QuoteNumber AS [Quote Number],
	p.ProjectName AS Project,
	p.ProjectNumber,
	cp.CampaignName as [Campaign Name],
	t.TaskName AS Task,
	i.ItemName AS Item,
	q.Subject,
	q.QuoteDate AS [Quote Date],
	q.DueDate AS [Due Date],
	q.Description,
	CASE q.Status
		when 1 then 'Not Sent'
		when 2 then 'Sent'
		when 3 then 'Closed'
	END as Status,
	ISNULL(u.FirstName,'') + ISNULL(u.LastName,'') AS [Send Replies To],
	st1.StandardText AS [Header Text],
	st2.StandardText AS [Footer Text],
	qr.VendorKey as VendorKey,
	(Select Sum(TotalCost) from tQuoteReplyDetail Where QuoteReplyKey = qr.QuoteReplyKey) as [Quote Total],
	glc.GLCompanyID as [Company ID],
	glc.GLCompanyName as [Company Name]
FROM 	tQuote q (NOLOCK)
INNER JOIN tCompany c (NOLOCK) ON q.CompanyKey = c.CompanyKey
LEFT JOIN tPurchaseOrderType pot (NOLOCK) ON q.PurchaseOrderTypeKey = pot.PurchaseOrderTypeKey
LEFT JOIN tProject p (NOLOCK) ON q.ProjectKey = p.ProjectKey
LEFT JOIN tTask t (NOLOCK) ON q.TaskKey = t.TaskKey
LEFT JOIN tItem i (NOLOCK) ON q.ItemKey = i.ItemKey
LEFT JOIN tUser u (NOLOCK) ON q.SendRepliesTo = u.UserKey
LEFT JOIN tStandardText st1 (NOLOCK) ON q.HeaderTextKey = st1.StandardTextKey
LEFT JOIN tStandardText st2 (NOLOCK) ON q.HeaderTextKey = st2.StandardTextKey
LEft Join tQuoteReply qr (NOLOCK) on  q.QuoteKey = qr.QuoteKey
left outer join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
left outer join tGLCompany glc (nolock) on q.GLCompanyKey = glc.GLCompanyKey
GO
