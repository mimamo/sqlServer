USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMarketingListCopy]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMarketingListCopy]
	(
	@MarketingListKey int
	)

AS

declare @NewKey int


INSERT tMarketingList
	(
	CompanyKey,
	ListName,
	ListID,
	ColumnDef
	)

select 
	CompanyKey,
	ListName,
	NULL,
	ColumnDef
from tMarketingList Where MarketingListKey = @MarketingListKey
	
Select @NewKey = @@Identity

Insert tMarketingListList (MarketingListKey, Entity, EntityKey)
Select @NewKey, Entity, EntityKey
From tMarketingListList 
Where MarketingListKey = @MarketingListKey

return @NewKey
GO
