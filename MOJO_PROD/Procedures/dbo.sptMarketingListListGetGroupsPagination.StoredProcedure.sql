USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMarketingListListGetGroupsPagination]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMarketingListListGetGroupsPagination]
                (
                @CompanyKey INT,
                @MarketingListKey INT,
                @RowStart INT,
                @RowEnd INT
                )
AS --Encrypt

/*
|| When      Who Rel      What
|| 10/21/11  QMD 10.5.4.9 Created to push list to email marketing vendor
|| 10/21/11  QMD 10.5.6.2 Added ExternalMarketingKey
*/


CREATE TABLE #MarketingList(
	[MarketingListKey] [int] NOT NULL,
	[EntityKey] [varchar](150) NOT NULL,
	[DEFAULT_Email] [varchar](150) NOT NULL,
	[ExternalMarketingKey] [INT] NULL,
	[RowNumber] [int] NOT NULL Identity(1,1)
) 

INSERT INTO #MarketingList
SELECT  mll.MarketingListKey, 
            CASE Entity 
                            WHEN 'tUser' THEN 'U' +  CONVERT(VARCHAR(10), mll.EntityKey) 
                            WHEN 'tUserLead' THEN 'L' +  CONVERT(VARCHAR(10), mll.EntityKey) 
            END AS EntityKey, mm.DEFAULT_Email, mm.IGNORE_ExternalMarketingKey
FROM   tMarketingListList mll (nolock)
            INNER JOIN tMarketingList ml (nolock) ON mll.MarketingListKey = ml.MarketingListKey
            INNER JOIN vMailingMembers_EMMA mm (nolock) ON 
					CASE Entity 
						WHEN 'tUser' THEN 'U' +  CONVERT(VARCHAR(10), mll.EntityKey) 
						WHEN 'tUserLead' THEN 'L' +  CONVERT(VARCHAR(10), mll.EntityKey) 
					END = IGNORE_ALWAYS_MemberID
WHERE mll.Entity IN ('tUser', 'tUserLead')
            AND ml.CompanyKey = @CompanyKey
            AND ml.MarketingListKey = @MarketingListKey
            AND ISNULL(mm.DEFAULT_Email,'') <> ''
            AND ISNULL(mm.Do_Not_Email,0) = 0
            
SELECT	* 
FROM	#MarketingList
WHERE	RowNumber >= @RowStart
		AND RowNumber < @RowEnd
GO
