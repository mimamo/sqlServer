USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaPremiumGet]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaPremiumGet]
	@MediaPremiumKey int

AS --Encrypt

/*
|| When     Who Rel      What
|| 07/08/13 MFT 10.570   Created
|| 07/19/13 CRG 10.5.7.0 Added query of tMediaPremium
*/

SELECT *
FROM	tMediaPremium (nolock)
WHERE	MediaPremiumKey = @MediaPremiumKey

SELECT *
FROM tMediaPremiumDetail (nolock)
WHERE
	MediaPremiumKey = @MediaPremiumKey
GO
