USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteReplyChangeStatus]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptQuoteReplyChangeStatus]

	(
		@QuoteReplyKey int,
		@NewStatus smallint
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 11/19/10 RLB 10538  (94513) Change made for enhancement
*/

Declare @QuoteKey int
Declare @MinStatus int

Update tQuoteReply
Set
	Status = @NewStatus
Where
	QuoteReplyKey = @QuoteReplyKey
	
Select @QuoteKey = QuoteKey from tQuoteReply (NOLOCK) Where QuoteReplyKey = @QuoteReplyKey

Select @MinStatus = min(Status) from tQuoteReply (NOLOCK) Where QuoteKey = @QuoteKey


If @NewStatus = 3
	Update tQuote
	Set Status = 4
	where QuoteKey = @QuoteKey

If @MinStatus = 1
	Update tQuote
	Set Status = 2
	where QuoteKey = @QuoteKey

IF @MinStatus = 3
	Update tQuote
	Set Status = 3
	Where QuoteKey = @QuoteKey
GO
