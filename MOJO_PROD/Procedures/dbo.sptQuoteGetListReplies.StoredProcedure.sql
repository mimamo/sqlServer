USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteGetListReplies]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQuoteGetListReplies]

	@ProjectKey int


AS --Encrypt

		SELECT q.*, 
			(Select Count(*) from tQuoteReply qr (nolock) Where qr.QuoteKey = q.QuoteKey and qr.Status > 1) as Replies
		FROM tQuote q (nolock)
		WHERE
			ProjectKey = @ProjectKey and
			q.Status > 1
		Order By
			QuoteNumber

	RETURN 1
GO
