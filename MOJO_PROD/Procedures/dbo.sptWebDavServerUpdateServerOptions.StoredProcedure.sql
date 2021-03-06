USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavServerUpdateServerOptions]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavServerUpdateServerOptions]
	@WebDavServerKey int,
	@ClientFolder smallint,
	@ClientSep varchar(3),
	@ProjectFolder smallint,
	@ProjectSep varchar(3)
AS

/*
|| When      Who Rel      What
|| 10/7/11   CRG 10.5.4.9 Created
*/

	UPDATE	tWebDavServer
	SET		ClientFolder = @ClientFolder,
			ClientSep = @ClientSep,
			ProjectFolder = @ProjectFolder,
			ProjectSep = @ProjectSep
	WHERE	WebDavServerKey = @WebDavServerKey
GO
