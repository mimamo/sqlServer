USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSourceGet]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSourceGet]
	@SourceKey int

AS --Encrypt

/*
|| When      Who Rel      What
|| 01/14/09  QMD 10.5.0.0 Initial Release
*/

		SELECT	*
		FROM	tSource (nolock)
		WHERE	SourceKey = @SourceKey

	RETURN 1
GO
