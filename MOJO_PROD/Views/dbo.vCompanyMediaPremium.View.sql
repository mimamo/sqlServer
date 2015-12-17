USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vCompanyMediaPremium]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vCompanyMediaPremium]
AS

/*
|| When      Who Rel      What
|| 10/25/13  CRG 10.5.7.3 Created to simplify the Premium lookup query
*/

SELECT	cmp.CompanyMediaKey, cmp.MediaPremiumKey, ISNULL(cm.StationID, '') + '-' + ISNULL(cm.Name, '') AS Publication
FROM	tCompanyMediaPremium cmp (NOLOCK)
INNER JOIN tCompanyMedia cm (NOLOCK) ON cmp.CompanyMediaKey = cm.CompanyMediaKey
GO
