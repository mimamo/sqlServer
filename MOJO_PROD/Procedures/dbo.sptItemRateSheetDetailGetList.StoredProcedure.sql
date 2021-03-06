USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemRateSheetDetailGetList]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptItemRateSheetDetailGetList]

	(
		@CompanyKey int,
		@ItemRateSheetKey int
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 07/27/07 BSH 8.5   (9952)Show active items only.
|| 08/28/07 CRG 8.5   Added UnitRate and UseUnitRate.
|| 01/25/10 RLB 10.5.17 Added ItemTypeName for grouping on the new flex item rate sheet page
|| 05/25/10 RLB 10.523 (81307)Changed ItemMarkup to StandardCosts
|| 03/08/12 GHL 10.554 (146366) Make sure that UnitRate and Markup are not null
||                     This is causing confusion with the users because the item rate sheet looks fine
||                     But the Item Rate manager reads UnitRate = 0
*/

update tItemRateSheetDetail
set    tItemRateSheetDetail.Markup = isnull(tItemRateSheetDetail.Markup, tItem.Markup)
      ,tItemRateSheetDetail.UnitRate = isnull(tItemRateSheetDetail.UnitRate, tItem.UnitRate)
from   tItem (nolock)
where  tItemRateSheetDetail.ItemRateSheetKey = @ItemRateSheetKey 
and    tItemRateSheetDetail.ItemKey = tItem.ItemKey 
and    (tItemRateSheetDetail.Markup is null or tItemRateSheetDetail.UnitRate is null)

Select
	i.ItemKey, i.ItemType, i.ItemID, i.ItemName
	, ISNULL(rs.Markup, i.Markup) as Markup
	, i.UnitCost as StandardCost
	, ISNULL(rs.UnitRate, i.UnitRate) as UnitRate
	, isnull(i.UseUnitRate, 0) as UseUnitRate, 
	case i.ItemType 
		when 0 then 'Purchase Items'
		when 1 then 'Print Items'
		when 2 then 'Broadcast Items'
		when 3 then 'Expense Report Items'
	end as ItemTypeName
From
	tItem i (nolock)
	left outer join (Select * from tItemRateSheetDetail (nolock) Where ItemRateSheetKey = @ItemRateSheetKey) rs on i.ItemKey = rs.ItemKey
Where
	i.CompanyKey = @CompanyKey and i.Active = 1
Order by ItemTypeName
GO
