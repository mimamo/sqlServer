USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaRevisionReasonGetList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaRevisionReasonGetList]
	(
	@CompanyKey int
	,@Active smallint
	,@MediaRevisionReasonKey int = NULL
	)
	
AS  -- Encrypt

/*
|| When      Who Rel     What
|| 5/16/07   CRG 8.4.3   (8815) Added optional Key parameter so that it will appear in list if it is not Active.
*/

	SELECT	*
	FROM	tMediaRevisionReason (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	AND		((@Active IS NULL OR Active = @Active) OR (MediaRevisionReasonKey = @MediaRevisionReasonKey))
	ORDER BY ReasonID
	
	RETURN 1
GO
