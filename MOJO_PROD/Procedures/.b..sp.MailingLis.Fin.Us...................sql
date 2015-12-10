USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMailingListFindUser]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMailingListFindUser]
	@CompanyKey INT,
	@ExternalMarketingKey INT,
	@Email VARCHAR(50)

AS --Encrypt

/*
|| When      Who Rel      What
|| 11/16/12  QMD 10.5.6.2 Added for emma api change
*/
	DECLARE @Entity VARCHAR(25)
	DECLARE @EntityKey INT
		
	SELECT @Entity = 'tUser', @EntityKey = ISNULL(UserKey,0) FROM tUser (NOLOCK) WHERE OwnerCompanyKey = @CompanyKey AND ExternalMarketingKey = @ExternalMarketingKey AND Email = @Email		

	IF @EntityKey = 0 OR @EntityKey IS NULL
		SELECT @Entity = 'tUserLead', @EntityKey = ISNULL(UserLeadKey,0) FROM tUserLead (NOLOCK) WHERE CompanyKey = @CompanyKey AND ExternalMarketingKey = @ExternalMarketingKey AND UPPER(Email) = UPPER(@Email)

	SELECT @Entity AS Entity, @EntityKey AS EntityKey
GO
