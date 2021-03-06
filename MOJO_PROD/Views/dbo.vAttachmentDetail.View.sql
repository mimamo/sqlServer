USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vAttachmentDetail]    Script Date: 12/21/2015 16:17:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  View [dbo].[vAttachmentDetail]

AS


select
	l.CompanyKey,
	a.AttachmentKey
From
	tAttachment a (nolock)
	Inner join tQuote l (nolock) on a.EntityKey = l.QuoteKey
Where
	a.AssociatedEntity = 'Quotes'


UNION ALL


select
	p.CompanyKey,
	a.AttachmentKey
From
	tAttachment a (nolock)
	Inner join tTask l (nolock) on a.EntityKey = l.TaskKey
	inner join tProject p (nolock) on p.ProjectKey = l.ProjectKey
Where
	a.AssociatedEntity = 'Task'


UNION ALL


select
	l.CompanyKey,
	a.AttachmentKey
From
	tAttachment a (nolock)
	Inner join tActivity l (nolock) on a.EntityKey = l.ActivityKey
Where
	a.AssociatedEntity = 'tActivity'



UNION ALL


select
	q.CompanyKey,
	a.AttachmentKey
From
	tAttachment a (nolock)
	Inner join tQuoteReply l (nolock) on a.EntityKey = l.QuoteReplyKey
	Inner join tQuote q (nolock) on l.QuoteKey = q.QuoteKey
Where
	a.AssociatedEntity = 'QuoteReply'



UNION ALL


select
	l.CompanyKey,
	a.AttachmentKey
From
	tAttachment a (nolock)
	Inner join tCalendar l (nolock) on a.EntityKey = l.CalendarKey
Where
	a.AssociatedEntity = 'Calendar'



UNION ALL


select
	p.CompanyKey,
	a.AttachmentKey
From
	tAttachment a (nolock)
	Inner join tApprovalItem l (nolock) on a.EntityKey = l.ApprovalItemKey
	Inner join tApproval app (nolock) on l.ApprovalKey = app.ApprovalKey
	inner join tProject p (nolock) on app.ProjectKey = p.ProjectKey
Where
	a.AssociatedEntity = 'ApprovalItem'




UNION ALL


select
	l.CompanyKey,
	a.AttachmentKey
From
	tAttachment a (nolock)
	Inner join tRequest l (nolock) on a.EntityKey = l.RequestKey
Where
	a.AssociatedEntity = 'ProjectRequest'



UNION ALL


select
	p.CompanyKey,
	a.AttachmentKey
From
	tAttachment a (nolock)
	Inner join tApprovalItemReply l (nolock) on a.EntityKey = l.ApprovalItemReplyKey
	Inner join tApprovalItem ai (nolock) on l.ApprovalItemKey = ai.ApprovalItemKey
	Inner join tApproval app (nolock) on ai.ApprovalKey = app.ApprovalKey
	inner join tProject p (nolock) on app.ProjectKey = p.ProjectKey
Where
	a.AssociatedEntity = 'ApprovalItemReply'




UNION ALL


select
	l.CompanyKey,
	a.AttachmentKey
From
	tAttachment a (nolock)
	Inner join tForm l (nolock) on a.EntityKey = l.FormKey
Where
	a.AssociatedEntity = 'Forms'




UNION ALL


select
	l.CompanyKey,
	a.AttachmentKey
From
	tAttachment a (nolock)
	Inner join tLead l (nolock) on a.EntityKey = l.LeadKey
Where
	a.AssociatedEntity = 'Lead'
GO
