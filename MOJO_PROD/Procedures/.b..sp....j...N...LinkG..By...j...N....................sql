USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectNoteLinkGetByProjectNote]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectNoteLinkGetByProjectNote]
	@ProjectNoteKey int
AS --Encrypt

	SELECT	*
	FROM	tProjectNoteLink
	WHERE	ProjectNoteKey = @ProjectNoteKey
GO
