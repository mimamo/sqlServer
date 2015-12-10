USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavLogUpdateUser]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavLogUpdateUser]
	@WebDavLogKey uniqueidentifier,
	@CompanyKey int,
	@UserKey int
AS

/*
|| When      Who Rel      What
|| 7/10/13   CRG 10.5.6.9 Created
*/

	UPDATE	tWebDavLog
	SET		CompanyKey = @CompanyKey,
			UserKey = @UserKey
	WHERE	WebDavLogKey = @WebDavLogKey
GO
