USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAPILogInsert]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAPILogInsert]
	@ApiLogKey VARCHAR(1000),
	@CompanyKey INT,
	@UserKey INT,
	@ApiAccessToken VARCHAR(2500),
	@UserToken VARCHAR(2500),
	@IP VARCHAR(500),
	@Path VARCHAR(500),
	@Verb VARCHAR(25),
	@Message VARCHAR(MAX),
	@IsResponse TINYINT
	
AS

/*
|| When      Who Rel      What
|| 05/02/14  QMD 10.5.7.9 Created to log API transactions
|| 12/09/14  QMD 10.5.8.7 Removed UserKey condition to update existing record based on key.
*/

	IF EXISTS (SELECT * FROM tApiLog (NOLOCK) WHERE ApiLogKey = @ApiLogKey)
		BEGIN
			IF (ISNULL(@IsResponse,0) = 1)
				UPDATE	tApiLog 
				SET		Response = ISNULL(Response,'') + ' ' + @Message, UserToken = @UserToken, IP = @IP, Verb = @Verb, CompanyKey = @CompanyKey, UserKey = @UserKey
				WHERE	ApiLogKey = @ApiLogKey
			ELSE 
				UPDATE	tApiLog
				SET		Request = ISNULL(Request,'') + ' ' + @Message, UserToken = @UserToken, IP = @IP, Verb = @Verb, CompanyKey = @CompanyKey, UserKey = @CompanyKey
				WHERE	ApiLogKey = @ApiLogKey
		END
	ELSE
		INSERT INTO tApiLog (ApiLogKey, CompanyKey, UserKey, ActionDate, IP, ApiAccessToken, UserToken, Path, Verb, Request) 
		VALUES (@ApiLogKey, @CompanyKey, @UserKey, GETUTCDATE (), @IP, @ApiAccessToken, @UserToken, @Path, @Verb, @Message)
GO
