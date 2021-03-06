USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavServerDelete]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavServerDelete]
	@WebDavServerKey int
AS

/*
|| When      Who Rel      What
|| 9/23/11   CRG 10.5.4.8 Created
*/

	IF EXISTS
			(SELECT NULL
			FROM	tPreference (nolock)
			WHERE	WebDavServerKey = @WebDavServerKey)
		UPDATE	tPreference
		SET		WebDavServerKey = NULL
		WHERE	WebDavServerKey = @WebDavServerKey

	IF EXISTS
			(SELECT NULL
			FROM	tOffice (nolock)
			WHERE	WebDavServerKey = @WebDavServerKey)
		UPDATE	tOffice
		SET		WebDavServerKey = NULL
		WHERE	WebDavServerKey = @WebDavServerKey

	DELETE	tWebDavServer
	WHERE	WebDavServerKey = @WebDavServerKey
GO
