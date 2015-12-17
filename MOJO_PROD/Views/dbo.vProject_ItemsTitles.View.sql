USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vProject_ItemsTitles]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vProject_ItemsTitles]
AS

/*
|| When      Who Rel     What
|| 01/30/15  GHL 10.588  Cloned vProject_Items for Abelson Taylor
*/

SELECT 	p.CompanyKey, p.ProjectKey, i.Entity, i.EntityKey, i.ItemID, i.ItemName
FROM	tProject p (nolock)
INNER JOIN vCompanyItemTitle i (nolock) ON p.CompanyKey = i.CompanyKey
GO
