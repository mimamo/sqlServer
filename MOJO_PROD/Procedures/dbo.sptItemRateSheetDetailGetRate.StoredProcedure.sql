USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemRateSheetDetailGetRate]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sptItemRateSheetDetailGetRate]

	(
		@ItemRateSheetKey int,
		@ItemKey int
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 09/07/07 BSH 8.5     (9659)Return UnitRate if UseUnitRate on item is checked instead of Markup. 
*/


Declare @Markup decimal(24,4)
Declare @UnitRate money
Declare @UseUnitRate as tinyint

Select @UseUnitRate = ISNULL(UseUnitRate, 0)
from tItem (nolock)
where ItemKey = @ItemKey

if @UseUnitRate = 0
	begin
		Select @Markup = Markup from tItemRateSheetDetail (nolock) Where ItemRateSheetKey = @ItemRateSheetKey and ItemKey = @ItemKey
		Select @UnitRate = 0
	end
else
	begin
		Select @UnitRate = UnitRate from tItemRateSheetDetail (nolock) Where ItemRateSheetKey = @ItemRateSheetKey and ItemKey = @ItemKey
		Select @Markup = 0
	end

if @Markup is null
	Select @Markup = ISNULL(Markup, 0) from tItem (nolock) Where ItemKey = @ItemKey
	
if @UnitRate is null
	Select @UnitRate = ISNULL(UnitRate, 0) from tItem (nolock) where ItemKey = @ItemKey

Select @Markup as Markup,
       @UnitRate as UnitRate,
       @UseUnitRate as UseUnitRate
GO
