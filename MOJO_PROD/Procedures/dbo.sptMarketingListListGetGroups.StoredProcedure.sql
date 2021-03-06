USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMarketingListListGetGroups]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMarketingListListGetGroups]
                (
                @CompanyKey INT,
                @MarketingListKey INT
                )
AS --Encrypt

/*
|| When      Who Rel      What
|| 09/16/08  QMD 10.5.0.0 Created to push list to email marketing vendor
|| 10/14/09  MFT 10.5.1.3 Joined vMailingMembers_EMMA
|| 11/30/10  QMD 10.5.3.8 Added Do Not Email clause
|| 12/15/10  QMD 10.5.3.9 Added ISNULL to Do Not Email clause
|| 09/27/13  QMD 10.5.7.2 Added ExternalMarketingKey to select
*/

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
GO
