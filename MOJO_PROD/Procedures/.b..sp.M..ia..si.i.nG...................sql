USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaPositionGet]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CReate PROCEDURE [dbo].[sptMediaPositionGet]
	@MediaPositionKey int

AS --Encrypt
/*
|| When      Who Rel      What
|| 06/03/13  MAS 10.5.6.9 Created
*/
		SELECT *
		FROM tMediaPosition (nolock)
		WHERE
			MediaPositionKey = @MediaPositionKey

	RETURN 1
GO
