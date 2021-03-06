USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteReplyDetailUpdate]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptQuoteReplyDetailUpdate]

	(
		@QuoteReplyKey int,
		@QuoteDetailKey int,
		@UnitCost money,
		@TotalCost money,
		@UnitCost2 money,
		@TotalCost2 money,
		@UnitCost3 money,
		@TotalCost3 money,
		@UnitCost4 money,
		@TotalCost4 money,
		@UnitCost5 money,
		@TotalCost5 money,
		@UnitCost6 money,
		@TotalCost6 money,

		@Comments varchar(1000)
	)

AS --Encrypt


Declare @QuoteReplyDetailKey int

Select @QuoteReplyDetailKey = QuoteReplyDetailKey
from tQuoteReplyDetail (NOLOCK) 
Where
	QuoteReplyKey = @QuoteReplyKey and
	QuoteDetailKey = @QuoteDetailKey
	
	
IF @QuoteReplyDetailKey IS NULL
	Insert tQuoteReplyDetail
	(
	QuoteReplyKey,
	QuoteDetailKey,
	Comments,
	UnitCost,
	TotalCost,
	UnitCost2,
	TotalCost2,
	UnitCost3,
	TotalCost3,
	UnitCost4,
	TotalCost4,
	UnitCost5,
	TotalCost5,
	UnitCost6,
	TotalCost6	
	)
	Values
	(
	@QuoteReplyKey,
	@QuoteDetailKey,
	@Comments,
	@UnitCost,
	@TotalCost,
	@UnitCost2,
	@TotalCost2,
	@UnitCost3,
	@TotalCost3,
	@UnitCost4,
	@TotalCost4,
	@UnitCost5,
	@TotalCost5,
	@UnitCost6,
	@TotalCost6
	)

Else
	Update tQuoteReplyDetail 
	Set 
		QuoteReplyKey = @QuoteReplyKey,
		QuoteDetailKey = @QuoteDetailKey,
		Comments = @Comments,
		UnitCost = @UnitCost,
		TotalCost = @TotalCost,
		UnitCost2 = @UnitCost2,
		TotalCost2 = @TotalCost2,
		UnitCost3 = @UnitCost3,
		TotalCost3 = @TotalCost3,
		UnitCost4 = @UnitCost4,
		TotalCost4 = @TotalCost4,
		UnitCost5 = @UnitCost5,
		TotalCost5 = @TotalCost5,
		UnitCost6 = @UnitCost6,
		TotalCost6 = @TotalCost6
		
	Where
		QuoteReplyDetailKey = @QuoteReplyDetailKey
GO
