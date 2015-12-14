USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteReplyGetSetup]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQuoteReplyGetSetup]
	@QuoteKey int,
	@QuoteReplyKey int

AS --Encrypt

If not exists(Select 1 from tQuoteReply (NOLOCK) Where QuoteKey = @QuoteKey and QuoteReplyKey = @QuoteReplyKey)
	return -1


		SELECT 
			q.*,
			qr.VendorKey,
			c.CompanyName,
			p.StyleSheetKey,
			p.SmallLogo
		FROM 
			tQuoteReply qr (nolock),
			tPreference p (nolock),
			tCompany c (nolock),
			tQuote q (nolock)
		WHERE
			qr.QuoteKey = q.QuoteKey and
			q.CompanyKey = c.CompanyKey and
			c.CompanyKey = p.CompanyKey and
			q.QuoteKey = @QuoteKey

	RETURN 1
GO
