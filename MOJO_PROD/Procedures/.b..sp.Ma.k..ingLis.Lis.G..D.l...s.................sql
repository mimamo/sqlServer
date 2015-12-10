USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMarketingListListGetDeletes]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMarketingListListGetDeletes]
	@CompanyKey INT,
	@MarketingListKey INT
AS --Encrypt

  /*
  || When     Who Rel       What  
  || 03/02/10 QMD 10.5.1.9  Created Proc to retrieve the deleted contacts and leads from marketing groups
  || 11/14/12 QMD 10.5.6.2  Added ExternalMarketingKey
  || 01/16/14 QMD 10.5.7.6  Added ExternalMarketingKey is not null clause
  */

DECLARE @LastSync DATETIME 

SELECT @LastSync = LastSync FROM tMailingSetup (NOLOCK) WHERE CompanyKey = @CompanyKey

SELECT	CompanyKey, Entity, EntityKey, ExternalMarketingKey
INTO	#Deletes
FROM	tMarketingListListDeleteLog	mlld
WHERE	CompanyKey = @CompanyKey
		AND NOT EXISTS (SELECT * FROM tMarketingListList 
						WHERE MarketingListKey = mlld.MarketingListKey AND Entity = mlld.Entity AND EntityKey = mlld.EntityKey)
		AND ModifiedDate >= @LastSync
		AND MarketingListKey = @MarketingListKey

INSERT INTO #Deletes
SELECT	CompanyKey, 'tUserLead', ul.UserLeadKey, ul.ExternalMarketingKey
FROM	tUserLead ul
WHERE	CompanyKey = @CompanyKey
		AND EXISTS (SELECT * FROM tMarketingListList 
						WHERE MarketingListKey = @MarketingListKey AND Entity = 'tUserLead' AND EntityKey = ul.UserLeadKey)
		AND ul.Active = 0

INSERT INTO #Deletes		
SELECT	OwnerCompanyKey, 'tUser', u.UserKey, u.ExternalMarketingKey
FROM	tUser u
WHERE	OwnerCompanyKey = @CompanyKey
		AND EXISTS (SELECT * FROM tMarketingListList 
						WHERE MarketingListKey = @MarketingListKey AND Entity = 'tUser' AND EntityKey = u.UserKey)
		AND u.Active = 0		


SELECT	CompanyKey, Entity,
		CASE Entity
			WHEN 'tUserLead' THEN 'L' + CONVERT(VARCHAR(10), EntityKey)
			WHEN 'tUser' THEN 'U' + CONVERT(VARCHAR(10), EntityKey)
		END AS EntityKey,
		ExternalMarketingKey
FROM	#Deletes
WHERE	ExternalMarketingKey IS NOT NULL
GROUP BY CompanyKey, Entity, EntityKey, ExternalMarketingKey
GO
