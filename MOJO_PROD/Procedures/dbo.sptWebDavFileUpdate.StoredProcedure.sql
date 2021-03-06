USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavFileUpdate]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavFileUpdate]
	@FileKey uniqueidentifier OUTPUT,
	@CompanyKey int,
	@ProjectKey int,
	@Path varchar(2000),
	@FileName varchar(300),
	@ModifiedBy int = NULL,
	@FileSize bigint = NULL,
	@Comments text = NULL,
	@Description text = NULL,
	@Action smallint = -1 --Default to Upload
AS

/*
|| When      Who Rel      What
|| 4/1/13    CRG 10.5.6.6 Created
|| 5/20/13   GWG 10.5.6.8 Added Description
*/

	IF @FileKey IS NULL
	BEGIN
		SELECT	@FileKey = NEWID()
		
		INSERT	tWebDavFile
				(FileKey,
				CompanyKey,
				ProjectKey,
				Path,
				FileName)
		VALUES	(@FileKey,
				@CompanyKey,
				@ProjectKey,
				@Path,
				@FileName)
	END
	ELSE
	BEGIN
		UPDATE	tWebDavFile
		SET		Path = @Path,
				FileName = @FileName
		WHERE	FileKey = @FileKey
	END

	IF @ModifiedBy IS NULL
		RETURN

	INSERT	tWebDavFileHistory
			(FileKey,
			Modified,
			ModifiedBy,
			FileSize,
			Comments,
			Action)
	VALUES	(@FileKey,
			GETUTCDATE(),
			@ModifiedBy,
			@FileSize,
			@Comments,
			@Action)

	if @Description is not null
		Update tWebDavFile Set Description = @Description Where FileKey = @FileKey
GO
