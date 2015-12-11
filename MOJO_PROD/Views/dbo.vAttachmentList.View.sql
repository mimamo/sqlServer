USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vAttachmentList]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vAttachmentList]
AS

/*
|| When      Who Rel      What
|| 11/29/12  CRG 10.5.6.2 Added in Message, ProjectNote, TaskAssignment, tReviewComment, and tVoucherDetail entities
||                        Added AssociatedEntity column and changed CompanyKey to always come from tAttachment now
|| 06/19/14  CRG 10.5.8.0 Added tCCEntry and JournalEntry
*/

SELECT	a.AttachmentKey, 'Quotes' as Entity, a.EntityKey, u.UserName, a.FileName, a.Comments, 
	CAST(q.QuoteNumber as varchar) as ItemDesc, a.CompanyKey, a.AssociatedEntity
FROM	tAttachment a (NOLOCK)
INNER JOIN tQuote q (NOLOCK) ON a.EntityKey = q.QuoteNumber
LEFT JOIN vUserName u ON a.AddedBy = u.UserKey
WHERE	a.AssociatedEntity = 'Quotes'

UNION ALL

--Use 'Quotes' as the entity so it's grouped together with  the quotes.
SELECT	a.AttachmentKey, 'Quotes', a.EntityKey, u.UserName, a.FileName, a.Comments, 
	ISNULL(CAST(q.QuoteNumber as varchar),'') + '/Reply: ' + ISNULL(CAST(qr.QuoteReplyNumber as varchar),''), a.CompanyKey, a.AssociatedEntity
FROM	tAttachment a (NOLOCK)
INNER JOIN tQuoteReply qr (NOLOCK) ON a.EntityKey = qr.QuoteReplyKey
INNER JOIN tQuote q (NOLOCK) ON qr.QuoteKey = q.QuoteKey
LEFT JOIN vUserName u ON a.AddedBy = u.UserKey
WHERE	a.AssociatedEntity = 'QuoteReply'

UNION ALL

SELECT	a.AttachmentKey, 'Tasks', a.EntityKey, u.UserName, a.FileName, a.Comments, 
	CASE
		WHEN t.TaskID IS NULL THEN t.TaskName
		ELSE ISNULL(t.TaskID,'') + ' - ' + ISNULL(t.TaskName,'')
	END, 
	a.CompanyKey, a.AssociatedEntity
FROM	tAttachment a (NOLOCK)
INNER JOIN tTask t (NOLOCK) ON a.EntityKey = t.TaskKey
INNER JOIN tProject p ON t.ProjectKey = p.ProjectKey
LEFT JOIN vUserName u ON a.AddedBy = u.UserKey
WHERE	a.AssociatedEntity = 'Task'

UNION ALL

SELECT	a.AttachmentKey, 'Activities', a.EntityKey, u.UserName, a.FileName, a.Comments, 
	ISNULL(u2.UserName,'') + ' on ' + ISNULL(CAST(act.DateAdded as varchar),''), a.CompanyKey, a.AssociatedEntity
FROM	tAttachment a (NOLOCK)
INNER JOIN tActivity act (NOLOCK) ON a.EntityKey = act.ActivityKey
LEFT JOIN vUserName u2 ON act.AddedByKey = u2.UserKey
LEFT JOIN vUserName u ON a.AddedBy = u.UserKey
WHERE	a.AssociatedEntity = 'tActivity'

UNION ALL

SELECT	a.AttachmentKey, 'Events', a.EntityKey, u.UserName, a.FileName, a.Comments, 
	c.Subject, a.CompanyKey, a.AssociatedEntity
FROM	tAttachment a (NOLOCK)
INNER JOIN tCalendar c (NOLOCK) ON a.EntityKey = c.CalendarKey
LEFT JOIN vUserName u ON a.AddedBy = u.UserKey
WHERE	a.AssociatedEntity = 'Calendar'

UNION ALL

SELECT	a.AttachmentKey, 'Digital Art Review Items', a.EntityKey, u.UserName, a.FileName, a.Comments, 
	ai.ItemName, a.CompanyKey, a.AssociatedEntity
FROM	tAttachment a (NOLOCK)
INNER JOIN tApprovalItem ai (NOLOCK) ON a.EntityKey = ai.ApprovalItemKey
INNER JOIN tApproval app (NOLOCK) ON ai.ApprovalKey = app.ApprovalKey
INNER JOIN tProject p (NOLOCK) ON app.ProjectKey = p.ProjectKey
LEFT JOIN vUserName u ON a.AddedBy = u.UserKey
WHERE	a.AssociatedEntity = 'ApprovalItem'

UNION ALL

SELECT	a.AttachmentKey, 'Digital Art Review Items', a.EntityKey, u.UserName, a.FileName, a.Comments, 
	ISNULL(ai.ItemName,'') + '/Reply: ' + ISNULL(CAST(air.DateUpdated as varchar),''), a.CompanyKey, a.AssociatedEntity
FROM	tAttachment a (NOLOCK)
INNER JOIN tApprovalItemReply air (NOLOCK) ON a.EntityKey = air.ApprovalItemReplyKey
INNER JOIN tApprovalItem ai (NOLOCK) ON air.ApprovalItemKey = ai.ApprovalItemKey
INNER JOIN tApproval app (NOLOCK) ON ai.ApprovalKey = app.ApprovalKey
INNER JOIN tProject p (NOLOCK) ON app.ProjectKey = p.ProjectKey
LEFT JOIN vUserName u ON a.AddedBy = u.UserKey
WHERE	a.AssociatedEntity = 'ApprovalItemReply'

UNION ALL

SELECT	a.AttachmentKey, 'Project Requests', a.EntityKey, u.UserName, a.FileName, a.Comments, 
	CAST(r.RequestID as varchar), a.CompanyKey, a.AssociatedEntity
FROM	tAttachment a (NOLOCK)
INNER JOIN tRequest r (NOLOCK) ON a.EntityKey = r.RequestKey
LEFT JOIN vUserName u ON a.AddedBy = u.UserKey
WHERE	a.AssociatedEntity = 'ProjectRequest'

UNION ALL

SELECT	a.AttachmentKey, 'Forms', a.EntityKey, u.UserName, a.FileName, a.Comments, 
	CAST(f.FormNumber as varchar), a.CompanyKey, a.AssociatedEntity
FROM	tAttachment a (NOLOCK)
INNER JOIN tForm f (NOLOCK) ON a.EntityKey = f.FormKey
LEFT JOIN vUserName u ON a.AddedBy = u.UserKey
WHERE	a.AssociatedEntity = 'Forms'

UNION ALL

SELECT	a.AttachmentKey, 'Leads', a.EntityKey, u.UserName, a.FileName, a.Comments, 
	c.CompanyName, a.CompanyKey, a.AssociatedEntity
FROM	tAttachment a (NOLOCK)
INNER JOIN tLead l (NOLOCK) ON a.EntityKey = l.LeadKey
INNER JOIN tCompany c (NOLOCK) ON l.ContactCompanyKey = c.CompanyKey
LEFT JOIN vUserName u ON a.AddedBy = u.UserKey
WHERE	a.AssociatedEntity = 'Lead'

UNION ALL

SELECT	a.AttachmentKey, 'Expense Receipt', a.EntityKey, u.UserName, a.FileName, a.Comments, 
	c.CompanyName, a.CompanyKey, a.AssociatedEntity
FROM	tAttachment a (NOLOCK)
INNER JOIN tExpenseReceipt er (NOLOCK) ON a.EntityKey = er.ExpenseReceiptKey
INNER JOIN tExpenseEnvelope ee (NOLOCK) ON er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
INNER JOIN tCompany c (NOLOCK) ON ee.CompanyKey = c.CompanyKey
LEFT JOIN vUserName u ON a.AddedBy = u.UserKey
WHERE	a.AssociatedEntity = 'ExpenseReceipt'

UNION ALL

SELECT	a.AttachmentKey, 'Vendor Invoices', a.EntityKey, u.UserName, a.FileName, a.Comments, 
	c.CompanyName, a.CompanyKey, a.AssociatedEntity
FROM	tAttachment a (NOLOCK)
INNER JOIN tVoucher v (NOLOCK) ON a.EntityKey = v.VoucherKey
INNER JOIN tCompany c (NOLOCK) ON v.CompanyKey = c.CompanyKey
LEFT JOIN vUserName u ON a.AddedBy = u.UserKey
WHERE	a.AssociatedEntity = 'tVoucher'

UNION ALL

SELECT	a.AttachmentKey, 'Message', a.EntityKey, u.UserName, a.FileName, a.Comments, 
	m.Subject, a.CompanyKey, a.AssociatedEntity
FROM	tAttachment a (NOLOCK)
INNER JOIN tMessage m (NOLOCK) ON a.EntityKey = m.MessageKey
LEFT JOIN vUserName u ON a.AddedBy = u.UserKey
WHERE	a.AssociatedEntity = 'Message'

UNION ALL

SELECT	a.AttachmentKey, 'Project Notes', a.EntityKey, u.UserName, a.FileName, a.Comments, 
	ISNULL(p.ProjectNumber, '') + '-' + ISNULL(p.ProjectName, ''), a.CompanyKey, a.AssociatedEntity
FROM	tAttachment a (NOLOCK)
INNER JOIN tProjectNote pn (NOLOCK) ON a.EntityKey = pn.ProjectNoteKey
INNER JOIN tProject p (NOLOCK) ON pn.ProjectKey = p.ProjectKey
LEFT JOIN vUserName u ON a.AddedBy = u.UserKey
WHERE	a.AssociatedEntity = 'ProjectNote'

UNION ALL

SELECT	a.AttachmentKey, 'Task Assignment', a.EntityKey, u.UserName, a.FileName, a.Comments, 
	ISNULL(p.ProjectNumber, '') + '-' + ISNULL(p.ProjectName, ''), a.CompanyKey, a.AssociatedEntity
FROM	tAttachment a (NOLOCK)
INNER JOIN tTaskAssignment ta (NOLOCK) ON a.EntityKey = ta.TaskAssignmentKey
INNER JOIN tTask t (NOLOCK) ON ta.TaskKey = t.TaskKey
INNER JOIN tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
LEFT JOIN vUserName u ON a.AddedBy = u.UserKey
WHERE	a.AssociatedEntity = 'TaskAssignment'

UNION ALL

SELECT	a.AttachmentKey, 'Review Comment', a.EntityKey, u.UserName, a.FileName, a.Comments, 
	rd.DeliverableName, a.CompanyKey, a.AssociatedEntity
FROM	tAttachment a (NOLOCK)
INNER JOIN tReviewComment rc (NOLOCK) ON a.EntityKey = rc.ReviewCommentKey
INNER JOIN tReviewRound rr (NOLOCK) ON rc.ReviewRoundKey = rr.ReviewRoundKey
INNER JOIN tReviewDeliverable rd (NOLOCK) ON rr.ReviewDeliverableKey = rd.ReviewDeliverableKey
LEFT JOIN vUserName u ON a.AddedBy = u.UserKey
WHERE	a.AssociatedEntity = 'tReviewComment'

UNION ALL

SELECT	a.AttachmentKey, 'Vendor Invoice Lines', a.EntityKey, u.UserName, a.FileName, a.Comments, 
	v.InvoiceNumber, a.CompanyKey, a.AssociatedEntity
FROM	tAttachment a (NOLOCK)
INNER JOIN tVoucherDetail vd (NOLOCK) ON a.EntityKey = vd.VoucherDetailKey
INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
LEFT JOIN vUserName u ON a.AddedBy = u.UserKey
WHERE	a.AssociatedEntity = 'tVoucherDetail'

UNION ALL

SELECT	a.AttachmentKey, 'Credit Card', a.EntityKey, u.UserName, a.FileName, a.Comments, 
	cc.FITID, a.CompanyKey, a.AssociatedEntity
FROM	tAttachment a (NOLOCK)
INNER JOIN tCCEntry cc (NOLOCK) ON a.EntityKey = cc.CCEntryKey
LEFT JOIN vUserName u ON a.AddedBy = u.UserKey
WHERE	a.AssociatedEntity = 'tCCEntry'

UNION ALL

SELECT	a.AttachmentKey, 'Journal Entry', a.EntityKey, u.UserName, a.FileName, a.Comments, 
	je.JournalNumber, a.CompanyKey, a.AssociatedEntity
FROM	tAttachment a (NOLOCK)
INNER JOIN tJournalEntry je (NOLOCK) ON a.EntityKey = je.JournalEntryKey
LEFT JOIN vUserName u ON a.AddedBy = u.UserKey
WHERE	a.AssociatedEntity = 'tJournalEntry'
GO
