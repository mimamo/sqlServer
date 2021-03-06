USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetTransfer]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGetTransfer]
AS --Encrypt

/*
  || When     Who Rel      What
  || 05/29/09 QMD 10.0.0   Initial Release
  || 09/04/09 QMD 10.5.0.8 Added LastModified AS DateUpdated So VB code doesn't have to change                   
  || 04/30/10 QMD 10.5.2.1 Added DateAdded    
  || 05/25/10 QMD 10.5.3.0 Added In Clause    
  || 09/28/10 QMD 10.5.3.5 Removed the password clause  
  || 10/13/10 QMD 10.5.3.6 Remove prjviewprojectreports - per Mike W 
						   Remove ISNULL(UserID,'') <> '' logic and replaced with OwnerCompanyKey IS NULL - per Mike W      
  || 10/29/10 QMD 10.5.3.7 Added link to tActivationLog - per Mike W 
  || 10/29/10 QMD 10.5.4.0 Added DateActivated and DateDeactived to select clause
  || 10/29/10 QMD 10.5.4.1 Changed rightID clause to include only gl_journalentry
*/
 

-- Administrators
SELECT	SecurityGroupHeader = 'admin', u.UserKey
INTO	#Admins
FROM	tUser u (NOLOCK)
WHERE	Administrator = 1
		AND OwnerCompanyKey IS NULL

-- Accounting
SELECT	SecurityGroupHeader = 'acct', u.UserKey
INTO	#Acct
FROM	tUser u (NOLOCK) INNER JOIN tSecurityGroup sg (NOLOCK) ON u.SecurityGroupKey = sg.SecurityGroupKey
			INNER JOIN tRightAssigned ra (NOLOCK) ON ra.EntityKey = sg.SecurityGroupKey
			INNER JOIN tRight r (NOLOCK) ON r.RightKey = ra.RightKey
WHERE	r.RightGroup = 'acct'
		AND u.Administrator = 0
		AND OwnerCompanyKey IS NULL
		AND NOT EXISTS (SELECT * FROM #Admins WHERE UserKey = u.UserKey)
GROUP BY UserKey

-- Project Administration
SELECT	SecurityGroupHeader = 'project', u.UserKey
INTO	#ProjAdmin
FROM	tUser u (NOLOCK) INNER JOIN tSecurityGroup sg (NOLOCK) ON u.SecurityGroupKey = sg.SecurityGroupKey
			INNER JOIN tRightAssigned ra (NOLOCK) ON ra.EntityKey = sg.SecurityGroupKey
			INNER JOIN tRight r (NOLOCK) ON r.RightKey = ra.RightKey
WHERE	r.RightGroup = 'project'
		AND u.Administrator = 0
		AND OwnerCompanyKey IS NULL
		AND NOT EXISTS (SELECT * FROM #Admins WHERE UserKey = u.UserKey)
		AND NOT EXISTS (SELECT * FROM #Acct WHERE UserKey = u.UserKey)
GROUP BY UserKey

-- Media/Traffic		
SELECT	SecurityGroupHeader = 'mediaTraffic', u.UserKey
INTO	#Media
FROM	tUser u (NOLOCK) INNER JOIN tSecurityGroup sg (NOLOCK) ON u.SecurityGroupKey = sg.SecurityGroupKey
			INNER JOIN tRightAssigned ra (NOLOCK) ON ra.EntityKey = sg.SecurityGroupKey
			INNER JOIN tRight r (NOLOCK) ON r.RightKey = ra.RightKey
WHERE	r.RightGroup IN ('media', 'traffic')
		AND u.Administrator = 0
		AND OwnerCompanyKey IS NULL
		AND NOT EXISTS (SELECT * FROM #Admins WHERE UserKey = u.UserKey)
		AND NOT EXISTS (SELECT * FROM #Acct WHERE UserKey = u.UserKey)
		AND NOT EXISTS (SELECT * FROM #ProjAdmin WHERE UserKey = u.UserKey) 
GROUP BY UserKey

-- MarketingAdmin
-- Remove prjviewprojectreports - per Mike W (10/13/2010)
-- Remove 'adminCreateProject', 'br_viewglfinancial', 'user_billing' - per Mike W (02/14/2011)
-- Added gl_journalentry - per Mike W email (02/14/2001)
SELECT	MarketingRight = 'marketingAdmin', u.UserKey
INTO	#MarketingAdmin
FROM	tUser u (NOLOCK) INNER JOIN tSecurityGroup sg (NOLOCK) ON u.SecurityGroupKey = sg.SecurityGroupKey
			INNER JOIN tRightAssigned ra (NOLOCK) ON ra.EntityKey = sg.SecurityGroupKey
			INNER JOIN tRight r (NOLOCK) ON r.RightKey = ra.RightKey
WHERE	r.RightID IN ('gl_journalentry')
		AND u.Administrator = 0
		AND OwnerCompanyKey IS NULL
GROUP BY UserKey

SELECT	u.UserKey, u.CompanyKey, u.FirstName, u.LastName, u.Phone1 as Phone, u.Title, u.Email, u.Administrator, 
		u.UserID, u.[Password], u.Active, c.CompanyName, p.ProductVersion, a.SecurityGroupHeader, u.LastModified AS DateUpdated, -- AS DateUpdated So VB code doesn't have to change
		u.DateAdded, ma.MarketingRight, al.DateActivated, MIN(al.DateDeactivated) AS DateDeactivated
FROM	tUser u (NOLOCK) INNER JOIN tCompany c (NOLOCK) ON u.CompanyKey = c.CompanyKey
			INNER JOIN tActivationLog al (NOLOCK) ON u.UserKey = al.UserKey 
			INNER JOIN tPreference p (NOLOCK) ON p.CompanyKey = c.CompanyKey
			LEFT JOIN ( SELECT * FROM #Admins
						UNION
						SELECT * FROM #Acct
						UNION
						SELECT * FROM #ProjAdmin
						UNION 
						SELECT * FROM #Media ) a ON u.UserKey = a.UserKey
			LEFT JOIN #MarketingAdmin ma ON u.UserKey = ma.UserKey 
WHERE	u.OwnerCompanyKey IS NULL
GROUP BY u.UserKey, u.CompanyKey, u.FirstName, u.LastName, u.Phone1, u.Title, u.Email, u.Administrator, 
		 u.UserID, u.[Password], u.Active, c.CompanyName, p.ProductVersion, a.SecurityGroupHeader, u.LastModified,
		 u.DateAdded, ma.MarketingRight,  al.DateActivated
ORDER BY u.CompanyKey
GO
