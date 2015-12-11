USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vCompanyItemService]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vCompanyItemService]
AS

/*
|| When      Who Rel     What
|| 10/30/07  CRG 8.5     Created to get a Union of all Items and Services.
|| 03/31/10  RLB 10.521  Cleared up ItemID and added Item Name
|| 02/03/12  GHL 10.552  Changed UNION to UNION ALL to speed up queries
*/

SELECT	CompanyKey,
		'tItem' AS Entity,
		ItemKey AS EntityKey,
		ItemID AS ItemID,
		ItemName AS ItemName
FROM	tItem (nolock)

UNION ALL

SELECT	CompanyKey,
		'tService' AS Entity,
		ServiceKey,
		ServiceCode,
		Description
FROM	tService (nolock)
GO
