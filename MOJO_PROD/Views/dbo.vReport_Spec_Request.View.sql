USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_Spec_Request]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  View [dbo].[vReport_Spec_Request]

As
/*
|| When      Who Rel      What
|| 6/13/13   WDF 10.5.6.9 (181051) Added 'Cancelled' to Status Case Statement
|| 07/22/14  GHL 10.5.8.2 (223349) Added Date Cancelled, Date Sent For Approval, Date Approved
*/

Select 
	r.CompanyKey
	,ss.CustomFieldKey
	,c.CustomerID as [Client ID]
	,c.CompanyName as [Client Name]
	,c.CustomerID + ' - ' + c.CompanyName as [Client ID and Name]
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
	,r.DateCompleted as [Date Completed]
	,u.FirstName + ' - ' + u.LastName as [Entered By]
	,r.RequestedBy as [Requested By]
	,r.NotifyEmail as [Email to Notify]
	,ss.Subject as [Spec Sheet Subject]
	,ss.Description as [Spec Sheet Description]
	,ss.DisplayOrder as [Spec Sheet Display Order]
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
	inner join tCompany c (nolock) on r.ClientKey = c.CompanyKey
	left outer join tUser u (nolock) on r.EnteredByKey = u.UserKey
	inner join (Select * from tSpecSheet (nolock) Where Entity = 'ProjectRequest') as ss on r.RequestKey = ss.EntityKey
GO
