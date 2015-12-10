USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteReplyDelete]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQuoteReplyDelete]
	@QuoteReplyKey int

AS --Encrypt

Declare @QuoteKey int

	if exists(
		select 1 
		from 
			tPurchaseOrderDetail pod (nolock),
			tQuoteReplyDetail qrd (nolock)
		where
			qrd.QuoteReplyKey = @QuoteReplyKey and
			qrd.QuoteReplyDetailKey = pod.QuoteReplyDetailKey)
		return -1

	select 	@QuoteKey = QuoteKey
	from 	tQuoteReply (NOLOCK) 
	Where	QuoteReplyKey = @QuoteReplyKey 

	DELETE
	FROM tQuoteReplyDetail
	WHERE
		QuoteReplyKey = @QuoteReplyKey 

	DELETE
	FROM tQuoteReply
	WHERE
		QuoteReplyKey = @QuoteReplyKey 

	exec sptQuoteUpdateStatus @QuoteKey, 1

	RETURN 1
GO
