USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteReplyGetDetail]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQuoteReplyGetDetail]
	@QuoteReplyKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 01/10/14 GHL 10.576  Added currency ID so that we can create a PO with the proper currency
*/

		SELECT 
			qr.QuoteReplyNumber,
			qr.VendorKey,
			qr.ContactKey,
			qr.SpecialComments,
			qr.Status as QuoteReplyStatus,
			q.*,
			c.CompanyName as VendorName,
			c.VendorID,
			u.Email,
			u.FirstName,
			u.LastName,
			vc.FirstName + ' ' + vc.LastName as ContactName,
			p.ProjectName,
			p.ProjectNumber,
			p.CurrencyID,
			(Select FieldSetKey from tObjectFieldSet ofs (nolock) Where ofs.ObjectFieldSetKey = q.CustomFieldKey) as FieldSetKey
		FROM	tQuoteReply qr (nolock)
		INNER JOIN tCompany c (nolock) ON qr.VendorKey = c.CompanyKey
		INNER JOIN tQuote q (nolock) ON qr.QuoteKey = q.QuoteKey
		LEFT JOIN tQuoteDetail qd (nolock) ON q.QuoteKey = qd.QuoteKey
		LEFT JOIN tProject p (nolock) ON qd.ProjectKey = p.ProjectKey
		LEFT JOIN tUser u (nolock) ON q.SendRepliesTo = u.UserKey
		LEFT JOIN tUser vc (nolock) ON qr.ContactKey = vc.UserKey
		WHERE qr.QuoteReplyKey = @QuoteReplyKey

	RETURN 1
GO
