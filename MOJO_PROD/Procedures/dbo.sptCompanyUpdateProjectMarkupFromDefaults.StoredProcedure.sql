USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyUpdateProjectMarkupFromDefaults]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyUpdateProjectMarkupFromDefaults]
	(
		@CompanyKey int,
		@ClientKey int,
		@GetMarkupFrom int,
		@ItemRateSheetKey int,
		@ItemMarkup decimal(24,4),
		@IOCommission decimal(24,4),
		@BCCommission decimal(24,4),
		@Active tinyint
		
	)
AS --Encrypt

  /*
  || When     Who Rel		What
  || 8/20/10  RLB 10.534    (87267) Created for update markup from on CompanyEdit     
  */
  


If @GetMarkupFrom = 1 or @GetMarkupFrom = 2
begin
	if @Active = 1
		Update tProject set GetMarkupFrom = @GetMarkupFrom, ItemMarkup = @ItemMarkup, IOCommission = @IOCommission, BCCommission = @BCCommission, ItemRateSheetKey = 0 where CompanyKey = @CompanyKey and ClientKey = @ClientKey and Active = 1
	else
		Update tProject set GetMarkupFrom = @GetMarkupFrom, ItemMarkup = @ItemMarkup, IOCommission = @IOCommission, BCCommission = @BCCommission, ItemRateSheetKey = 0 where CompanyKey = @CompanyKey and ClientKey = @ClientKey 
end
if @GetMarkupFrom = 4
begin
	if @Active = 1
		update tProject set GetMarkupFrom = @GetMarkupFrom, ItemMarkup = 0, IOCommission = 0, BCCommission = 0, ItemRateSheetKey = @ItemRateSheetKey where CompanyKey = @CompanyKey and ClientKey = @ClientKey and Active = 1
	else
		update tProject set GetMarkupFrom = @GetMarkupFrom, ItemMarkup = 0, IOCommission = 0, BCCommission = 0, ItemRateSheetKey = @ItemRateSheetKey where CompanyKey = @CompanyKey and ClientKey = @ClientKey 
end

if @GetMarkupFrom = 3 or @GetMarkupFrom = 5 
begin
	if @Active = 1
		update tProject set GetMarkupFrom = @GetMarkupFrom, ItemMarkup = 0, IOCommission = 0, BCCommission = 0, ItemRateSheetKey = 0 where CompanyKey = @CompanyKey and ClientKey = @ClientKey and Active = 1
	else
		update tProject set GetMarkupFrom = @GetMarkupFrom, ItemMarkup = 0, IOCommission = 0, BCCommission = 0, ItemRateSheetKey = 0 where CompanyKey = @CompanyKey and ClientKey = @ClientKey 
end
GO
