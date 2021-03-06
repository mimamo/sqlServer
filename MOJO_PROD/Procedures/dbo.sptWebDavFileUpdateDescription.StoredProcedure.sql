USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavFileUpdateDescription]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavFileUpdateDescription]
	@FileKey uniqueidentifier,
	@CompanyKey int,
	@ProjectKey int,
	@Path varchar(2000),
	@FileName varchar(300),
	@Description text
AS

/*
|| When      Who Rel      What
|| 4/2/13    CRG 10.5.6.6 Created
*/

	IF @FileKey IS NULL
		EXEC sptWebDavFileUpdate @FileKey OUTPUT, @CompanyKey, @ProjectKey, @Path, @FileName

	IF @FileKey IS NULL
		RETURN

	UPDATE	tWebDavFile
	SET		Description = @Description
	WHERE	FileKey = @FileKey
GO
