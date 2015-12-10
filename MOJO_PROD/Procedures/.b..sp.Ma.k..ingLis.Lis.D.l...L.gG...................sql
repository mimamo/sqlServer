USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMarketingListListDeleteLogGet]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMarketingListListDeleteLogGet]
	@CompanyKey INT,
	@LastSync DATETIME
AS --Encrypt

  /*
  || When     Who Rel       What  
  || 03/02/10 QMD 10.5.1.9  Created Proc to retrieve the deleted contacts and leads 
  || 12/02/10 QMD 10.5.3.9  Added additional clause for MarketingMessage 
  || 04/08/11 QMD 10.5.4.3  Add OR Clause for DELETE temp tables 
  || 11/14/12 QMD 10.5.6.2  Added ExternalMarketingKey
  || 09/25/13 QMD 10.5.7.2  Added Not Exists logic
  || 03/17/15 QMD 10.5.9.0  Removed Action = 'E'
  */
SELECT	ulu.CompanyKey, Entity = 'tUserLead', EntityKey = UserLeadKey, ExternalMarketingKey = ulu.ExternalMarketingKey
INTO	#Deletes	
FROM	tUserLeadUpdateLog ulu (NOLOCK) INNER JOIN tMarketingListListDeleteLog mll (NOLOCK) ON ulu.UserLeadKey = mll.EntityKey AND mll.Entity = 'tUserLead'
WHERE	ulu.CompanyKey = @CompanyKey 
		AND (ulu.Action = 'D')
		AND ulu.ModifiedDate >= @LastSync
		AND NOT EXISTS (SELECT * FROM tUser (NOLOCK) WHERE OwnerCompanyKey = @CompanyKey AND ExternalMarketingKey = ulu.ExternalMarketingKey)

INSERT INTO #Deletes
SELECT	OwnerCompanyKey AS CompanyKey, Entity = 'tUser', EntityKey = UserKey, ExternalMarketingKey = u.ExternalMarketingKey
FROM	tUserUpdateLog u (NOLOCK) INNER JOIN tMarketingListListDeleteLog mll (NOLOCK) ON u.UserKey = mll.EntityKey AND mll.Entity = 'tUser'
WHERE	u.OwnerCompanyKey = @CompanyKey 
		AND (u.Action = 'D')
		AND u.ModifiedDate >= @LastSync

INSERT INTO #Deletes
SELECT	OwnerCompanyKey
		,CASE SUBSTRING (REPLACE(REPLACE(MarketingMessage,'The member id given is new to emma, but the email address already belongs to another member (id: ', ''), ')',''), 1 ,1)
			WHEN 'L' THEN 'tUserLead'
			WHEN 'U' THEN 'tUser'
		END AS Entity
		,SUBSTRING (REPLACE(REPLACE(MarketingMessage,'The member id given is new to emma, but the email address already belongs to another member (id: ', ''), ')',''), 2 ,10) AS EntityKey
		, ISNULL(tUser.ExternalMarketingKey,0)
FROM	tUser 
WHERE	ISNULL(MarketingMessage,'') <> ''
		AND MarketingMessage NOT LIKE 'Email exists under another remote id, send signal to merge if desired'
		AND MarketingMessage LIKE 'The member id given is new to emma, but the email address already belongs to another member%'		
ORDER BY LastModified

SELECT	CompanyKey, Entity, EntityKey,
		CASE Entity
			WHEN 'tUserLead' THEN 'L' + CONVERT(VARCHAR(10), EntityKey)
			WHEN 'tUser' THEN 'U' + CONVERT(VARCHAR(10), EntityKey)
		END AS MemberID, ExternalMarketingKey
FROM	#Deletes
GROUP BY CompanyKey, Entity, EntityKey, ExternalMarketingKey
GO
