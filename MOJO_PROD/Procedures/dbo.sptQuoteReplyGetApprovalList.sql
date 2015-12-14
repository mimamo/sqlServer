USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteReplyGetApprovalList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQuoteReplyGetApprovalList]

	@UserKey int


AS --Encrypt

/*
|| When     Who Rel     What
|| 11/26/07 GHL 8.5      Removed *= joins for SQL 2005
|| 11/19/10 RLB 10538  (94513) Change made for enhancement
*/
		SELECT 
			q.QuoteNumber,
			q.SendRepliesTo,
			q.MultipleQty,
			q.Quote1,
			q.Quote2,
			q.Quote3,
			q.Quote4,
			q.Quote5,
			q.Quote6,						
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
			(Select Sum(TotalCost) from tQuoteReplyDetail qrd (nolock) Where qrd.QuoteReplyKey = qr.QuoteReplyKey) as ReplyTotal,
			(Select Sum(isnull(TotalCost2, 0)) from tQuoteReplyDetail qrd (nolock) Where qrd.QuoteReplyKey = qr.QuoteReplyKey) as ReplyTotal2,
			(Select Sum(isnull(TotalCost3, 0)) from tQuoteReplyDetail qrd (nolock) Where qrd.QuoteReplyKey = qr.QuoteReplyKey) as ReplyTotal3,
			(Select Sum(isnull(TotalCost4, 0)) from tQuoteReplyDetail qrd (nolock) Where qrd.QuoteReplyKey = qr.QuoteReplyKey) as ReplyTotal4,
			(Select Sum(isnull(TotalCost5, 0)) from tQuoteReplyDetail qrd (nolock) Where qrd.QuoteReplyKey = qr.QuoteReplyKey) as ReplyTotal5,
			(Select Sum(isnull(TotalCost6, 0)) from tQuoteReplyDetail qrd (nolock) Where qrd.QuoteReplyKey = qr.QuoteReplyKey) as ReplyTotal6

		FROM 
			tQuoteReply qr (nolock) 
			INNER JOIN tCompany c (nolock) ON qr.VendorKey = c.CompanyKey 
			LEFT OUTER JOIN tUser u (nolock) ON qr.ContactKey = u.UserKey
			INNER JOIN tQuote q (nolock) ON qr.QuoteKey = q.QuoteKey
		WHERE
			qr.ContactKey = @UserKey and
			qr.Status < 3
		ORDER BY
			q.QuoteNumber,
			qr.QuoteReplyNumber

	RETURN 1
GO
