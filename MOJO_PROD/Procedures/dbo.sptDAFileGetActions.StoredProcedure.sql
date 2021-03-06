USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFileGetActions]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFileGetActions]

	(
		@FileKey int
	)

AS --Encrypt

Select fv.VersionNumber, fv.FileVersionKey, fv.FileKey, al.*
From
	tDAFileVersion fv (nolock),
	tActionLog al (nolock)
Where
	fv.FileVersionKey = al.EntityKey and
	al.Entity = 'FileVersion' and
	fv.FileKey = @FileKey
Order By 
	ActionDate DESC, VersionNumber Desc
GO
