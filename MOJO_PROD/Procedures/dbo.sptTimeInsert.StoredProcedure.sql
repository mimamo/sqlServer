USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeInsert]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeInsert]
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
 @DetailTaskKey int = null,
 @Verified tinyint = 1,
 @TimeKey uniqueidentifier output
 
AS --Encrypt

/*
|| When      Who Rel      What
|| 11/06/06  RTC 8.4      Added TimeKey parameter needed to return new GUID generated.
|| 12/20/06  RTC 8.4      Added validation to prevent time entries outside the timesheet period.
|| 3/7/07    CRG 8.4.0.6  Added validation to ensure TimeSheetKey still exists when attempting to insert time.
|| 7/5/07    CRG 8.4.3.1  (9657) Added validation to ensure DetailTaskKey is still valid for the ProjectKey.
|| 04/14/08  GHL 8.508    (24776) Added similar validation to ensure that DetailTaskKey valid for the budget task
|| 05/29/08  GHL 8.512    Updating now DetailTaskKey when possible to help with the traffic screens
||                        In time entry, this is not updated but in one case, that can be done
|| 07/17/08  GHL 10.005   (30569) Catch situations where TaskKey is null and DetailTaskKey is not null
|| 08/01/08  RTC 10.0.0.6 (31250) Handle Bad Data In tProject.GetRateFrom column
|| 08/11/08  GHL 10.0.0.6  Calling now sptTimeInsertFixTaskKeys for task validations
|| 06/03/09  GHL 10.0.2.6 (54265) calling now sptTimeGetRate, unique point to get rate in the app
|| 10/30/09  RLB 10.5.1.3  If a null ratelevel is passed in set it to 1 
|| 01/12/10 GHL 10.516  (72043) Added patch to fix StartTime on wrong date
|| 06/15/10 MAS 10.5.3.1  (82999) Check for require comments pref
|| 09/1/10  GWG 10.5.3.4  Fixed an issue on the join to tPref for contactors where the cost rates would come in null
|| 10/7/10  CRG 10.5.3.6  Added @Verified
|| 06/19/12 RLB 10.5.5.7  HMI Change...and what is that change????
|| 11/07/12 RLB 10.5.6.2  (148135) added check for new option Check GLCloseDate
|| 02/04/13 GHL 10.564    (167256) Validate project on task           
|| 03/12/13 GHL 10.565    (171480) Cannot have RateLevel = 0 
|| 08/30/13 GHL 10.571    Added update of multi currency fields      
|| 09/04/13 GHL 10.572    Take in account GLCompanyKey for currency rate     
|| 09/19/13 GHL 10.572    Modification of sptCurrencyGetRate params (added rate history)                   
|| 09/30/14 GHL 10.584    Added update of TitleKey for Abelson Taylor
|| 03/10/15 GHL 10.590    Added update of DepartmentKey for Abelson Taylor
*/


 DECLARE @ActualRate money,
   @GetRateFrom smallint,
   @OverrideRate tinyint,
   @CompanyKey int,
   @TimeRateSheetKey int,
   @RateSheetRate money,
   @CostRate money,
   @ProjectStatusKey int,
   @RequireTimeDetails int,
   @RequireCommentsOnTime int,
   @StartDate smalldatetime,
   @EndDate smalldatetime,
   @RetVal int,
   @MultiCompanyCloseDate int,
   @NoTimeBeforeGLCloseDate int,
   @GLCloseDate smalldatetime,
   @GLCompanyKey int,
   @MultiCurrency int,
   @HomeCurrencyID varchar(10),
   @ProjectCurrencyID varchar(10),
   @CurrencyID varchar(10),
   @ExchangeRate decimal(24,7),
   @HCostRate money, -- in Home Currency
   @RateHistory int, -- used in UI, needed for sptCurrencyGetRate 
   @TitleKey int,
   @DepartmentKey int


	select  @StartDate = StartDate
	       ,@EndDate = EndDate
	from	tTimeSheet (nolock)
	where	TimeSheetKey = @TimeSheetKey
	
	--If TimeSheetKey doesn't exist, return error
	if @StartDate is null and @EndDate is null
		return -10
	
	if @WorkDate < @StartDate or @WorkDate > @EndDate
		return -10
			
	SELECT	@CostRate = ISNULL(u.HourlyCost, 0)
			,@HCostRate = ISNULL(u.HourlyCost, 0)
			,@RequireTimeDetails = ISNULL(u.RequireUserTimeDetails, 0)
			,@RequireCommentsOnTime = ISNULL(pref.RequireCommentsOnTime, 0)
			,@MultiCompanyCloseDate = ISNULL(pref.MultiCompanyClosingDate, 0)
			,@NoTimeBeforeGLCloseDate = ISNULL(pref.NoTimeBeforeGLCloseDate, 0)	
			,@GLCloseDate = pref.GLClosedDate
			,@MultiCurrency = isnull(pref.MultiCurrency, 0)
			,@HomeCurrencyID = pref.CurrencyID -- will not be null if MC = 1
			,@CompanyKey = pref.CompanyKey
			,@TitleKey = u.TitleKey
	FROM   tUser u (NOLOCK)
		INNER JOIN tPreference pref (NOLOCK) ON ISNULL(u.OwnerCompanyKey, u.CompanyKey) = pref.CompanyKey 
	WHERE  UserKey = @UserKey

select @GLCompanyKey = GLCompanyKey 
		,@ProjectCurrencyID = CurrencyID
		,@GetRateFrom = GetRateFrom
from tProject (nolock) 
where ProjectKey = @ProjectKey
	
-- check for new restrict on GLCloseDate
if @NoTimeBeforeGLCloseDate = 1
begin
	if @MultiCompanyCloseDate = 1
	begin
		if ISNULL(@ProjectKey, 0) > 0
		begin
			if ISNULL(@GLCompanyKey, 0) > 0
				select @GLCloseDate = GLCloseDate from tGLCompany (nolock) where GLCompanyKey = @GLCompanyKey

			if @GLCloseDate is not null
				if @WorkDate < @GLCloseDate
					return -12
		end		
	end
	else
	begin
		if @GLCloseDate is not null 
			if @WorkDate < @GLCloseDate
				return -12
	end
end

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

  IF @RequireTimeDetails = 1
  BEGIN
	IF @StartTime IS NULL
		RETURN -200

	IF @EndTime IS NULL
		RETURN -201		
  END
  
  IF @RequireCommentsOnTime = 1
  BEGIN
  	IF @Comments IS NULL
		RETURN -202
  END  
  
  if isnull(@RateLevel, 0) = 0
	Select @RateLevel = 1

   
 -- validations + update detail task key when possible  
 -- parameters are both input and output
 exec sptTimeInsertFixTaskKeys @ProjectKey, @TaskKey output, @DetailTaskKey output 
   
 if @TaskKey >0
 begin
	if exists (select 1 from tTask (nolock)
				where TaskKey = @TaskKey
				and   ProjectKey <> @ProjectKey)
		return -203
 end

 -- calling now the centralized function to determine the rate, param 1 indicates checking of TimeActive
 exec @RetVal = sptTimeGetRate @UserKey, @ProjectKey, @TaskKey, @ServiceKey, @RateLevel, 1, @ActualRate output
 
 if @RetVal <> 1
	return @RetVal


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

exec sptTimeGetDepartment @UserKey, @ServiceKey, @DepartmentKey output

 SELECT @TimeKey = NEWID()
     
 INSERT tTime
  (TimeKey,
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
  DetailTaskKey,
  Verified,
  CurrencyID,
  ExchangeRate,
  HCostRate,
  TitleKey,
  DepartmentKey
  )
 VALUES
  (@TimeKey,
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
  @ActualRate,
  @Comments,
  @CostRate,
  @DetailTaskKey,
  @Verified,
  @CurrencyID,
  @ExchangeRate,
  @HCostRate,
  @TitleKey,
  @DepartmentKey
  )
 RETURN 1
GO
