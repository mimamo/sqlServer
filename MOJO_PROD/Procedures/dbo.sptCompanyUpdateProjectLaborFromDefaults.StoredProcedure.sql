USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyUpdateProjectLaborFromDefaults]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyUpdateProjectLaborFromDefaults]
	(
		@CompanyKey int,
		@ClientKey int,
		@GetRateFrom int,
		@TimeRateSheetKey int,
		@TitleRateSheetKey int,
		@HourlyRate money = null,
		@Active tinyint
		
	)
AS --Encrypt

  /*
  || When     Who Rel			What
  || 08/20/10  RLB 10.5.3.4    (87267) Created for update Labor from on CompanyEdit
  || 09/24/14  MAS 10.5.8.3    Abelson & Taylor - Added Billing Title(9) & Biling Title Rate Sheet(10)
  */
  


If @GetRateFrom = 2
begin
	if @Active = 1
		Update tProject set GetRateFrom = @GetRateFrom, HourlyRate = @HourlyRate, TimeRateSheetKey = 0 where CompanyKey = @CompanyKey and ClientKey = @ClientKey and Active = 1
	else
		Update tProject set GetRateFrom = @GetRateFrom, HourlyRate = @HourlyRate, TimeRateSheetKey = 0 where CompanyKey = @CompanyKey and ClientKey = @ClientKey 
end
if @GetRateFrom = 5
begin
	if @Active = 1
		update tProject set GetRateFrom = @GetRateFrom, HourlyRate = 0, TimeRateSheetKey = @TimeRateSheetKey where CompanyKey = @CompanyKey and ClientKey = @ClientKey and Active = 1
	else
		update tProject set GetRateFrom = @GetRateFrom, HourlyRate = 0, TimeRateSheetKey = @TimeRateSheetKey where CompanyKey = @CompanyKey and ClientKey = @ClientKey 
end

If @GetRateFrom = 9 -- Billing Title
begin
	if @Active = 1
		Update tProject set GetRateFrom = @GetRateFrom, HourlyRate = 0, TitleRateSheetKey = 0 where CompanyKey = @CompanyKey and ClientKey = @ClientKey and Active = 1
	else
		Update tProject set GetRateFrom = @GetRateFrom, HourlyRate = 0, TitleRateSheetKey = 0 where CompanyKey = @CompanyKey and ClientKey = @ClientKey 
end

if @GetRateFrom = 10 -- Biling Title Rate Sheet
begin
	if @Active = 1
		update tProject set GetRateFrom = @GetRateFrom, HourlyRate = 0, TitleRateSheetKey = @TitleRateSheetKey where CompanyKey = @CompanyKey and ClientKey = @ClientKey and Active = 1
	else
		update tProject set GetRateFrom = @GetRateFrom, HourlyRate = 0, TitleRateSheetKey = @TitleRateSheetKey where CompanyKey = @CompanyKey and ClientKey = @ClientKey 
end

if @GetRateFrom = 1 or @GetRateFrom = 3 or @GetRateFrom = 4 or @GetRateFrom = 6
begin
	if @Active = 1
		update tProject set GetRateFrom = @GetRateFrom, HourlyRate = 0, TimeRateSheetKey = 0 where CompanyKey = @CompanyKey and ClientKey = @ClientKey and Active = 1
	else
		update tProject set GetRateFrom = @GetRateFrom, HourlyRate = 0, TimeRateSheetKey = 0 where CompanyKey = @CompanyKey and ClientKey = @ClientKey 
end

if @Active = 1
	Select ProjectKey from tProject (nolock) where CompanyKey = @CompanyKey and ClientKey = @ClientKey and Active = 1
else
	Select ProjectKey from tProject (nolock) where CompanyKey = @CompanyKey and ClientKey = @ClientKey
GO
