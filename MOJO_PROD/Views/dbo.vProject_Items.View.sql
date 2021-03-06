USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vProject_Items]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vProject_Items]
AS

/*
|| When      Who Rel     What
|| 10/30/07  CRG 8.5     Created to get the cartesian product of every Project and Item combination by Company.
|| 03/31/10  RLB 10.521  (78028) Added Item Name
*/

SELECT 	p.CompanyKey, p.ProjectKey, i.Entity, i.EntityKey, i.ItemID, i.ItemName
FROM	tProject p (nolock)
INNER JOIN vCompanyItemService i (nolock) ON p.CompanyKey = i.CompanyKey
GO
