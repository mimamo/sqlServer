USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vCompanyItemTitle]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vCompanyItemTitle]
AS

/*
|| When      Who Rel     What
|| 01/30/15  GHL 10.588  Cloned vCompanyItemService for Abelson Taylor
*/

SELECT	CompanyKey,
		'tItem' AS Entity,
		ItemKey AS EntityKey,
		ItemID AS ItemID,
		ItemName AS ItemName
FROM	tItem (nolock)

UNION ALL

SELECT	CompanyKey,
		'tTitle' AS Entity,
		TitleKey,
		TitleID,
		TitleName
FROM	tTitle (nolock)
GO
