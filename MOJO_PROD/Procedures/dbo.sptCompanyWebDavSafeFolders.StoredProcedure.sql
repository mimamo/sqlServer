USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyWebDavSafeFolders]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyWebDavSafeFolders]
	@CompanyKey int,
	@SelectValues tinyint = 1 --If 0, the query at the end will not run
AS 

/*
|| When      Who Rel      What
|| 10/5/12   CRG 10.5.6.1 Created to set the safe WebDAV folder names
*/

	DECLARE	@OwnerCompanyKey int,
			@SafeFolder varchar(200),
			@CustomerID varchar(50),
			@CompanyName varchar(200)

	SELECT	@OwnerCompanyKey = OwnerCompanyKey,
			@CustomerID = CustomerID,
			@CompanyName = CompanyName
	FROM	tCompany (nolock)
	WHERE	CompanyKey = @CompanyKey  
 
	SELECT @SafeFolder = dbo.fSafeWebDavFolder(@CustomerID, 1)
 
	WHILE(1=1)
	BEGIN
		IF NOT EXISTS
			(SELECT 1
			FROM	tCompany (nolock)
			WHERE	OwnerCompanyKey = @OwnerCompanyKey
			AND		UPPER(WebDavClientID) = UPPER(@SafeFolder)
			AND		CompanyKey <> @CompanyKey)
		BEGIN
			UPDATE	tCompany
			SET		WebDavClientID = @SafeFolder,
					WebDavCompanyName = dbo.fSafeWebDavFolder(@CompanyName, 0)
			WHERE	CompanyKey = @CompanyKey
   
			BREAK --Exit the loop
		END
  
		IF LEN(@SafeFolder) >= 100
			BREAK

		SELECT @SafeFolder = ISNULL(@SafeFolder, '') + '_'
	END
 
	IF @SelectValues = 1
		SELECT	WebDavClientID, WebDavCompanyName
		FROM	tCompany (nolock)
		WHERE	CompanyKey = @CompanyKey
GO
