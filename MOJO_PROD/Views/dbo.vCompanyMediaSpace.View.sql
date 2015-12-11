USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vCompanyMediaSpace]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vCompanyMediaSpace]
AS

/*
|| When      Who Rel      What
|| 10/22/13  CRG 10.5.7.3 Created to simplify the Space lookup query
*/

SELECT	cms.CompanyMediaKey, cms.MediaSpaceKey, ISNULL(cm.StationID, '') + '-' + ISNULL(cm.Name, '') AS Publication
FROM	tCompanyMediaSpace cms (NOLOCK)
INNER JOIN tCompanyMedia cm (NOLOCK) ON cms.CompanyMediaKey = cm.CompanyMediaKey
GO
