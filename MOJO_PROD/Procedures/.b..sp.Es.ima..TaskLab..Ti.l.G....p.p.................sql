USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskLaborTitleGetPopup]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskLaborTitleGetPopup]
	(
	@ServiceKey int					
	,@CompanyKey INT 
	,@ProjectKey INT = 0 -- set on estimates with project only
	)
AS --Encrypt

	SET NOCOUNT ON

/*
|| When     Who Rel     What
|| 10/08/14 GHL 10.585  Creation for estimate titles
||                      This SP should be called when displaying the Edit Title's Rate popup
|| 10/13/14 GHL 10.585  Added cost
|| 03/30/15 GHL 10.591  (251509) Standard rates are now stored in tEstimateTitle, so pass 2 arrays
||                      1) Standard rates from tEstimateTitle
||                      2) Current rates from tEstimateTaskLaborTitle 
*/

	/*
	Assume passed to this SP, the current title rates in a temp table
	create table #currentrate(TitleKey int null, Hours decimal(24,4) null, Rate money null, Gross money null, Cost money null)

	create table #standardrate(TitleKey int null, Hours decimal(24,4) null, Rate money null, Gross money null, Cost money null)
	*/

	-- These are the GetRateFrom values in tProject and tCompany
	declare @kGetRateFromClient int             select @kGetRateFromClient = 1			-- HourlyRate in tCompany
	declare @kGetRateFromProject int            select @kGetRateFromProject = 2			-- HourlyRate in tCompany/tProject
	declare @kGetRateFromProjectUser int        select @kGetRateFromProjectUser = 3
	declare @kGetRateFromService int            select @kGetRateFromService = 4
	declare @kGetRateFromServiceRateSheet int   select @kGetRateFromServiceRateSheet = 5
	declare @kGetRateFromTask int               select @kGetRateFromTask = 6
	declare @kGetRateFromTitle int              select @kGetRateFromTitle = 9
	declare @kGetRateFromTitleRateSheet int     select @kGetRateFromTitleRateSheet = 10
	
	DECLARE	@GetRateFrom INT
			,@TitleRateSheetKey INT
			
	if isnull(@ProjectKey, 0) > 0
	begin
		SELECT @GetRateFrom = ISNULL(GetRateFrom, @kGetRateFromProject)
			  ,@TitleRateSheetKey = ISNULL(TitleRateSheetKey, 0)  
		FROM   tProject (NOLOCK) 
		WHERE  ProjectKey = @ProjectKey
	end
	
	select @TitleRateSheetKey = isnull(@TitleRateSheetKey, 0)

	-- if the rate is not by title rate sheet, reset the title rate
	IF @GetRateFrom <> @kGetRateFromTitleRateSheet
		SELECT @TitleRateSheetKey = 0

	
	create table #rate(TitleKey int null, Hours decimal(24,4) null, Rate money null, Gross money null, Cost money null, Selected int null)
	
	if @TitleRateSheetKey > 0
		if @ServiceKey >0
			insert #rate(TitleKey, Hours, Rate, Gross, Cost)
			select distinct t.TitleKey, 0, isnull(trsd.HourlyRate,t.HourlyRate), 0, t.HourlyCost
			from   tTitle t (nolock)
				inner join tTitleService ts (nolock) on t.TitleKey = ts.TitleKey
				left join tTitleRateSheetDetail trsd (nolock) on t.TitleKey = trsd.TitleKey
			where  t.CompanyKey = @CompanyKey
			and    ts.ServiceKey = @ServiceKey
			and    trsd.TitleRateSheetKey = @TitleRateSheetKey
			and    t.Active = 1
		else
			insert #rate(TitleKey, Hours, Rate, Gross, Cost)
			select t.TitleKey, 0, isnull(trsd.HourlyRate,t.HourlyRate), 0, t.HourlyCost
			from   tTitle t (nolock)
				left join tTitleRateSheetDetail trsd (nolock) on t.TitleKey = trsd.TitleKey
			where  t.CompanyKey = @CompanyKey
			and    trsd.TitleRateSheetKey = @TitleRateSheetKey
			and    t.Active = 1
	else

		if @ServiceKey >0
			insert #rate(TitleKey, Hours, Rate, Gross, Cost)
			select distinct t.TitleKey, 0, t.HourlyRate, 0,  t.HourlyCost
			from   tTitle t (nolock)
				inner join tTitleService ts (nolock) on t.TitleKey = ts.TitleKey
			where  t.CompanyKey = @CompanyKey
			and    ts.ServiceKey = @ServiceKey
			and    t.Active = 1
		else
			insert #rate(TitleKey, Hours, Rate, Gross, Cost)
			select t.TitleKey, 0, t.HourlyRate, 0,  t.HourlyCost
			from   tTitle t (nolock)
			where  t.CompanyKey = @CompanyKey
			and    t.Active = 1

	-- update values with the standard rates
	update #rate
	set    #rate.Hours = b.Hours
	      ,#rate.Rate = b.Rate
		  ,#rate.Gross = b.Gross
		  ,#rate.Cost = b.Cost
	from   #standardrate b
	where  #rate.TitleKey = b.TitleKey

	-- update values with the current rates
	update #rate
	set    #rate.Hours = b.Hours
	      ,#rate.Rate = b.Rate
		  ,#rate.Gross = b.Gross
		  ,#rate.Cost = b.Cost
		  ,#rate.Selected = 1
	from   #currentrate b
	where  #rate.TitleKey = b.TitleKey

	-- insert if missing (first from the current)
	insert #rate (TitleKey, Hours, Rate, Gross, Cost, Selected)
	select TitleKey, Hours, Rate, Gross, Cost, 1
	from   #currentrate 
	where  TitleKey not in (select TitleKey from #rate)

	-- insert if missing (second from the standard)
	insert #rate (TitleKey, Hours, Rate, Gross, Cost, Selected)
	select TitleKey, Hours, Rate, Gross, Cost, 0
	from   #standardrate 
	where  TitleKey not in (select TitleKey from #rate)

	select t.TitleID, t.TitleName, #rate.*
	from   #rate
	inner join tTitle t (nolock) on #rate.TitleKey = t.TitleKey 
	order by #rate.Selected desc, t.TitleID

	RETURN 1
GO
