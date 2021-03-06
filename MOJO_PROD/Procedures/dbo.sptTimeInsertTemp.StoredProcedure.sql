USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeInsertTemp]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTimeInsertTemp]
 @RowNumber int,
 @TimeSheetKey int,
 @UserKey int,
 @ProjectKey int,
 @TaskKey int,
 @ServiceKey int,
 @WorkDate smalldatetime,
 @StartTime smalldatetime,
 @EndTime smalldatetime,
 @ActualHours decimal(24,4),
 @PauseHours decimal(24,4),
 @Comments varchar(2000),
 @RateLevel int,
 @Copying tinyint,
 @DetailTaskKey int
 
AS --Encrypt

/*
|| When      Who Rel	What
|| 12/20/06  RTC 8.4     Added validation to prevent time entries outside the timesheet period.
|| 01/04/07  RTC 8.4001  Skip date range validation if coying a timesheet
|| 06/20/07  CRG 8.4.3.1 Added DetailTaskKey.
|| 7/5/07    CRG 8.4.3.1 (9657) Added validation to ensure DetailTaskKey is still valid for the ProjectKey.
|| 04/14/08  GHL 8.508   (24776) Added similar validation to ensure that DetailTaskKey valid for the budget task
|| 05/29/08  GHL 8.512   Updating now DetailTaskKey when possible to help with the traffic screens
||                       In time entry, this is not updated but in one case, that can be done
|| 08/11/08  GHL 10.0.0.6  Calling now sptTimeInsertFixTaskKeys for task validations
|| 01/12/10 GHL 10.516  (72043) Added patch to fix StartTime on wrong date
|| 06/19/12 RLB 10.5.5.7  HMI Change 
|| 03/12/13 GHL 10.565 (171480) Cannot have RateLevel = 0      
|| 11/04/13 GHL 10.574 Added Currency info  
|| 09/03/14 RLB 10.584 Removed check for active status projects since entries are removed in sptTimeSheetCopy      
|| 03/10/15 GHL 10.590 Added DepartmentKey for Abelson Taylor                              
*/

	-- Cloned from sptTimeInsert to reduce deadlocks
	
	-- Assume done before calling this sp
	/*
	CREATE TABLE #tTime (RowNumber INT NULL
						,ProjectNumber VARCHAR(50)
						,ErrorNumber INT NULL 
						,TimeKey uniqueidentifier NULL
						,TimeSheetKey INT NULL
						,UserKey INT NULL
						,ProjectKey INT NULL
						,TaskKey INT NULL
						,ServiceKey INT NULL
						,RateLevel int NULL
						,WorkDate smalldatetime NULL
						,StartTime smalldatetime NULL
						,EndTime smalldatetime NULL
						,ActualHours decimal(24,4) NULL
						,PauseHours decimal(24,4) NULL
						,ActualRate money NULL
						,Comments varchar(2000) NULL
						,CostRate money NULL
						,DetailTaskKey int NULL
						,CurrencyID varchar(10) NULL
						,ExchangeRate decmal(24,7) NULL
						,HCostRate money NULL
						,DepartmentKey int null
						) 	
	*/
		
	DECLARE	@ActualRate money,
			@GetRateFrom smallint,
			@OverrideRate tinyint,
			@CompanyKey int,
			@TimeRateSheetKey int,
			@RateSheetRate money,
			@CostRate money,
			@ProjectStatusKey int,
			@RequireTimeDetails int,
			@ProjectNumber varchar(50),
			@StartDate smalldatetime,
			@EndDate smalldatetime,
			@RetVal int,
			@GLCompanyKey int,
			@MultiCurrency int,
			@HomeCurrencyID varchar(10),
			@ProjectCurrencyID varchar(10),
			@CurrencyID varchar(10),
			@ExchangeRate decimal(24,7),
			@HCostRate money, -- in Home Currency
			@RateHistory int, -- used in UI, needed for sptCurrencyGetRate 
		    @DepartmentKey int

	-- perform validation if not copying
	if @Copying <> 1
		begin
			select  @StartDate = StartDate
				,@EndDate = EndDate
			from	tTimeSheet (nolock)
			where	TimeSheetKey = @TimeSheetKey
			if @WorkDate < @StartDate or @WorkDate > @EndDate
				return -10
		end
					
	DECLARE @TimeKey uniqueidentifier
	SELECT @TimeKey = NEWID()
	
	SELECT @CostRate = ISNULL(u.HourlyCost, 0)
		   ,@HCostRate = ISNULL(u.HourlyCost, 0)
		   ,@RequireTimeDetails = ISNULL(u.RequireUserTimeDetails, 0)			
		   ,@MultiCurrency = isnull(pref.MultiCurrency, 0)
		   ,@HomeCurrencyID = CurrencyID -- will not be null if MC = 1
		   ,@CompanyKey = pref.CompanyKey	
	FROM   tUser u (NOLOCK)
		INNER JOIN tPreference pref (NOLOCK) ON u.CompanyKey = pref.CompanyKey 
	WHERE  UserKey = @UserKey


	-- validations + update detail task key when possible  
	 -- parameters are both input and output
	 exec sptTimeInsertFixTaskKeys @ProjectKey, @TaskKey output, @DetailTaskKey output 
 
	IF @ProjectKey IS NOT NULL
		-- Added ProjectNumber to report errors during TimeSheet copy because we do not have rows on a grid
		SELECT @ProjectNumber = ProjectNumber FROM tProject (NOLOCK) WHERE ProjectKey = @ProjectKey
	
-- patch to make sure that WorkDate and Start/End Times are on the same day
-- If not reliable, sorts on StartTime would be wrong
declare @NumDaysDiff int
if @StartTime is not null
begin
	select @NumDaysDiff = datediff(d, @StartTime, @WorkDate)
	select @StartTime = dateadd(d, @NumDaysDiff, @StartTime )
end
if @EndTime is not null
begin
	select @NumDaysDiff = datediff(d, @EndTime, @WorkDate)
	select @EndTime = dateadd(d, @NumDaysDiff, @EndTime )
end

-- multicurrency functionality
select @GLCompanyKey = GLCompanyKey 
		,@ProjectCurrencyID = CurrencyID
from tProject (nolock) 
where ProjectKey = @ProjectKey

declare @GetExchangeRate int
select @GetExchangeRate = 0    
if @MultiCurrency = 1 And  @ProjectCurrencyID is not null And @ProjectCurrencyID <> @HomeCurrencyID 
	select @GetExchangeRate = 1 		

if @GetExchangeRate = 0
	select @CurrencyID = null
	       ,@ExchangeRate = 1
else
begin
	select @CurrencyID = @ProjectCurrencyID
	exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @ProjectCurrencyID, @WorkDate, @ExchangeRate output, @RateHistory output

	-- Exchange Rate converts from proj curr to home curr
	-- we want the opposite home curr to proj curr, so divide here
	select @CostRate = round(@HCostRate / @ExchangeRate, 2)
end
			
if isnull(@RateLevel, 0) = 0
	select @RateLevel = 1

exec sptTimeGetDepartment @UserKey, @ServiceKey, @DepartmentKey output 

	INSERT #tTime
			(RowNumber,
			ErrorNumber,
			TimeKey,
			TimeSheetKey,
			UserKey,
			ProjectKey,
			TaskKey,
			ServiceKey,
			RateLevel,
			WorkDate,
			StartTime,
			EndTime,
			ActualHours,
			PauseHours,
			ActualRate,
			Comments,
			CostRate,
			ProjectNumber,
			DetailTaskKey,
			CurrencyID,
			ExchangeRate,
			HCostRate,
			DepartmentKey
			)
			VALUES
			(@RowNumber, 
			0, 
			@TimeKey,
			@TimeSheetKey,
			@UserKey,
			@ProjectKey,
			@TaskKey,
			@ServiceKey,
			@RateLevel,
			@WorkDate,
			@StartTime,
			@EndTime,
			@ActualHours,
			@PauseHours,
			0,
			@Comments,
			@CostRate,
			@ProjectNumber,
			@DetailTaskKey,
			@CurrencyID,
			@ExchangeRate,
			@HCostRate,
			@DepartmentKey
			) 
				
	-- Now try to find the Actual Rate
	-- If we can't, set ErrorNumber

	-- calling now the centralized function to determine the rate, param 1 indicates checking of TimeActive
	-- set this call to not check active project status time entries because they  are removed in sptTimeSheetCopy
	exec @RetVal = sptTimeGetRate @UserKey, @ProjectKey, @TaskKey, @ServiceKey, @RateLevel, 0, @ActualRate output
 
	if @RetVal <> 1
    begin
		UPDATE #tTime SET ErrorNumber = @RetVal WHERE TimeSheetKey = @TimeSheetKey AND TimeKey = @TimeKey
		RETURN @RetVal
    end
    
	IF @RequireTimeDetails = 1 
	BEGIN
		IF @StartTime IS NULL
		BEGIN
			UPDATE #tTime SET ErrorNumber = -200 WHERE TimeSheetKey = @TimeSheetKey AND TimeKey = @TimeKey
			RETURN -200
		END
			
		IF @EndTime IS NULL
		BEGIN
			UPDATE #tTime SET ErrorNumber = -201 WHERE TimeSheetKey = @TimeSheetKey AND TimeKey = @TimeKey
			RETURN -201
		END
		
		IF @Comments IS NULL
		BEGIN
			UPDATE #tTime SET ErrorNumber = -202 WHERE TimeSheetKey = @TimeSheetKey AND TimeKey = @TimeKey
			RETURN -202
		END
		
	END
	
	UPDATE #tTime SET ActualRate = @ActualRate WHERE TimeSheetKey = @TimeSheetKey AND TimeKey = @TimeKey
	
 RETURN 1
GO
