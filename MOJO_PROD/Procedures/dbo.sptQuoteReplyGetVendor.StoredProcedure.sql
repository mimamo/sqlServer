USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteReplyGetVendor]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQuoteReplyGetVendor]

	@QuoteReplyKey int


AS --Encrypt

/*
|| When     Who Rel      What
|| 05/20/13 KMC 10.5.6.8 (178717) Created to retrieve a specific vendor from a quote
*/
		SELECT 
			qr.*,
			c.CompanyName,
			c.VendorID,
			u.FirstName + ' ' + u.LastName as ContactName,
			u.Email,
			'StatusName' =CASE qr.Status
				WHEN 1 THEN 'Reply Not Completed'
				WHEN 2 THEN 'Reply Not Finalized'
				WHEN 3 THEN 'Reply Completed'
			END,				
			(Select Sum(isnull(TotalCost, 0)) from tQuoteReplyDetail qrd (nolock) Where qrd.QuoteReplyKey = qr.QuoteReplyKey) as ReplyTotal,
			(Select Sum(isnull(TotalCost2, 0)) from tQuoteReplyDetail qrd (nolock) Where qrd.QuoteReplyKey = qr.QuoteReplyKey) as ReplyTotal2,
			(Select Sum(isnull(TotalCost3, 0)) from tQuoteReplyDetail qrd (nolock) Where qrd.QuoteReplyKey = qr.QuoteReplyKey) as ReplyTotal3,
			(Select Sum(isnull(TotalCost4, 0)) from tQuoteReplyDetail qrd (nolock) Where qrd.QuoteReplyKey = qr.QuoteReplyKey) as ReplyTotal4,
			(Select Sum(isnull(TotalCost5, 0)) from tQuoteReplyDetail qrd (nolock) Where qrd.QuoteReplyKey = qr.QuoteReplyKey) as ReplyTotal5,
			(Select Sum(isnull(TotalCost6, 0)) from tQuoteReplyDetail qrd (nolock) Where qrd.QuoteReplyKey = qr.QuoteReplyKey) as ReplyTotal6
			
		FROM 
			tQuoteReply qr (nolock)
			INNER JOIN tCompany c (nolock) on qr.VendorKey = c.CompanyKey 
			LEFT OUTER JOIN tUser u (nolock) on qr.ContactKey = u.UserKey 
		WHERE
			qr.QuoteReplyKey = @QuoteReplyKey
		ORDER BY
			qr.QuoteReplyNumber

	RETURN 1
GO
