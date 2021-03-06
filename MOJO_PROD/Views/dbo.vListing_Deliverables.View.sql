USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Deliverables]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_Deliverables]
AS

/*
|| When			   Who		Rel			What
|| 07/25/2011  MAS  10.x.x.x  Created for new Deliverable Listing
|| 09/06/2011  QMD  10.5.4.9  Added ClientKey
|| 11/01/2011  QMD  10.5.4.9  Added Current Round, Step, Date Sent, Paused, Send as a set
|| 11/11/2011  QMD  10.5.5.0  Added ReviewRoundKey
|| 04/02/2012  MFT  10.5.5.5  Added GLCompanyKey in order to map/restrict
|| 05/01/2012  QMD  10.5.5.5  (142163) Removed Status = 1 clause
|| 09/20/2012  GWG  10.5.6.0  Added Current Approver
|| 01/07/2014  QMD  10.5.7.6  (201409) Changed status Resubmit to Rejected
|| 01/27/2015  WDF  10.5.8.8  (Abelson Taylor) Added Division and Product
*/

SELECT
	 rd.ReviewDeliverableKey
	,rd.OwnerKey 
	,rd.CompanyKey	
	,r.ReviewRoundKey
	,p.GLCompanyKey
	,p.ProjectKey
	,rd.Description AS [Description]
	,rd.DeliverableName AS [Deliverable Name]
	,rd.DueDate AS [Due Date]
	,p.ProjectNumber AS [Project Number]
	,p.ProjectName AS [Project Name]
	,p.ProjectNumber + ' - ' + p.ProjectName AS [Project Full Name]
	,c.CustomerID as [Client ID]
	,c.CompanyName as [Client Name]
	,c.CustomerID + ' ' + c.CompanyName as [Client Full Name]
	,r.RoundName AS [Current Round]
	,Case a.EnableRouting
		WHEN 1 THEN 'In Order'
		WHEN 0 THEN 'Everyone'
	 END AS [Routing]
	,CASE a.Internal 
		WHEN 1 THEN 'Internal'
		WHEN 0 THEN 'External'
	 END AS [Current Step]
	 ,CASE ISNULL(a.Pause,0)
		WHEN 1 THEN 'YES'
		WHEN 0 THEN 'NO'
	 END AS [Paused]
	 ,CASE a.LoginRequired
		WHEN 1 THEN 'YES'
		WHEN 0 THEN 'NO'
	 END AS [Login Required]
	 ,CASE a.AllApprove
		WHEN 1 THEN 'YES'
		WHEN 0 THEN 'NO'
	 END AS [Everyone Must Review]
	 ,CASE rd.Approved
		WHEN 1 THEN 'YES'
		WHEN 0 THEN 'NO'
	 END AS [Deliverable Approved]
	 ,rd.DueDate as [Date Due]
	 ,rd.ApprovedDate as [Date Approved]
	,r.DateSent AS [Date Sent]
	,Case When a.ActiveStep = 1 then a.ApproverStatus else
		Case When rd.Approved = 1 then 'Approved' else 'Rejected' end 
	 end as [Approval Status]
	,u.UserName as [Account Manager]
	,own.UserName as [Deliverable Owner]
	,Case p.Active When 1 Then 'YES' else 'NO' end as [Active Project]
	,cd.DivisionID as [Client Division ID]
    ,cd.DivisionName as [Client Division]
    ,cp.ProductID as [Client Product ID]
    ,cp.ProductName as [Client Product]
FROM tReviewDeliverable rd (NOLOCK)
	left outer join tProject p (NOLOCK) ON rd.ProjectKey = p.ProjectKey
	left outer join tCompany c (NOLOCK) on p.ClientKey = c.CompanyKey
	left outer join tReviewRound r (NOLOCK) ON rd.ReviewDeliverableKey = r.ReviewDeliverableKey AND r.LatestRound = 1
	left outer join tApprovalStep a (NOLOCK) ON a.EntityKey = r.ReviewRoundKey and a.Entity = 'tReviewRound' and a.ActiveStep = 1
	left outer join vUserName u (NOLOCK) on p.AccountManager = u.UserKey
	left outer join vUserName own (NOLOCK) on rd.OwnerKey = own.UserKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    left outer join tClientProduct  cp (nolock) on p.ClientProductKey  = cp.ClientProductKey
GO
