USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemRateSheetNewItems]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptItemRateSheetNewItems]
	@CompanyKey INT
	,@ItemRateSheetKey int

	
AS --Encrypt

/*
|| When     Who Rel     What
|| 07/22/11 RLB 10.546 (117027) Created to find items that are not on Item RateSheets
*/
  	   
	
	
	Insert tItemRateSheetDetail
	(
	ItemRateSheetKey,
	ItemKey,
	Markup,
	UnitRate
	)

	Select @ItemRateSheetKey, ItemKey, Markup, UnitRate
	From tItem (nolock)
	Where CompanyKey = @CompanyKey
	And Active = 1
	And ItemKey Not In (Select ItemKey from tItemRateSheetDetail (nolock) where ItemRateSheetKey = @ItemRateSheetKey)
	
	return 1
GO
