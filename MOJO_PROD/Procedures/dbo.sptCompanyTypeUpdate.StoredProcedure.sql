USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyTypeUpdate]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyTypeUpdate]
	@CompanyTypeKey int,
	@CompanyKey int,
	@CompanyTypeName varchar(50)

AS --Encrypt
  /*
  || When     Who Rel      What
  || 08/26/09 MAS 10.5.0.8 Added insert logic
  */


IF @CompanyTypeKey <=0 
BEGIN
		INSERT tCompanyType
			(
			CompanyKey,
			CompanyTypeName
			)

		VALUES
			(
			@CompanyKey,
			@CompanyTypeName
			)
	
		RETURN @@IDENTITY
	END	
ELSE
	BEGIN  
		UPDATE
			tCompanyType
		SET
			CompanyKey = @CompanyKey,
			CompanyTypeName = @CompanyTypeName
		WHERE
			CompanyTypeKey = @CompanyTypeKey 

		RETURN @CompanyTypeKey
	END
GO
