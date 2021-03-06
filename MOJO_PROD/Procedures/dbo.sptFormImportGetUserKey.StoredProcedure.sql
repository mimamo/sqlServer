USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormImportGetUserKey]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptFormImportGetUserKey]

	(
		@CompanyKey int,
		@SystemID varchar(500)
	)

AS --Encrypt

Declare @UserKey int

	SELECT 
		@UserKey = ISNULL(UserKey, 0)
	FROM 
		tUser (nolock)
	WHERE 
		(CompanyKey = @CompanyKey OR 
		OwnerCompanyKey = @CompanyKey) AND 
	    UPPER(SystemID) = UPPER(@SystemID)
	    
	Return @UserKey
GO
