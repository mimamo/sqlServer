USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaBroadcastLengthGet]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaBroadcastLengthGet]
	@MediaBroadcastLengthKey int

AS --Encrypt
/*
|| When      Who Rel      What
|| 07/17/13  MAS 10.5.6.9 Created
*/
		SELECT *
		FROM tMediaBroadcastLength (nolock)
		WHERE
			MediaBroadcastLengthKey = @MediaBroadcastLengthKey

	RETURN 1
GO
