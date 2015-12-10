USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptNewItemRateSheetUpdate]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptNewItemRateSheetUpdate]
	(
		@CompanyKey INT,
		@ItemKey INT
		
	)
	
	AS --Encrypt

/*
|| When      Who Rel     What
|| 07/22/11  RLB 10.546  Created to add new items to all a companies Item RateSheets
*/

    Declare @Markup decimal(24,4), @UnitRate money
    
    Select @Markup = Markup, @UnitRate = UnitRate from tItem (nolock) where ItemKey = @ItemKey
    
	Insert tItemRateSheetDetail
	(
	ItemRateSheetKey,
	ItemKey,
	Markup,
	UnitRate
	)
	Select
	
	ItemRateSheetKey,
	@ItemKey,
	@Markup,
	@UnitRate
	from tItemRateSheet (nolock)
	where CompanyKey = @CompanyKey
GO
