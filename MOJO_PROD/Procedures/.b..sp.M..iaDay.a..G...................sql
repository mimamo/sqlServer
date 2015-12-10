USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaDayPartGet]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaDayPartGet]
	@MediaDayPartKey int

AS --Encrypt
/*
|| When      Who Rel      What
|| 07/17/13  MAS 10.5.6.9 Created
*/
		SELECT *
		FROM tMediaDayPart (nolock)
		WHERE
			MediaDayPartKey = @MediaDayPartKey

	RETURN 1
GO
