USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavFileGetList]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavFileGetList]
	@ProjectKey int = NULL,
	@Path varchar(2000) = NULL,
	@Recursive tinyint = 0
AS

/*
|| When      Who Rel      What
|| 3/28/13   CRG 10.5.6.6 Created
*/

	--For now, if it's recursive, I know that I don't need the UserName, so I'm not joining out to the view in order to be more efficient.
	IF @Recursive = 1
		SELECT	*
		FROM	tWebDavFile (nolock)
		WHERE	(@ProjectKey IS NULL OR ProjectKey = @ProjectKey)
		AND		(@Path IS NULL OR UPPER(ISNULL(Path, '')) LIKE UPPER(@Path) + '%')
	ELSE
		SELECT	f.*, u.UserName AS LastModifiedName
		FROM	tWebDavFile f (nolock)
		LEFT JOIN vUserName u (nolock) ON f.LastModifiedBy = u.UserKey
		WHERE	(@ProjectKey IS NULL OR f.ProjectKey = @ProjectKey)
		AND		(@Path IS NULL OR UPPER(ISNULL(f.Path, '')) = UPPER(@Path))
GO
