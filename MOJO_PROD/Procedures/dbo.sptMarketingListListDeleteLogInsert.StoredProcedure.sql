USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMarketingListListDeleteLogInsert]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMarketingListListDeleteLogInsert]
 @UserKey int,  
 @EntityKey int,   
 @Entity varchar(25),   
 @StoredProc varchar(50),  
 @ParameterList varchar(1500),  
 @Application varchar(50) = NULL  
AS  
  
/*  
|| When      Who Rel      What  
|| 03/01/10  QMD 10.5.1.9 Initial Release:  Proc used to insert into the MarketingListListDeleteLog table   
|| 08/05/10  QMD 10.5.3.3 Added companyKey logic based on entity
|| 11/14/12  QMD 10.5.6.2 Added ExternalMarketingKey
|| 01/16/14  QMD 10.5.7.6 (202464) If condition isn't needed around ExternalMarketingKey
*/  
 DECLARE @CompanyKey INT  
 DECLARE @ExternalMarketingKey INT
 
 SELECT @CompanyKey = CompanyKey FROM tUser (NOLOCK) WHERE UserKey = @UserKey  
 
IF UPPER(@Entity) = 'TUSER'
	SELECT @ExternalMarketingKey = ExternalMarketingKey FROM tUser (NOLOCK) WHERE UserKey = @EntityKey
IF UPPER(@Entity) = 'TUSERLEAD'
	SELECT @ExternalMarketingKey = ExternalMarketingKey FROM tUserLead (NOLOCK) WHERE UserLeadKey = @EntityKey
 	 
  -- Log Deletes  
    INSERT INTO tMarketingListListDeleteLog  
    SELECT ModifiedByKey = @UserKey,   
   ModifiedDate = GETUTCDATE(),  
   StoredProc = @StoredProc,  
   ParameterList = @ParameterList,  
   CompanyKey = @CompanyKey,  
   [Application] = @Application,     
   MarketingListKey,  
   Entity,  
   EntityKey,  
   DateAdded,
   ExternalMarketingKey = @ExternalMarketingKey
 FROM tMarketingListList (NOLOCK)  
 WHERE Entity = @Entity  
   AND EntityKey = @EntityKey
GO
