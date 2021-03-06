USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeSaveTimeTracker]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeSaveTimeTracker]
	@UserKey int,
	@WorkDate smalldatetime,
	@TimeSheetKey int,
	@TimeKey uniqueidentifier,
	@ProjectKey int,
	@DetailTaskKey int,
	@BudgetTaskKey int,
	@ActualHours decimal(24,4),
	@PauseHours decimal(24,4),
	@RateLevel int,
	@ServiceKey int,
	@BillingComments varchar(2000),
	@StartTime smalldatetime,
	@EndTime smalldatetime,
	@ActStart smalldatetime,
	@ActComplete smalldatetime,
	@PercComp int,
	@StatusComments varchar(4000),
	@TaskUserKey int = null,
	@Verified tinyint = 1,
	@UpdateTask tinyint = 1, --preserve old behavior
	@TaskUpdated tinyint output, --Set to 1 if the task has been updated
	@UpdatedTimeKey uniqueidentifier output --If insert, it's the new TimeKey. If update, it's the TimeKey passed in.
AS --Encrypt

/*
|| When      Who Rel      What
|| 3/21/08   CRG 1.0.0.0  Created for the new Time Tracker widget. This utilizes existing SP's so all business logic is maintained
|| 4/29/08   CRG 1.0.0.0  Added PauseHours
|| 5/20/08   GWG 1.0.0.0  Added updating of start and end time
|| 5/21/08   CRG 10.0.0.0 Now updating WorkDate on existing Time records
|| 10/07/08  GHL 10.0.1.2 (39475) Updating tTime.TimeSheetKey also, in case they change the WorkDate outside
||                         of the current timesheet, a new time sheet is obtained and must be update
|| 11/19/08  GHL 10.0.1.3 (40771) Project was not rescheduled after update
||                         Added protection against null values when comparing dates
|| 06/03/09  GHL 10.0.2.6 (54265) calling now sptTimeGetRate, unique point to get rate in the app
|| 10/07/09 GHL 10.512  (65041) Bubble up the errors to the UI
|| 01/12/10 GHL 10.516  (72043) Added patch to fix StartTime on wrong date
|| 7/15/10  RLB 10.532  (85315) saving time entry if actual hours > 0 or there is a billing comment
|| 7/16/10  GHL 10.532  (85315) changed @BillingComments is not null to isnull(@BillingComments, '') <> ''
|| 07/19/10 GHL 10.532  Added TaskUserKey param to handle cases of user assigned several times to the task
|| 8/11/10  CRG 10.5.3.3 Now always setting verified to 1 on the time records because this is only called when the user themselves is updating their time
|| 8/13/10  CRG 10.5.3.3 Added @UpdatedTimeKey to pass back the TimeKey (mainly needed if it's a new time record)
|| 9/24/10  CRG 10.5.3.5 Added @Verified parameter because we are now also adding unverified time entries from sptTimeSaveTimeTracker.
|| 3/16/11  RLB 10.5.4.2 Moved a portions of the SP up because the SP's set actStart and and End and i wanted to get the original data before the insert or update
|| 7/18/11  CRG 10.5.4.6 Now removing the time portion from WorkDate because it causes problems with 1 day time sheets.
|| 10/10/11 RLB 10.5.4.9 (123231) Adding Status comments if it was the only part task detail updated
|| 11/07/12 RLB 10.5.6.2  (148135) added check for new option Check GLCloseDate
|| 04/24/13 GHL 10.567   (167212) Added ActualHours to sptTimeUpdate so that we can change hours in the Transactions flex screen       
|| 08/30/13 GHL 10.571   Added update of multi currency fields   
|| 09/04/13 GHL 10.572   Take in account GLCompanyKey for currency rate   
|| 09/19/13 GHL 10.572   Modification of sptCurrencyGetRate params (added rate history)    
|| 01/13/14 GHL 10.575   (202570) Corrected params to sptTimeUpdate because the they have changed 
|| 12/16/14 RLB 10.587   (239570) allowed blanking of status comments                                         
*/

declare  @MultiCurrency int,
   @HomeCurrencyID varchar(10),
   @ProjectCurrencyID varchar(10),
   @CurrencyID varchar(10),
   @ExchangeRate decimal(24,7),
   @CostRate money, 
   @HCostRate money, -- in Home Currency
   @RateHistory int -- used in UI, needed for sptCurrencyGetRate 

SELECT  @WorkDate = dbo.fFormatDateNoTime(@WorkDate)

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

	DECLARE	@ActualRate money, @RetVal int, @OldActStart smalldatetime, @OldActComplete smalldatetime, @OldPercComp int, @PercCompSeparate tinyint, @Found tinyint, @OldStatusComments varchar(4000)
	
	SELECT @TaskUpdated = 0, @Found = 0
		
	-- We have a detailkey, so find out if we can update
	IF @DetailTaskKey IS NOT NULL
	BEGIN			
		SELECT	@PercCompSeparate = PercCompSeparate,
				@OldActStart = ActStart,
				@OldActComplete = ActComplete,
				@OldPercComp = PercComp,
				@OldStatusComments = Comments
		FROM	tTask (nolock)
		WHERE	TaskKey = @DetailTaskKey

		-- If tracking separately, get the specific dates
		IF @PercCompSeparate = 1
		BEGIN
			IF ISNULL(@TaskUserKey, 0) > 0 

				-- Track separate, but no specific TaskUserKey, find out if we are assigned
				if exists(Select 1 from tTaskUser (nolock) WHERE TaskKey = @DetailTaskKey AND UserKey = @UserKey)
				BEGIN
					SELECT	@OldActStart = ActStart,
							@OldActComplete = ActComplete,
							@OldPercComp = PercComp,
							@Found = 1
					FROM	tTaskUser (nolock)
					WHERE	TaskKey = @DetailTaskKey
					AND		UserKey = @UserKey
				END
			ELSE
				SELECT	@OldActStart = ActStart,
						@OldActComplete = ActComplete,
						@OldPercComp = PercComp,
						@Found = 1
				FROM	tTaskUser (nolock)
				WHERE	TaskUserKey = @TaskUserKey
		END
		ELSE
		BEGIN
			-- Case where perccompsep = 0
			Select @Found = 1
		END

		DECLARE @NullDummy datetime
		SELECT @NullDummy = GETDATE()

		if @Found = 1
		BEGIN
			if @UpdateTask = 1
			BEGIN
				-- We found the original and we can update, but actuals from the UI were passed in
				IF	ISNULL(@ActStart, @NullDummy)       <> ISNULL(@OldActStart, @NullDummy)  
					OR ISNULL(@ActComplete, @NullDummy) <> ISNULL(@OldActComplete, @NullDummy) 
					OR ISNULL(@PercComp, 0)             <> ISNULL(@OldPercComp, 0)
					SELECT @TaskUpdated = 1

				IF	ISNULL(@StatusComments, '') <> ISNULL(@OldStatusComments, '')
					SELECT @TaskUpdated = 1

			END
			ELSE
			BEGIN
				-- found something to update, but no actuals from the UI, test if ActStart needs to be set
				if @ActStart is null and @ActualHours <> 0
					Select @ActStart = dbo.fFormatDateNoTime(GETDATE()), @ActComplete = NULL, @PercComp = 0, @TaskUpdated = 1


			END
		END
	END

	IF @ActualHours <> 0 Or isnull(@BillingComments, '') <> ''
	BEGIN
		IF @TimeKey IS NOT NULL
			BEGIN
				--Update the existing time entry
				-- check for new restrict on GLCloseDate on update only since there is a check on insert
				DECLARE  @MultiCompanyCloseDate int,
						 @NoTimeBeforeGLCloseDate int,
						 @GLCloseDate smalldatetime,
						 @GLCompanyKey int,
						 @CompanyKey int

				SELECT	 @CostRate = ISNULL(u.HourlyCost, 0)
						,@HCostRate = ISNULL(u.HourlyCost, 0)
						,@MultiCompanyCloseDate = ISNULL(pref.MultiCompanyClosingDate, 0)
						,@NoTimeBeforeGLCloseDate = ISNULL(pref.NoTimeBeforeGLCloseDate, 0)	
						,@GLCloseDate = pref.GLClosedDate
						,@CompanyKey = pref.CompanyKey
						,@MultiCurrency = isnull(pref.MultiCurrency, 0)
						,@HomeCurrencyID = CurrencyID -- will not be null if MC = 1					
				FROM   tUser u (NOLOCK)
				INNER JOIN tPreference pref (NOLOCK) ON ISNULL(u.OwnerCompanyKey, u.CompanyKey) = pref.CompanyKey 
				WHERE  UserKey = @UserKey
				
				select @GLCompanyKey = GLCompanyKey 
						,@ProjectCurrencyID = CurrencyID
				from tProject (nolock) 
				where ProjectKey = @ProjectKey

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

				UPDATE	tTime
				SET		ActualHours = @ActualHours,
						PauseHours = @PauseHours,
						StartTime = @StartTime,
						EndTime = @EndTime,
						WorkDate = @WorkDate,
						TimeSheetKey = @TimeSheetKey,
						Verified = @Verified,
						CurrencyID = @CurrencyID,
						ExchangeRate = @ExchangeRate,
						HCostRate = @HCostRate
				WHERE	TimeKey = @TimeKey

				 -- calling now the centralized function to determine the rate, param 1 indicates checking of TimeActive
				exec @RetVal = sptTimeGetRate @UserKey, @ProjectKey, @BudgetTaskKey, @ServiceKey, @RateLevel, 1, @ActualRate output

				if @RetVal < 0
					return @RetVal
					
                -- we could bubble up error from sptTimeGetRate but this sp does not return any, so best attempt to get rate
				SELECT	@ActualRate = ISNULL(@ActualRate, 0)
				
				--Call sptTimeUpdate because it has all of the logic to call ProjectRollup			
				EXEC sptTimeUpdate
						@TimeKey,
						@ProjectKey,
						@BudgetTaskKey,
						@ServiceKey,
						@RateLevel,
						@ActualRate,
						2, --@Mode
						@BillingComments
					
			END
		ELSE
			BEGIN
				--Insert a Time Entry
				EXEC @RetVal = sptTimeInsertFromDashboardWidget
						@UserKey,
						@ProjectKey,
						@BudgetTaskKey,
						@DetailTaskKey,
						@TimeSheetKey,
						@WorkDate,
						@ActualHours,
						@PauseHours,
						@ServiceKey,
						@RateLevel,
						@BillingComments,
						@StartTime,
						@EndTime,
						@Verified,
						@TimeKey output

				if @RetVal < 0
					return @RetVal						
						
			END	
	END
		
	IF @DetailTaskKey IS NOT NULL AND @TaskUpdated = 1
		BEGIN
		
			--Update the Task Record using sptTaskUpdateActual
			EXEC sptTaskUpdateActual
					@DetailTaskKey,
					@UserKey,
					@ActStart,
					@ActComplete,
					@PercComp,
					@StatusComments,
					@TaskUserKey
		END
		
	SELECT @UpdatedTimeKey = @TimeKey
		
	RETURN 1
GO
