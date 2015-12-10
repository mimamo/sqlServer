USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaDaysGet]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaDaysGet]
	@MediaDayKey int

AS --Encrypt
/*
|| When      Who Rel      What
|| 06/04/13  WDF 10.5.6.9 Created
*/
	SELECT *
	FROM tMediaDays (nolock)
	WHERE
		MediaDayKey = @MediaDayKey

	RETURN 1
GO
