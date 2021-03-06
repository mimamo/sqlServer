USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteUpdateStatus]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptQuoteUpdateStatus]

	(
		@QuoteKey int,
		@NewStatus smallint
	)

AS --Encrypt

IF @NewStatus <= 2
	update tQuoteReply
	Set
		Status = 1
	Where
		QuoteKey = @QuoteKey

IF @NewStatus = 3
	Update tQuoteReply
	Set
		Status = 2
	Where
		QuoteKey = @QuoteKey

Update	tQuote
set		Status = @NewStatus
Where	QuoteKey = @QuoteKey
GO
