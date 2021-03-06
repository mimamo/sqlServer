USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCardDavLogInsert]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCardDavLogInsert]
	@CardDavLogKey VARCHAR(1000),
	@UserKey INT,
	@IP VARCHAR(500),
	@Path VARCHAR(500),
	@Verb VARCHAR(25),
	@Message VARCHAR(MAX),
	@IsResponse TINYINT
	
AS

/*
|| When      Who Rel      What
|| 10/10/13  QMD 10.5.7.3 Created to log carddav transactions.  
*/

	IF EXISTS (SELECT * FROM tCardDavLog (NOLOCK) WHERE CardDavLogKey = @CardDavLogKey)
		BEGIN
			IF (ISNULL(@IsResponse,0) = 1)
				UPDATE	tCardDavLog 
				SET		Response = ISNULL(Response,'') + ' ' + @Message, UserKey = @UserKey, IP = @IP, Verb = @Verb
				WHERE	CardDavLogKey = @CardDavLogKey 
			ELSE 
				UPDATE	tCardDavLog
				SET		Request = ISNULL(Request,'') + ' ' + @Message, UserKey = @UserKey, IP = @IP, Verb = @Verb
				WHERE	CardDavLogKey = @CardDavLogKey				
		END
	ELSE
		INSERT INTO tCardDavLog (CardDavLogKey, ActionDate, IP, UserKey, Path, Verb, Request) 
		VALUES (@CardDavLogKey, GETUTCDATE (), @IP, @UserKey, @Path, @Verb, @Message)
GO
