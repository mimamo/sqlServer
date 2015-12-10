USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyGetForWebDav]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyGetForWebDav]
	@OwnerCompanyKey int,
	@ClientID varchar(50)
AS

/*
|| When      Who Rel      What
|| 11/5/12   CRG 10.5.6.2 Created to for the WebDAV verify folder name process in the conversion program
*/

	DECLARE	@CompanyKey int

	SELECT	@CompanyKey = CompanyKey
	FROM	tCompany (nolock)
	WHERE	OwnerCompanyKey = @OwnerCompanyKey
	AND		UPPER(WebDavClientID) = UPPER(@ClientID)

	IF @CompanyKey IS NULL
	BEGIN
		SELECT	@CompanyKey = CompanyKey
		FROM	tCompany (nolock)
		WHERE	OwnerCompanyKey = @OwnerCompanyKey
		AND		UPPER(CustomerID) = UPPER(@ClientID)

		IF @CompanyKey > 0
			EXEC sptCompanyWebDavSafeFolders @CompanyKey, 0
	END			

	SELECT	WebDavClientID, WebDavCompanyName
	FROM	tCompany (nolock)
	WHERE	CompanyKey = @CompanyKey
GO
