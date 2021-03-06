USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectGet2]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectGet2]
	@CompanyKey int,
	@UserKey int,
	@ProjectKey int = 0,
	@ProjectNumber varchar(50) = NULL
	

AS --Encrypt

/*
  || When       Who Rel      What
  || 03/17/14   MAS 10.5.7.8 Created for the 'New App' - copied from sptProjectGet
*/

Declare @RestrictGLCompany int



SELECT @RestrictGLCompany = isnull(RestrictToGLCompany, 0)
FROM   tPreference (NOLOCK)
WHERE  CompanyKey = @CompanyKey
		
IF @RestrictGLCompany = 0
	BEGIN
		IF @ProjectKey > 0
			SELECT p.ProjectKey  
			, p.ProjectName
			, p.ProjectNumber                                      
			, p.CompanyKey  
			, p.ClientKey                                                                                                                                                                                       
			, p.BillingContact 
			, p.Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
			, p.StartDate               
			, p.CompleteDate
			, p.PercComp
			, p.AccountManager                                                                                                                                                                                                                                           
			, p.GLCompanyKey 
			, p.ProjectCloseDate  
			, p.CustomFieldKey                                                                                                                                                                                                 
			, c.CustomerID as ClientID, c.CompanyName as ClientName
			, RTRIM(LTRIM(ISNULL(pc.FirstName,'') + ' ' + ISNULL(pc.LastName, ''))) as PrimaryContactName
			, pc.Phone1 as PrimaryContactPhone
			, pc.Email as PrimaryContactEmail
			, RTRIM(LTRIM(ISNULL(am.FirstName,'') + ' ' + ISNULL(am.LastName, ''))) as AccountManagerName
			, (Select COUNT(*) FROM tSpecSheet (NOLOCK) WHERE tSpecSheet.EntityKey = p.ProjectKey) as SpecSheetCount
			, (Select COUNT(*) from tReviewDeliverable (NOLOCK) Where ProjectKey = p.ProjectKey) as DeliverableCount
			FROM tProject p (NOLOCK)
			LEFT OUTER JOIN tCompany c (NOLOCK) on p.ClientKey = c.CompanyKey
			LEFT OUTER JOIN tUser am (NOLOCK) on am.UserKey = p.AccountManager
			LEFT OUTER JOIN tUser pc (nolock) ON pc.UserKey = p.BillingContact
  			WHERE ProjectKey = @ProjectKey 
  			AND p.CompanyKey = @CompanyKey
		ELSE
			SELECT p.ProjectKey  
			, p.ProjectName
			, p.ProjectNumber                                      
			, p.CompanyKey  
			, p.ClientKey                                                                                                                                                                                       
			, p.BillingContact 
			, p.Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
			, p.StartDate               
			, p.CompleteDate
			, p.PercComp
			, p.AccountManager                                                                                                                                                                                                                                           
			, p.GLCompanyKey 
			, p.ProjectCloseDate   
			, p.CustomFieldKey                                                                                                                                                                                                  
			, c.CustomerID as ClientID, c.CompanyName as ClientName
			, RTRIM(LTRIM(ISNULL(pc.FirstName,'') + ' ' + ISNULL(pc.LastName, ''))) as PrimaryContactName
			, pc.Phone1 as PrimaryContactPhone
			, pc.Email as PrimaryContactEmail
			, RTRIM(LTRIM(ISNULL(am.FirstName,'') + ' ' + ISNULL(am.LastName, ''))) as AccountManagerName
			, (Select COUNT(*) FROM tSpecSheet (NOLOCK) WHERE tSpecSheet.EntityKey = p.ProjectKey) as SpecSheetCount
			, (Select COUNT(*) from tReviewDeliverable (NOLOCK) Where ProjectKey = p.ProjectKey) as DeliverableCount
			FROM tProject p (NOLOCK)
			LEFT OUTER JOIN tCompany c (NOLOCK) on p.ClientKey = c.CompanyKey
			LEFT OUTER JOIN tUser am (NOLOCK) on am.UserKey = p.AccountManager
			LEFT OUTER JOIN tUser pc (nolock) ON pc.UserKey = p.BillingContact
			WHERE ProjectNumber = @ProjectNumber 
			AND p.CompanyKey = @CompanyKey 
	END
ELSE
	BEGIN
		IF @ProjectKey > 0
			SELECT p.ProjectKey  
			, p.ProjectName
			, p.ProjectNumber                                      
			, p.CompanyKey  
			, p.ClientKey                                                                                                                                                                                       
			, p.BillingContact 
			, p.Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
			, p.StartDate               
			, p.CompleteDate
			, p.PercComp
			, p.AccountManager                                                                                                                                                                                                                                           
			, p.GLCompanyKey 
			, p.ProjectCloseDate     
			, p.CustomFieldKey                                                                                                                                                                                                
			, c.CustomerID as ClientID, c.CompanyName as ClientName
			, RTRIM(LTRIM(ISNULL(pc.FirstName,'') + ' ' + ISNULL(pc.LastName, ''))) as PrimaryContactName
			, pc.Phone1 as PrimaryContactPhone
			, pc.Email as PrimaryContactEmail
			, RTRIM(LTRIM(ISNULL(am.FirstName,'') + ' ' + ISNULL(am.LastName, ''))) as AccountManagerName
			, (Select COUNT(*) FROM tSpecSheet (NOLOCK) WHERE tSpecSheet.EntityKey = p.ProjectKey) as SpecSheetCount
			, (Select COUNT(*) from tReviewDeliverable (NOLOCK) Where ProjectKey = p.ProjectKey) as DeliverableCount
			FROM tProject p (NOLOCK)
			JOIN tUserGLCompanyAccess glca (NOLOCK) on glca.GLCompanyKey = p.GLCompanyKey
			LEFT OUTER JOIN tCompany c (NOLOCK) on p.ClientKey = c.CompanyKey
			LEFT OUTER JOIN tUser am (NOLOCK) on am.UserKey = p.AccountManager
			LEFT OUTER JOIN tUser pc (nolock) ON pc.UserKey = p.BillingContact
  			WHERE ProjectKey = @ProjectKey 
  			AND p.CompanyKey = @CompanyKey
  			AND glca.UserKey = @UserKey
		ELSE
			SELECT p.ProjectKey  
			, p.ProjectName
			, p.ProjectNumber                                      
			, p.CompanyKey  
			, p.ClientKey                                                                                                                                                                                       
			, p.BillingContact 
			, p.Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
			, p.StartDate               
			, p.CompleteDate
			, p.PercComp
			, p.AccountManager                                                                                                                                                                                                                                           
			, p.GLCompanyKey 
			, p.ProjectCloseDate    
			, p.CustomFieldKey                                                                                                                                                                                                 
			, c.CustomerID as ClientID, c.CompanyName as ClientName
			, RTRIM(LTRIM(ISNULL(pc.FirstName,'') + ' ' + ISNULL(pc.LastName, ''))) as PrimaryContactName
			, pc.Phone1 as PrimaryContactPhone
			, pc.Email as PrimaryContactEmail
			, RTRIM(LTRIM(ISNULL(am.FirstName,'') + ' ' + ISNULL(am.LastName, ''))) as AccountManagerName
			, (Select COUNT(*) FROM tSpecSheet (NOLOCK) WHERE tSpecSheet.EntityKey = p.ProjectKey) as SpecSheetCount
			, (Select COUNT(*) from tReviewDeliverable (NOLOCK) Where ProjectKey = p.ProjectKey) as DeliverableCount
			FROM tProject p (NOLOCK)
			JOIN tUserGLCompanyAccess glca (NOLOCK) on glca.GLCompanyKey = p.GLCompanyKey
			LEFT OUTER JOIN tCompany c (NOLOCK) on p.ClientKey = c.CompanyKey
			LEFT OUTER JOIN tUser am (NOLOCK) on am.UserKey = p.AccountManager
			LEFT OUTER JOIN tUser pc (nolock) ON pc.UserKey = p.BillingContact
			WHERE ProjectNumber = @ProjectNumber 
			AND p.CompanyKey = @CompanyKey 
			AND glca.UserKey = @UserKey
	END	
		

RETURN 1
GO
