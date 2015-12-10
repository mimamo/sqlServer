USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteReplyGet]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQuoteReplyGet]
	@QuoteReplyKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 11/26/07 GHL 8.5      Removed *= joins for SQL 2005
*/
		SELECT 
			qr.*,
			u.Email,
			c.VendorID
		FROM 
			tQuoteReply qr (nolock)
			LEFT OUTER JOIN tUser u (nolock) ON qr.ContactKey = u.UserKey 
			LEFT OUTER JOIN tCompany c (nolock) ON qr.VendorKey = c.CompanyKey
		WHERE
			qr.QuoteReplyKey = @QuoteReplyKey 
			
	RETURN 1
GO
