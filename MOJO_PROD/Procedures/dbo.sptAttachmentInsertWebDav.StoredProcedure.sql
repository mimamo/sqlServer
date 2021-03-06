USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttachmentInsertWebDav]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAttachmentInsertWebDav]
	 @CompanyKey int,
	 @AssociatedEntity varchar(50),
	 @EntityKey int,
	 @AddedBy int,
	 @FileName varchar(300),
	 @Comments varchar(1000),
	 @Path varchar(2000),
	 @FileID varchar(2000) = null,
	 @Size int = null,
	 @SafeFileName tinyint = 1
AS --Encrypt
 
 /*
|| When      Who Rel      What
|| 10/17/11  CRG 10.5.4.9 Created
|| 4/3/12    CRG 10.5.5.5 Added @FileID
|| 11/7/12   CRG 10.5.6.2 Now converting fileName to a WebDAV safe name
|| 11/12/12  CRG 10.5.6.2 Added CompanyKey
|| 6/18/13   CRG 10.5.6.8 (180899) Added @Size
|| 03/09/15  GAR 10.5.8.9 Added SafeFileName.  Sometimes we don't use safe file name (Box).
*/

	--Assume that the FileName has been converted to WebDAV safe
	IF @SafeFileName = 1
		SELECT	@FileName = dbo.fSafeWebDavFile(@FileName)

	--This is called by the WebDAV server during upload, and if the upload is resumable, it may call this SP several times.
	--So, we want to ensure that the row is not duplicated in the tAttachment table
	DECLARE	@AttachmentKey int

	SELECT	@AttachmentKey = AttachmentKey
	FROM	tAttachment (nolock)
	WHERE	AssociatedEntity = @AssociatedEntity
	AND		EntityKey = @EntityKey
	AND		Path = @Path
	AND		FileName = @FileName

	IF ISNULL(@AttachmentKey, 0) <> 0
		RETURN @AttachmentKey		

	INSERT tAttachment
		(CompanyKey,
		AssociatedEntity,
		EntityKey,
		AddedBy,
		FileName,
		Comments,
		Path,
		FileID,
		Size)
	VALUES
		(@CompanyKey,
		@AssociatedEntity,
		@EntityKey,
		@AddedBy,
		@FileName,
		@Comments,
		@Path,
		@FileID,
		@Size)
 
 RETURN @@IDENTITY
GO
