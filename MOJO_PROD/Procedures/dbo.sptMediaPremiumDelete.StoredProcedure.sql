USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaPremiumDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaPremiumDelete]
	@MediaPremiumKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 07/08/13 MFT 10.570  Created
*/

DELETE
FROM tMediaPremiumDetail
WHERE
	MediaPremiumKey = @MediaPremiumKey
	
DELETE
FROM tMediaPremium
WHERE
	MediaPremiumKey = @MediaPremiumKey
GO
