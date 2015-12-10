USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavAttachmentSync]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavAttachmentSync]
	@CompanyKey int,
	@UserKey int,
	@UpdateAttachmentTable tinyint = 1 --If 0, it will only load up #tAttachment, but not update the tAttachment table
AS

/*
|| When      Who Rel      What
|| 10/25/11  CRG 10.5.4.9 Created
|| 6/18/12   CRG 10.5.5.7 Added the tVoucherDetail entity
|| 11/21/12  CRG 10.5.6.2 (160540) Fixed ApprovalItemReply entity
|| 12/25/12  CRG 10.5.6.3 Added the ExpenseReceipt entity
|| 5/7/13    CRG 10.5.6.8 (177457) Added tVoucher entity
|| 4/15/15   CRG 10.5.9.1 Added tJournalEntry entity
*/

/* Assume created in VB (only needed if @UpdateAttachmentTable = 1):
	CREATE TABLE #attList
		(AssociatedEntity varchar(50) NULL,
		EntityKey int NULL,
		FileName varchar(300) NULL,
		Path varchar(2000) NULL,
		AddAttachment tinyint NULL)
*/

	CREATE TABLE #tAttachment
		(AttachmentKey int NULL,
		AssociatedEntity varchar(50) NULL,
		EntityKey int NULL,
		AddedBy int NULL,
		FileName varchar(300) NULL,
		Path varchar(2000) NULL,
		DeleteAttachment tinyint NULL)

	-- ApprovalItem
	INSERT	#tAttachment
			(AttachmentKey,
			AssociatedEntity,
			EntityKey,
			AddedBy,
			FileName,
			Path)
	SELECT	a.AttachmentKey,
			a.AssociatedEntity,
			a.EntityKey,
			a.AddedBy,
			a.FileName,
			a.Path
	FROM	tAttachment a (nolock)
	INNER JOIN tApprovalItem ai (nolock) ON a.EntityKey = ai.ApprovalItemKey
	INNER JOIN tApproval app (nolock) ON ai.ApprovalKey = app.ApprovalKey
	INNER JOIN tProject p (nolock) ON app.ProjectKey = p.ProjectKey
	WHERE	a.AssociatedEntity = 'ApprovalItem'
	AND		p.CompanyKey = @CompanyKey

	-- ApprovalItemReply
	INSERT	#tAttachment
			(AttachmentKey,
			AssociatedEntity,
			EntityKey,
			AddedBy,
			FileName,
			Path)
	SELECT	a.AttachmentKey,
			a.AssociatedEntity,
			a.EntityKey,
			a.AddedBy,
			a.FileName,
			a.Path
	FROM	tAttachment a (nolock)
	INNER JOIN tApprovalItemReply air (nolock) ON a.EntityKey = air.ApprovalItemReplyKey
	INNER JOIN tApprovalItem ai (nolock) ON air.ApprovalItemKey = ai.ApprovalItemKey
	INNER JOIN tApproval app (nolock) ON ai.ApprovalKey = app.ApprovalKey
	INNER JOIN tProject p (nolock) ON app.ProjectKey = p.ProjectKey
	WHERE	a.AssociatedEntity = 'ApprovalItemReply'
	AND		p.CompanyKey = @CompanyKey

	-- Calendar
	INSERT	#tAttachment
			(AttachmentKey,
			AssociatedEntity,
			EntityKey,
			AddedBy,
			FileName,
			Path)
	SELECT	a.AttachmentKey,
			a.AssociatedEntity,
			a.EntityKey,
			a.AddedBy,
			a.FileName,
			a.Path
	FROM	tAttachment a (nolock)
	INNER JOIN tCalendar c (nolock) ON a.EntityKey = c.CalendarKey
	WHERE	a.AssociatedEntity = 'Calendar'
	AND		c.CompanyKey = @CompanyKey

	-- Forms
	INSERT	#tAttachment
			(AttachmentKey,
			AssociatedEntity,
			EntityKey,
			AddedBy,
			FileName,
			Path)
	SELECT	a.AttachmentKey,
			a.AssociatedEntity,
			a.EntityKey,
			a.AddedBy,
			a.FileName,
			a.Path
	FROM	tAttachment a (nolock)
	INNER JOIN tForm f (nolock) ON a.EntityKey = f.FormKey
	WHERE	a.AssociatedEntity = 'Forms'
	AND		f.CompanyKey = @CompanyKey

	-- Lead
	INSERT	#tAttachment
			(AttachmentKey,
			AssociatedEntity,
			EntityKey,
			AddedBy,
			FileName,
			Path)
	SELECT	a.AttachmentKey,
			a.AssociatedEntity,
			a.EntityKey,
			a.AddedBy,
			a.FileName,
			a.Path
	FROM	tAttachment a (nolock)
	INNER JOIN tLead l (nolock) ON a.EntityKey = l.LeadKey
	WHERE	a.AssociatedEntity = 'Lead'
	AND		l.CompanyKey = @CompanyKey

	-- Message
	INSERT	#tAttachment
			(AttachmentKey,
			AssociatedEntity,
			EntityKey,
			AddedBy,
			FileName,
			Path)
	SELECT	a.AttachmentKey,
			a.AssociatedEntity,
			a.EntityKey,
			a.AddedBy,
			a.FileName,
			a.Path
	FROM	tAttachment a (nolock)
	INNER JOIN tMessage m (nolock) ON a.EntityKey = m.MessageKey
	WHERE	a.AssociatedEntity = 'Message'
	AND		m.CompanyKey = @CompanyKey

	-- ExpenseReceipt
	INSERT	#tAttachment
			(AttachmentKey,
			AssociatedEntity,
			EntityKey,
			AddedBy,
			FileName,
			Path)
	SELECT	a.AttachmentKey,
			a.AssociatedEntity,
			a.EntityKey,
			a.AddedBy,
			a.FileName,
			a.Path
	FROM	tAttachment a (nolock)
	INNER JOIN tExpenseReceipt er (nolock) ON a.EntityKey = er.ExpenseReceiptKey
	INNER JOIN tExpenseEnvelope ee (nolock) ON er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
	WHERE	a.AssociatedEntity = 'ExpenseReceipt'
	AND		ee.CompanyKey = @CompanyKey

	-- ProjectNote (I think this is deprecated, but it doesn't hurt to do it)
	INSERT	#tAttachment
			(AttachmentKey,
			AssociatedEntity,
			EntityKey,
			AddedBy,
			FileName,
			Path)
	SELECT	a.AttachmentKey,
			a.AssociatedEntity,
			a.EntityKey,
			a.AddedBy,
			a.FileName,
			a.Path
	FROM	tAttachment a (nolock)
	INNER JOIN tProjectNote pn (nolock) ON a.EntityKey = pn.ProjectNoteKey
	WHERE	a.AssociatedEntity = 'ProjectNote'
	AND		pn.CompanyKey = @CompanyKey

	-- ProjectRequest
	INSERT	#tAttachment
			(AttachmentKey,
			AssociatedEntity,
			EntityKey,
			AddedBy,
			FileName,
			Path)
	SELECT	a.AttachmentKey,
			a.AssociatedEntity,
			a.EntityKey,
			a.AddedBy,
			a.FileName,
			a.Path
	FROM	tAttachment a (nolock)
	INNER JOIN tRequest r (nolock) ON a.EntityKey = r.RequestKey
	WHERE	a.AssociatedEntity = 'ProjectRequest'
	AND		r.CompanyKey = @CompanyKey

	-- QuoteReply
	INSERT	#tAttachment
			(AttachmentKey,
			AssociatedEntity,
			EntityKey,
			AddedBy,
			FileName,
			Path)
	SELECT	a.AttachmentKey,
			a.AssociatedEntity,
			a.EntityKey,
			a.AddedBy,
			a.FileName,
			a.Path
	FROM	tAttachment a (nolock)
	INNER JOIN tQuoteReply qr (nolock) ON a.EntityKey = qr.QuoteReplyKey
	INNER JOIN tQuote q (nolock) ON qr.QuoteKey = q.QuoteKey
	WHERE	a.AssociatedEntity = 'QuoteReply'
	AND		q.CompanyKey = @CompanyKey

	-- Quotes
	INSERT	#tAttachment
			(AttachmentKey,
			AssociatedEntity,
			EntityKey,
			AddedBy,
			FileName,
			Path)
	SELECT	a.AttachmentKey,
			a.AssociatedEntity,
			a.EntityKey,
			a.AddedBy,
			a.FileName,
			a.Path
	FROM	tAttachment a (nolock)
	INNER JOIN tQuote q (nolock) ON a.EntityKey = q.QuoteKey
	WHERE	a.AssociatedEntity = 'Quotes'
	AND		q.CompanyKey = @CompanyKey

	-- tActivity
	INSERT	#tAttachment
			(AttachmentKey,
			AssociatedEntity,
			EntityKey,
			AddedBy,
			FileName,
			Path)
	SELECT	a.AttachmentKey,
			a.AssociatedEntity,
			a.EntityKey,
			a.AddedBy,
			a.FileName,
			a.Path
	FROM	tAttachment a (nolock)
	INNER JOIN tActivity act (nolock) ON a.EntityKey = act.ActivityKey
	WHERE	a.AssociatedEntity = 'tActivity'
	AND		act.CompanyKey = @CompanyKey

	-- Task
	INSERT	#tAttachment
			(AttachmentKey,
			AssociatedEntity,
			EntityKey,
			AddedBy,
			FileName,
			Path)
	SELECT	a.AttachmentKey,
			a.AssociatedEntity,
			a.EntityKey,
			a.AddedBy,
			a.FileName,
			a.Path
	FROM	tAttachment a (nolock)
	INNER JOIN tTask t (nolock) ON a.EntityKey = t.TaskKey
	INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey
	WHERE	a.AssociatedEntity = 'Task'
	AND		p.CompanyKey = @CompanyKey

	-- Voucher Detail
	INSERT	#tAttachment
			(AttachmentKey,
			AssociatedEntity,
			EntityKey,
			AddedBy,
			FileName,
			Path)
	SELECT	a.AttachmentKey,
			a.AssociatedEntity,
			a.EntityKey,
			a.AddedBy,
			a.FileName,
			a.Path
	FROM	tAttachment a (nolock)
	INNER JOIN tVoucherDetail vd (nolock) ON a.EntityKey = vd.VoucherDetailKey
	INNER JOIN tVoucher v (nolock) ON vd.VoucherKey = v.VoucherKey
	WHERE	a.AssociatedEntity = 'tVoucherDetail'
	AND		v.CompanyKey = @CompanyKey

	INSERT	#tAttachment
			(AttachmentKey,
			AssociatedEntity,
			EntityKey,
			AddedBy,
			FileName,
			Path)
	SELECT	a.AttachmentKey,
			a.AssociatedEntity,
			a.EntityKey,
			a.AddedBy,
			a.FileName,
			a.Path
	FROM	tAttachment a (nolock)
	INNER JOIN tVoucher v (nolock) ON a.EntityKey = v.VoucherKey
	WHERE	a.AssociatedEntity = 'tVoucher'
	AND		v.CompanyKey = @CompanyKey
	
	INSERT	#tAttachment
			(AttachmentKey,
			AssociatedEntity,
			EntityKey,
			AddedBy,
			FileName,
			Path)
	SELECT	a.AttachmentKey,
			a.AssociatedEntity,
			a.EntityKey,
			a.AddedBy,
			a.FileName,
			a.Path
	FROM	tAttachment a (nolock)
	INNER JOIN tJournalEntry je (nolock) ON a.EntityKey = je.JournalEntryKey
	WHERE	a.AssociatedEntity = 'tJournalEntry'
	AND		je.CompanyKey = @CompanyKey

	IF @UpdateAttachmentTable = 0
	BEGIN
		SELECT	*
		FROM	#tAttachment

		RETURN 
	END

	--Mark items that are on the WebDAV server but not in the table for INSERT
	UPDATE	#attList
	SET		AddAttachment = 1
	WHERE	Path NOT IN
				(SELECT	ISNULL(Path, '')
				FROM	#tAttachment)

	--Mark items that are in the table but not on the WebDAV server for DELETE
	UPDATE	#tAttachment
	SET		DeleteAttachment = 1
	WHERE	Path NOT IN
				(SELECT	Path
				FROM	#attList)
	OR		Path IS NULL

	--Before inserting into tAttachment, make sure that all of the Entity/EntityKey records still exist
	DELETE	#attList
	WHERE	AssociatedEntity = 'ApprovalItem'
	AND		EntityKey NOT IN (SELECT ApprovalItemKey FROM tApprovalItem (nolock))

	DELETE	#attList
	WHERE	AssociatedEntity = 'ApprovalItemReply'
	AND		EntityKey NOT IN (SELECT ApprovalItemReplyKey FROM tApprovalItemReply (nolock))

	DELETE	#attList
	WHERE	AssociatedEntity = 'Calendar'
	AND		EntityKey NOT IN (SELECT CalendarKey FROM tCalendar (nolock))

	DELETE	#attList
	WHERE	AssociatedEntity = 'Forms'
	AND		EntityKey NOT IN (SELECT FormKey FROM tForm (nolock))

	DELETE	#attList
	WHERE	AssociatedEntity = 'Lead'
	AND		EntityKey NOT IN (SELECT LeadKey FROM tLead (nolock))

	DELETE	#attList
	WHERE	AssociatedEntity = 'Message'
	AND		EntityKey NOT IN (SELECT MessageKey FROM tMessage (nolock))

	DELETE	#attList
	WHERE	AssociatedEntity = 'ProjectNote'
	AND		EntityKey NOT IN (SELECT ProjectNoteKey FROM tProjectNote (nolock))

	DELETE	#attList
	WHERE	AssociatedEntity = 'ProjectRequest'
	AND		EntityKey NOT IN (SELECT RequestKey FROM tRequest (nolock))

	DELETE	#attList
	WHERE	AssociatedEntity = 'QuoteReply'
	AND		EntityKey NOT IN (SELECT QuoteReplyKey FROM tQuoteReply (nolock))

	DELETE	#attList
	WHERE	AssociatedEntity = 'Quotes'
	AND		EntityKey NOT IN (SELECT QuoteKey FROM tQuote (nolock))

	DELETE	#attList
	WHERE	AssociatedEntity = 'tActivity'
	AND		EntityKey NOT IN (SELECT ActivityKey FROM tActivity (nolock))

	DELETE	#attList
	WHERE	AssociatedEntity = 'Task'
	AND		EntityKey NOT IN (SELECT TaskKey FROM tTask (nolock))

	DELETE	#attList
	WHERE	AssociatedEntity = 'tVoucherDetail'
	AND		EntityKey NOT IN (SELECT VoucherDetailKey FROM tVoucherDetail (nolock))

	DELETE	#attList
	WHERE	AssociatedEntity = 'tVoucher'
	AND		EntityKey NOT IN (SELECT VoucherKey FROM tVoucher (nolock))
	
	DELETE	#attList
	WHERE	AssociatedEntity = 'tJournalEntry'
	AND		EntityKey NOT IN (SELECT JournalEntryKey FROM tJournalEntry (nolock))

	--Insert records marked for INSERT
	INSERT	tAttachment
			(AssociatedEntity,
			EntityKey,
			AddedBy,
			FileName,
			Path)
	SELECT	AssociatedEntity,
			EntityKey,
			@UserKey,
			FileName,
			Path
	FROM	#attList
	WHERE	AddAttachment = 1
	
	DELETE	tAttachment
	WHERE	AttachmentKey IN
				(SELECT	AttachmentKey
				FROM	#tAttachment
				WHERE	DeleteAttachment = 1)
GO
