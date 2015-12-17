USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Request]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    View [dbo].[vListing_Request]

As

/*
|| When       Who Rel       What
|| 07/02/14   QMD 10.5.8.1  (220667) Added Date Cancelled and Date Sent for Approval
|| 07/21/14   GHL 10.5.8.2  (223349) Added Date Approved
|| 03/25/15   WDF 10.5.9.0  (250961) Added [Created By],[Created Date],[Updated By] and [Updated Date]
*/

Select 
	 r.RequestKey
	,r.CompanyKey
	,r.ClientKey
	,r.CustomFieldKey
	,r.Subject as [Project Name]
	,r.ProjectDescription as [Project Description]
	,r.ClientProjectNumber as [Client Project Number]
	,r.DueDate as [Project Due Date]
	,c.CustomerID as [Client ID]
	,c.CompanyName as [Client Name]
	,c.CustomerID + ' - ' + c.CompanyName as [Client ID and Name]
	,c.ParentCompanyKey
	,rd.RequestName as [Request Type]
	,r.RequestID as [Request ID]
	,Case When r.DateCompleted is null then
		Case Status 
		When 1 then 
			Case r.Cancelled
				When 0 then 'Not Sent For Approval'
				When 1 then 'Cancelled'
				else 'Not Sent For Approval'
			end
		When 2 then 'Sent For Approval'
		When 3 then 'Rejected'
		When 4 then 'Approved'
		end
	 else
		'Completed' end as [Request Status]
	,r.DateAdded as [Date Added]
	,r.DateAdded as [Created Date]
	,r.DateCompleted as [Date Completed]
	,u.FirstName + ' ' + u.LastName as [Entered By]
	,u.FirstName + ' ' + u.LastName as [Created By]
	,u2.FirstName + ' ' + u2.LastName as [Updated By]
	,r.DateUpdated as [Updated Date]
	,r.RequestedBy as [Requested By]
	,r.NotifyEmail as [Email to Notify]
	,r.DateCancelled as [Date Cancelled]
	,r.DateSentForApproval as [Date Sent For Approval]
	, case when r.Status != 4 then Null
	else	
		(
		select MAX(asu.DateCompleted)
		from tApprovalStepUser asu (nolock)
		inner join tApprovalStep astep (nolock) on astep.ApprovalStepKey = asu.ApprovalStepKey 
		where astep.Entity = 'ProjectRequest'
		and astep.EntityKey = r.RequestKey
		and  asu.Action = 1 -- Approved by User
		and astep.Action = 2 -- The action on the Approval Step is Approve, not Notify
		)
	end as [Date Approved]
From
	tRequest r (nolock)
	inner join tRequestDef rd (nolock) on r.RequestDefKey = rd.RequestDefKey
	left outer join tCompany c (nolock) on r.ClientKey = c.CompanyKey
	left outer join tUser u (nolock) on r.EnteredByKey = u.UserKey
	left outer join tUser u2 (nolock) on r.UpdatedByKey = u2.UserKey
GO
