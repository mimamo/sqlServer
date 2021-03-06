USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteReplyGetByLineItem]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQuoteReplyGetByLineItem]

	@QuoteKey int


AS --Encrypt

		SELECT 
			qrd.*,
			c.CompanyName,
			c.CompanyKey
		FROM
			tQuoteReply qr (nolock),
			tQuoteReplyDetail qrd (nolock),
			tCompany c (nolock)
		Where
			qrd.QuoteReplyKey = qr.QuoteReplyKey and
			qr.VendorKey = c.CompanyKey and
			qr.QuoteKey = @QuoteKey

	RETURN 1
GO
