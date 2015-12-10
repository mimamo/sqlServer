USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavFileGet]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavFileGet]
	@ProjectKey int = NULL,
	@Path varchar(2000) = NULL,
	@FileName varchar(300)
AS

/*
|| When      Who Rel      What
|| 4/1/13    CRG 10.5.6.6 Created
*/

	SELECT	*
	FROM	tWebDavFile (nolock)
	WHERE	ProjectKey = @ProjectKey
	AND		UPPER(ISNULL(Path, '')) = UPPER(ISNULL(@Path, ''))
	AND		UPPER(ISNULL(FileName, '')) = UPPER(ISNULL(@FileName, ''))
GO
