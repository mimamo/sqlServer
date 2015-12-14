USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavServerUpdate]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavServerUpdate]
	@WebDavServerKey int,
	@CompanyKey int,
	@Type smallint,
	@URL varchar(1000),
	@DefaultServer tinyint,
	@Name varchar(200),
	@RootPath varchar(1000),
	@UserID varchar(50),
	@Password varchar(1000),
	@SetPassword tinyint,
	@AuthToken varchar(1000)
AS

/*
|| When      Who Rel      What
|| 9/23/11   CRG 10.5.4.8 Created
|| 3/6/12    CRG 10.5.5.4 Added @Type
|| 3/8/12    CRG 10.5.5.4 Added @Name
|| 3/9/12    CRG 10.5.5.4 Now saving NULL for URL if the Type is not WMJ
|| 4/19/12   CRG 10.5.5.5 Added @RootPath
|| 12/11/12  CRG 10.5.6.3 Added Type = 3 in URL check
|| 12/18/12  CRG 10.5.6.3 Added UserID, Password and AuthToken
|| 2/26/13   CRG 10.5.6.5 Now validating that the Name is unique in the entire table
|| 3/19/13   CRG 10.5.6.6 Now updating AuthToken for Amazon type servers
|| 4/25/13   CRG 10.5.7.8 Now saving the URL for Amazon type servers
|| 
*/

	IF ISNULL(@Type, 0) IN (0, 3, 4)
	BEGIN
		IF LTRIM(RTRIM(ISNULL(@URL, ''))) = ''
			RETURN -1
			
		IF @Type = 4 --Amazon
		BEGIN
			IF @URL LIKE 'http://%'
				SELECT @URL = SUBSTRING(@URL, 8, LEN(@URL) - 7)
			IF @URL LIKE 'https://%'
				SELECT @URL = SUBSTRING(@URL, 9, LEN(@URL) - 8)
		END
	END
	ELSE
		SELECT @URL = NULL

	IF ISNULL(@Name, '') <> ''
	BEGIN
		IF EXISTS (SELECT NULL FROM tWebDavServer (nolock) WHERE WebDavServerKey <> @WebDavServerKey AND UPPER([Name]) = UPPER(@Name))
			RETURN -2
	END

	IF @WebDavServerKey > 0
	BEGIN
		UPDATE	tWebDavServer
		SET		URL = @URL,
				Type = @Type,
				Name = @Name,
				RootPath = @RootPath,
				UserID = @UserID
		WHERE	WebDavServerKey = @WebDavServerKey
	END
	ELSE
	BEGIN
		INSERT	tWebDavServer
				(CompanyKey,
				URL,
				Type,
				Name,
				RootPath,
				UserID)
		VALUES	(@CompanyKey,
				@URL,
				@Type,
				@Name,
				@RootPath,
				@UserID)

		SELECT @WebDavServerKey = @@IDENTITY
	END

	IF @SetPassword = 1
		UPDATE	tWebDavServer
		SET		Password = @Password
		WHERE	WebDavServerKey = @WebDavServerKey

	--Only set the AuthToken here if the Type is a generic WebDAV server
	IF @Type IN (3, 4)
		UPDATE	tWebDavServer
		SET		AuthToken = @AuthToken
		WHERE	WebDavServerKey = @WebDavServerKey

	IF @DefaultServer = 1
		UPDATE	tPreference
		SET		WebDavServerKey = @WebDavServerKey
		WHERE	CompanyKey = @CompanyKey

	RETURN @WebDavServerKey
GO
