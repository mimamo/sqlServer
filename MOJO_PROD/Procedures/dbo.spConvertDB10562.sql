USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10562]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10562]
AS

	-- ApprovalItem
	UPDATE	tAttachment
	SET		CompanyKey = p.CompanyKey
	FROM	tAttachment a (nolock)
	INNER JOIN tApprovalItem ai (nolock) ON a.EntityKey = ai.ApprovalItemKey
	INNER JOIN tApproval app (nolock) ON ai.ApprovalKey = app.ApprovalKey
	INNER JOIN tProject p (nolock) ON app.ProjectKey = p.ProjectKey
	WHERE	a.AssociatedEntity = 'ApprovalItem'

	-- ApprovalItemReply
	UPDATE	tAttachment
	SET		CompanyKey = p.CompanyKey
	FROM	tAttachment a (nolock)
	INNER JOIN tApprovalItemReply air (nolock) ON a.EntityKey = air.ApprovalItemReplyKey
	INNER JOIN tApprovalItem ai (nolock) ON air.ApprovalItemKey = ai.ApprovalItemKey
	INNER JOIN tApproval app (nolock) ON ai.ApprovalKey = app.ApprovalKey
	INNER JOIN tProject p (nolock) ON app.ProjectKey = p.ProjectKey
	WHERE	a.AssociatedEntity = 'ApprovalItemReply'

	-- Calendar
	UPDATE	tAttachment
	SET		CompanyKey = c.CompanyKey
	FROM	tAttachment a (nolock)
	INNER JOIN tCalendar c (nolock) ON a.EntityKey = c.CalendarKey
	WHERE	a.AssociatedEntity = 'Calendar'

	--ExpenseReceipt
	UPDATE	tAttachment
	SET		CompanyKey = ee.CompanyKey
	FROM	tAttachment a (nolock)
	INNER JOIN tExpenseReceipt er (nolock) ON a.EntityKey = er.ExpenseReceiptKey
	INNER JOIN tExpenseEnvelope ee (nolock) ON er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
	WHERE	a.AssociatedEntity = 'ExpenseReceipt'

	-- Forms
	UPDATE	tAttachment
	SET		CompanyKey = f.CompanyKey
	FROM	tAttachment a (nolock)
	INNER JOIN tForm f (nolock) ON a.EntityKey = f.FormKey
	WHERE	a.AssociatedEntity = 'Forms'

	-- Lead
	UPDATE	tAttachment
	SET		CompanyKey = l.CompanyKey
	FROM	tAttachment a (nolock)
	INNER JOIN tLead l (nolock) ON a.EntityKey = l.LeadKey
	WHERE	a.AssociatedEntity = 'Lead'

	-- Message
	UPDATE	tAttachment
	SET		CompanyKey = m.CompanyKey
	FROM	tAttachment a (nolock)
	INNER JOIN tMessage m (nolock) ON a.EntityKey = m.MessageKey
	WHERE	a.AssociatedEntity = 'Message'

	-- ProjectNote (I think this is deprecated, but it doesn't hurt to do it)
	UPDATE	tAttachment
	SET		CompanyKey = pn.CompanyKey
	FROM	tAttachment a (nolock)
	INNER JOIN tProjectNote pn (nolock) ON a.EntityKey = pn.ProjectNoteKey
	WHERE	a.AssociatedEntity = 'ProjectNote'

	-- ProjectRequest
	UPDATE	tAttachment
	SET		CompanyKey = r.CompanyKey
	FROM	tAttachment a (nolock)
	INNER JOIN tRequest r (nolock) ON a.EntityKey = r.RequestKey
	WHERE	a.AssociatedEntity = 'ProjectRequest'

	-- QuoteReply
	UPDATE	tAttachment
	SET		CompanyKey = q.CompanyKey
	FROM	tAttachment a (nolock)
	INNER JOIN tQuoteReply qr (nolock) ON a.EntityKey = qr.QuoteReplyKey
	INNER JOIN tQuote q (nolock) ON qr.QuoteKey = q.QuoteKey
	WHERE	a.AssociatedEntity = 'QuoteReply'

	-- Quotes
	UPDATE	tAttachment
	SET		CompanyKey = q.CompanyKey
	FROM	tAttachment a (nolock)
	INNER JOIN tQuote q (nolock) ON a.EntityKey = q.QuoteKey
	WHERE	a.AssociatedEntity = 'Quotes'

	-- tActivity
	UPDATE	tAttachment
	SET		CompanyKey = act.CompanyKey
	FROM	tAttachment a (nolock)
	INNER JOIN tActivity act (nolock) ON a.EntityKey = act.ActivityKey
	WHERE	a.AssociatedEntity = 'tActivity'

	-- Task
	UPDATE	tAttachment
	SET		CompanyKey = p.CompanyKey
	FROM	tAttachment a (nolock)
	INNER JOIN tTask t (nolock) ON a.EntityKey = t.TaskKey
	INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey
	WHERE	a.AssociatedEntity = 'Task'

	-- Task Assignment
	UPDATE	tAttachment
	SET		CompanyKey = p.CompanyKey
	FROM	tAttachment a (nolock)
	INNER JOIN tTaskAssignment ta (nolock) ON a.EntityKey = ta.TaskAssignmentKey
	INNER JOIN tTask t (nolock) ON ta.TaskKey = t.TaskKey
	INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey
	WHERE	a.AssociatedEntity = 'TaskAssignment'

	-- tReviewComment
	UPDATE	tAttachment
	SET		CompanyKey = rd.CompanyKey
	FROM	tAttachment a (nolock)
	INNER JOIN tReviewComment rc (nolock) ON a.EntityKey = rc.ReviewCommentKey
	INNER JOIN tReviewRound rr (nolock) ON rc.ReviewRoundKey = rr.ReviewRoundKey
	INNER JOIN tReviewDeliverable rd (nolock) ON rr.ReviewDeliverableKey = rd.ReviewDeliverableKey
	WHERE	a.AssociatedEntity = 'tReviewComment'

	-- Voucher Detail
	UPDATE	tAttachment
	SET		CompanyKey = v.CompanyKey
	FROM	tAttachment a (nolock)
	INNER JOIN tVoucherDetail vd (nolock) ON a.EntityKey = vd.VoucherDetailKey
	INNER JOIN tVoucher v (nolock) ON vd.VoucherKey = v.VoucherKey
	WHERE	a.AssociatedEntity = 'tVoucherDetail'
GO
