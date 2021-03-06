USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteReplyUpdateStatus]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[sptQuoteReplyUpdateStatus]

	(
		@QuoteReplyKey int,
		@NewStatus smallint
	)

AS --Encrypt

	Update tQuoteReply
	Set Status = @NewStatus
	Where QuoteReplyKey = @QuoteReplyKey
GO
