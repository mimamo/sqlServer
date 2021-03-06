USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteVendorReplyGet]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptQuoteVendorReplyGet]

	(
		@QuoteKey int,
		@QuoteReplyKey int
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 08/10/11 RLB 10547  (118407) Added EstimateTaskExpense to update estimate 
*/
	
Select
	q.MultipleQty
	,q.Quote1
	,q.Quote2
	,q.Quote3
	,q.Quote4
	,q.Quote5
	,q.Quote6	
	,qd.*
	,qrd.*
	,(Select FieldSetKey from tObjectFieldSet ofs (nolock) Where ofs.ObjectFieldSetKey = qd.CustomFieldKey) as FieldSetKey
	,ete.EstimateTaskExpenseKey
From
	tQuoteDetail qd (nolock)
		inner join tQuote q (nolock) on q.QuoteKey = qd.QuoteKey 
		left outer join tQuoteReplyDetail qrd (nolock) on qrd.QuoteDetailKey = qd.QuoteDetailKey and qrd.QuoteReplyKey = @QuoteReplyKey
		left outer join tEstimateTaskExpense ete (nolock) on qd.QuoteDetailKey = ete.QuoteDetailKey 
Where
	qd.QuoteKey = @QuoteKey
Order By qd.LineNumber
GO
