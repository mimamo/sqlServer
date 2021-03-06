USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaDemographicDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaDemographicDelete]
	@MediaDemographicKey int

AS --Encrypt
/*
|| When      Who Rel      What
|| 06/03/13  MAS 10.5.6.9 Created
*/

DELETE
FROM tMediaDemographic
WHERE
	MediaDemographicKey = @MediaDemographicKey

RETURN 1
GO
