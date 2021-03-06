USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteReplyUserList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptQuoteReplyUserList]

	(
		@UserKey int
	)

AS --Encrypt

	Select q.QuoteKey, qr.QuoteReplyKey, q.Subject, q.DueDate
	From 
		tQuoteReply qr (nolock),
		tQuote q (nolock)
	Where
		qr.QuoteKey = q.QuoteKey and
		qr.ContactKey = @UserKey and
		q.Status = 2 and 
		qr.Status < 3
GO
