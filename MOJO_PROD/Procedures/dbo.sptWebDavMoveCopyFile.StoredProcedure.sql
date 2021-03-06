USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavMoveCopyFile]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavMoveCopyFile]
	@CompanyKey int,
	@Mode tinyint,
	@ProjectKey int,
	@SrcPath varchar(2000),
	@SrcFileName varchar(300),
	@DestPath varchar(2000),
	@DestFileName varchar(300),
	@UserKey int
AS

/*
|| When      Who Rel      What
|| 4/3/13    CRG 10.5.6.6 Created
|| 5/28/13   CRG 10.5.6.8 Modified calls to sptWebDavFileUpdate due to new parm added
*/
	
	DECLARE	@MOVE tinyint SELECT @MOVE = 0
    DECLARE	@COPY tinyint SELECT @COPY = 1

	DECLARE	@FileKey uniqueidentifier

	--Build a temp table with all of the columns in tWebDavFile
	SELECT * INTO #FileList FROM tWebDavFile WHERE 1=2

	INSERT #FileList
	EXEC sptWebDavFileGet @ProjectKey, @SrcPath, @SrcFileName

	IF (SELECT COUNT(*) FROM #FileList) > 0
		SELECT	TOP 1 @FileKey = FileKey
		FROM	#FileList

	IF @FileKey IS NULL OR @Mode = @COPY
	BEGIN
		--If this is a copied file or there's no history for this file, create a new record
		EXEC sptWebDavFileUpdate NULL, @CompanyKey, @ProjectKey, @DestPath, @DestFileName, @UserKey, NULL, NULL, NULL, @Mode
		RETURN
	END

	--If @Mode = @MOVE, then use the old FileKey, but pass in the @DestPath, @DestFileName	
	EXEC sptWebDavFileUpdate @FileKey, @CompanyKey,	@ProjectKey, @DestPath, @DestFileName, @UserKey, NULL, NULL, NULL, @Mode
GO
