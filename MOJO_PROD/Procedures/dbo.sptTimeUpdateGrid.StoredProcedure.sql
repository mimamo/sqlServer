USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeUpdateGrid]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTimeUpdateGrid]
 @TimeSheetKey int,
 @TimeKey uniqueidentifier,
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
 @Verified tinyint = NULL,
 @MobileUpdate tinyint = 0
 
AS --Encrypt


/*
|| When      Who Rel     What
|| 11/07/06  RTC 8.4     Update any entry that was a result of a timesheet copy (Actula Hours = 0).  
||                       The entries will be deleted when the time sheet is submitted for approval or approved
|| 7/5/07    CRG 8.4.3.1 (9657) Added validation to ensure DetailTaskKey is still valid for the ProjectKey.
|| 04/14/08  GHL 8.508   (24776) Added similar validation to ensure that DetailTaskKey valid for the budget task
|| 08/11/08  GHL 10.0.0.6  Calling now sptTimeInsertFixTaskKeys for task validations
|| 06/03/09  GHL 10.0.2.6 (54265) calling now sptTimeGetRate, unique point to get rate in the app
|| 06/15/09  CRG 10.0.2.7 (53891) Not validating time details now if ActualHours = 0 or Comments = ''
|| 01/12/10 GHL 10.516  (72043) Added patch to fix StartTime on wrong date
|| 10/7/10  CRG 10.5.3.6  Added @Verified
|| 06/19/12 RLB 10.5.5.7  HMI Change 
|| 11/07/12 RLB 10.5.6.2  (148135) added check for new option Check GLCloseDate
|| 01/11/13 GHL 10.5.6.3  (164840) Added check of TransferToKey null before deleting
|| 02/04/13 GHL 10.564    (167256) Validate project on task   
|| 03/06/13 RLB 10.5.6.6  (170499) Fix for mobile update to an existing time entry   
|| 08/30/13 GHL 10.571    Added update of multi currency fields    
|| 09/04/13 GHL 10.572    Take in account GLCompanyKey for currency rate       
|| 09/19/13 GHL 10.572    Modification of sptCurrencyGetRate params (added rate history)                                 
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
   @OldActualHours decimal(24,4),
   @UpdateExisting smallint,
   @DetailTaskKey int,
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
   @DefaultDepartmentFromUser int,
   @DepartmentKey int,
   @OldServiceKey int

	-- assume we will update the existing time entry
	select @UpdateExisting = 1
	
	SELECT @CostRate = ISNULL(u.HourlyCost, 0)
			,@HCostRate = ISNULL(u.HourlyCost, 0)
			,@RequireTimeDetails = ISNULL(u.RequireUserTimeDetails, 0)	
			,@MultiCompanyCloseDate = ISNULL(pref.MultiCompanyClosingDate, 0)
			,@NoTimeBeforeGLCloseDate = ISNULL(pref.NoTimeBeforeGLCloseDate, 0)	
			,@GLCloseDate = pref.GLClosedDate	 
			,@MultiCurrency = isnull(pref.MultiCurrency, 0)
			,@HomeCurrencyID = CurrencyID -- will not be null if MC = 1		
			,@CompanyKey = pref.CompanyKey
			,@DefaultDepartmentFromUser = pref.DefaultDepartmentFromUser
	FROM   tUser u (NOLOCK)
		INNER JOIN tPreference pref (NOLOCK) ON ISNULL(u.OwnerCompanyKey, u.CompanyKey) = pref.CompanyKey  
	WHERE  UserKey = @UserKey

select @GLCompanyKey = GLCompanyKey 
		,@ProjectCurrencyID = CurrencyID
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

  IF @RequireTimeDetails = 1 AND (ISNULL(@ActualHours, 0) > 0 OR ISNULL(@Comments, '') <> '')
  BEGIN
	IF @StartTime IS NULL
		RETURN -200

	IF @EndTime IS NULL
		RETURN -201
		
	IF @Comments IS NULL
		RETURN -202
		
  END
   
 -- Read the detail task key from tTime since the grid does not update it
 select @DetailTaskKey = DetailTaskKey from tTime (nolock) where TimeKey = @TimeKey
   
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

 -- check if we need to retain a copied row with zero hours or delete an existing row updated to zero hours
 if @ActualHours = 0  
	begin
		select @OldActualHours = isnull(ActualHours,0)
		from tTime (nolock)
		where TimeKey = @TimeKey
		
		if @OldActualHours <> 0
			begin
				select @UpdateExisting = 0
				delete tTime
				where TimeKey = @TimeKey
				and   TransferToKey is null -- only if it was not transferred out
			end
	end

 if @UpdateExisting = 1
 BEGIN
	IF @Verified IS NULL
		SELECT	@Verified = Verified
		FROM	tTime (nolock)
		WHERE	TimeKey = @TimeKey

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

	select @DepartmentKey = DepartmentKey
	      ,@OldServiceKey = ServiceKey
	from   tTime (nolock)
	where  TimeKey = @TimeKey

	if isnull(@OldServiceKey, 0) <> isnull(@ServiceKey, 0) and isnull(@DefaultDepartmentFromUser, 0) = 0
		select @DepartmentKey = DepartmentKey
		from   tService (nolock)
		where  ServiceKey = @ServiceKey   

	IF @MobileUpdate = 1
	BEGIN
		Update tTime
		Set
		ProjectKey = @ProjectKey,
		TaskKey = @TaskKey,
		ServiceKey = @ServiceKey,
		RateLevel = @RateLevel,
		WorkDate = @WorkDate,
		StartTime = @StartTime,
		EndTime = @EndTime,
		ActualHours = @ActualHours,
		PauseHours = @PauseHours,
		ActualRate = @ActualRate,
		Comments = @Comments,
		CostRate = @CostRate,
		DetailTaskKey = @DetailTaskKey,
		TimeSheetKey = @TimeSheetKey, -- only difference with non mobile
		Verified = @Verified,
		CurrencyID = @CurrencyID,
		ExchangeRate = @ExchangeRate,
		HCostRate = @HCostRate,
		DepartmentKey = @DepartmentKey
	Where TimeKey = @TimeKey

	END
	ELSE
	BEGIN
		Update tTime
		Set
		ProjectKey = @ProjectKey,
		TaskKey = @TaskKey,
		ServiceKey = @ServiceKey,
		RateLevel = @RateLevel,
		WorkDate = @WorkDate,
		StartTime = @StartTime,
		EndTime = @EndTime,
		ActualHours = @ActualHours,
		PauseHours = @PauseHours,
		ActualRate = @ActualRate,
		Comments = @Comments,
		CostRate = @CostRate,
		DetailTaskKey = @DetailTaskKey,
		Verified = @Verified,
		CurrencyID = @CurrencyID,
		ExchangeRate = @ExchangeRate,
		HCostRate = @HCostRate,
		DepartmentKey = @DepartmentKey
	Where TimeKey = @TimeKey
	END
	
 END

 RETURN 1
GO
