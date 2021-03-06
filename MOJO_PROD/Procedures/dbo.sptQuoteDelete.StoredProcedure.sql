USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteDelete]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQuoteDelete]
	@QuoteKey int

AS --Encrypt

	if exists(select 1 
		from 
			tPurchaseOrderDetail pod (nolock), 
			tQuoteReplyDetail qrd (nolock),
			tQuoteReply qr (nolock)
		Where
			pod.QuoteReplyDetailKey = qrd.QuoteReplyDetailKey and
			qrd.QuoteReplyKey = qr.QuoteReplyKey and
			qr.QuoteKey = @QuoteKey)
		return -1


	Delete 
	from
		tQuoteReplyDetail
	Where
		QuoteReplyKey in (Select QuoteReplyKey from tQuoteReply Where QuoteKey = @QuoteKey)

	Delete
	from	tQuoteReply
	Where	QuoteKey = @QuoteKey

	UPDATE tEstimateTaskExpense
	SET    tEstimateTaskExpense.QuoteDetailKey = NULL	
		FROM tEstimate e (NOLOCK) 
		    ,tQuoteDetail qd (NOLOCK) 
	WHERE  e.EstimateKey = tEstimateTaskExpense.EstimateKey
	AND    tEstimateTaskExpense.QuoteDetailKey = qd.QuoteDetailKey
	AND    e.ProjectKey = qd.ProjectKey
	AND    qd.QuoteKey = @QuoteKey

	Delete
	from	tQuoteDetail
	Where	QuoteKey = @QuoteKey
	
	delete tSpecSheetLink
	 where Entity = 'Est'
	   and EntityKey = @QuoteKey
	   	
	DELETE
	FROM tQuote
	WHERE
		QuoteKey = @QuoteKey 

	RETURN 1
GO
