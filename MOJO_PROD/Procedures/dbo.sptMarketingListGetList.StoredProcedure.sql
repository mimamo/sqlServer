USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMarketingListGetList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMarketingListGetList]
	@CompanyKey int

AS --Encrypt

/*
|| When       Who Rel    What
|| 11/12/2009 MFT 10.513 Filtered out unmatched users/leads from the count fields
|| 10/27/2010 QMD 10.537 Added syncable counts
|| 12/15/2010 QMD 10.539 Added is null to Do Not Email
|| 09/27/2013 QMD 10.572 Added Group by u.Email to get distinct email addresses
*/

SELECT
	*,
	(
		SELECT COUNT(*)
		FROM tMarketingListList mll (nolock)
		INNER JOIN tUser u (nolock) ON EntityKey = UserKey AND Entity = 'tUser'
		WHERE ml.MarketingListKey = mll.MarketingListKey
	) AS UserCount,
	(
		SELECT COUNT(*)
		FROM tMarketingListList mll (nolock)
		INNER JOIN tUserLead u (nolock) ON EntityKey = UserLeadKey AND Entity = 'tUserLead'
		WHERE ml.MarketingListKey = mll.MarketingListKey
	) AS LeadCount,
	(
		SELECT COUNT(*)
		FROM	(
				SELECT u.Email
				FROM tMarketingListList mll (nolock)
				INNER JOIN tUser u (nolock) ON EntityKey = UserKey AND Entity = 'tUser'
				WHERE ml.MarketingListKey = mll.MarketingListKey
					AND ISNULL(u.DoNotEmail,0) = 0		
					AND ISNULL(u.Email,'') <> ''
					AND u.Active = 1
				GROUP BY u.Email
				) a
	) AS EmailMarketingUserCount,
	(
		SELECT COUNT(*)
		FROM tMarketingListList mll (nolock)
		INNER JOIN tUserLead u (nolock) ON EntityKey = UserLeadKey AND Entity = 'tUserLead'
		WHERE ml.MarketingListKey = mll.MarketingListKey
			  AND ISNULL(u.DoNotEmail,0) = 0
			  AND ISNULL(u.Email,'') <> ''
			  AND u.Active = 1
	) AS EmailMarketingLeadCount
FROM
	tMarketingList ml
WHERE
	CompanyKey = @CompanyKey
ORDER BY
	ListName

RETURN 1
GO
