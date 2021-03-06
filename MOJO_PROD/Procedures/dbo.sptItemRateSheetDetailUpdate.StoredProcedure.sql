USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemRateSheetDetailUpdate]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptItemRateSheetDetailUpdate]

	(
		@ItemRateSheetKey int,
		@ItemKey int,
		@Markup decimal(24,4),
		@UnitRate money
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 8/28/07   CRG 8.5     Added UnitRate.
*/

If exists(Select 1 from tItemRateSheetDetail (nolock) Where ItemRateSheetKey = @ItemRateSheetKey and ItemKey = @ItemKey)
	Update	tItemRateSheetDetail
	Set		Markup = @Markup,
			UnitRate = @UnitRate
	Where	ItemRateSheetKey = @ItemRateSheetKey and ItemKey = @ItemKey
else
	Insert tItemRateSheetDetail
	(
	ItemRateSheetKey,
	ItemKey,
	Markup,
	UnitRate
	)
	Values
	(
	@ItemRateSheetKey,
	@ItemKey,
	@Markup,
	@UnitRate
	)
GO
