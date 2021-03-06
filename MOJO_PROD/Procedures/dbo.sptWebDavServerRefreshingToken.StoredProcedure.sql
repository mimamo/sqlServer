USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavServerRefreshingToken]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavServerRefreshingToken]
	@WebDavServerKey int,
	@RefreshingToken tinyint,
	@RefreshToken varchar(1000) OUTPUT
AS

/*
|| When      Who Rel      What
|| 11/5/13   CRG 10.5.7.4 Created
|| 8/27/14   CRG 10.5.8.3 Now, if it's been longer than 15 min. since the last refresh go ahead and request a new token.  Don't wait because it probably failed anyway.
*/

	BEGIN TRAN
	
	DECLARE	@CurrentRefreshingToken tinyint,
			@MinutesSinceRefresh int
	
	SELECT	@CurrentRefreshingToken = RefreshingToken,
			@RefreshToken = RefreshToken,
			@MinutesSinceRefresh = ISNULL(DATEDIFF(MI, ISNULL(AuthTokenDate, RefreshTokenDate), GETUTCDATE()), 0)
	FROM	tWebDavServer (nolock)
	WHERE	WebDavServerKey = @WebDavServerKey

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -2
	END
	
	IF @RefreshingToken = 1 AND @CurrentRefreshingToken = 1 AND @MinutesSinceRefresh > 0 AND @MinutesSinceRefresh < 15
	BEGIN
		ROLLBACK TRAN
		RETURN -1 --Already being refreshed by someone else
	END
			
	UPDATE	tWebDavServer
	SET		RefreshingToken = @RefreshingToken
	WHERE	WebDavServerKey = @WebDavServerKey
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -2
	END
	
	COMMIT TRAN
	
	RETURN 1
GO
