USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteDetailDelete]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQuoteDetailDelete]
	@QuoteDetailKey int

AS --Encrypt

Declare @QuoteKey int

	if exists(select 1 
		from 
			tPurchaseOrderDetail pod (nolock), 
			tQuoteReplyDetail qrd (nolock),
			tQuoteDetail qd (nolock)
		Where
			pod.QuoteReplyDetailKey = qrd.QuoteReplyDetailKey and
			qrd.QuoteDetailKey = qd.QuoteDetailKey and
			qd.QuoteDetailKey = @QuoteDetailKey)
		return -1

	Select @QuoteKey from tQuoteDetail (NOLOCK) Where QuoteDetailKey = @QuoteDetailKey

	Delete from tQuoteReplyDetail Where QuoteDetailKey = @QuoteDetailKey

	UPDATE tEstimateTaskExpense
	SET    tEstimateTaskExpense.QuoteDetailKey = NULL	
		FROM tEstimate e (NOLOCK) 
		    ,tQuoteDetail qd (NOLOCK) 
	WHERE  tEstimateTaskExpense.QuoteDetailKey = @QuoteDetailKey
	AND    e.EstimateKey = tEstimateTaskExpense.EstimateKey
	AND    tEstimateTaskExpense.QuoteDetailKey = qd.QuoteDetailKey
	AND    e.ProjectKey = qd.ProjectKey
	
	DELETE
	FROM tQuoteDetail
	WHERE
		QuoteDetailKey = @QuoteDetailKey 

	RETURN 1

	exec sptQuoteUpdateStatus @QuoteKey, 1
GO
