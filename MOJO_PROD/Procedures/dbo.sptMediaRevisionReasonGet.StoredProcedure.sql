USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaRevisionReasonGet]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaRevisionReasonGet]
	@MediaRevisionReasonKey int

AS  -- Encrypt

	SELECT *
	FROM tMediaRevisionReason (NOLOCK)
	WHERE
		MediaRevisionReasonKey = @MediaRevisionReasonKey
	
	RETURN 1
GO
