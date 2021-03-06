USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteSend]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptQuoteSend]

	(
		@QuoteKey int
	)

AS --Encrypt


Delete tQuoteReplyDetail from tQuoteDetail
Where
	tQuoteReplyDetail.QuoteDetailKey = tQuoteDetail.QuoteDetailKey and
	tQuoteDetail.QuoteKey = @QuoteKey
	

Insert Into tQuoteReplyDetail (QuoteReplyKey, QuoteDetailKey)
Select 
	qr.QuoteReplyKey,
	qd.QuoteDetailKey
from
	tQuote q (nolock),
	tQuoteDetail qd (nolock),
	tQuoteReply qr (nolock)
Where
	q.QuoteKey = qd.QuoteKey and
	q.QuoteKey = qr.QuoteKey and
	q.QuoteKey = @QuoteKey

Update tQuote
Set	Status = 2
Where QuoteKey = @QuoteKey
GO
