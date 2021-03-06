USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataGetItemList]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataGetItemList]

	@CompanyKey int,
	@ItemType smallint


AS --Encrypt


Select 
	ItemKey,
	ItemID,
	ItemName,
	ISNULL(LinkID, '0') as LinkID
from
	tItem i (nolock)
Where
	i.CompanyKey = @CompanyKey and
	i.ItemType = @ItemType


	RETURN 1
GO
