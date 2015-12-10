USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeSheetGetByDate]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeSheetGetByDate]
	@CompanyKey int,
	@UserKey int,
	@Date smalldatetime,
	@TimeSheetKey int output,
	@CreateNewTimeSheet tinyint = 1
AS


/*
|| When      Who Rel      What
|| 8/26/09   GWG 10.5.0.8 Modified the signature for calling timesheet insert
|| 7/18/11   CRG 10.5.4.6 Now removing the time portion from WorkDate because it causes problems with 1 day time sheets.
|| 08/17/11  MFT 10.5.4.7 Added @MustInclude (@Date) param to spLoadTimePeriods exec (119120)
|| 01/29/12  RLB 10.5.6.4 (165815) added optional parm for creating Timesheets
*/

	SELECT  @Date = dbo.fFormatDateNoTime(@Date)

	DECLARE	@AllowOverlap tinyint,
			@BeginPeriod smalldatetime,
			@EndPeriod smalldatetime

	--See if an unapproved time sheet already exists for this user and date
	SELECT	@TimeSheetKey = MIN(TimeSheetKey)
	FROM	tTimeSheet (NOLOCK)
	WHERE	UserKey = @UserKey
	AND		@Date BETWEEN StartDate AND EndDate
	AND		Status IN (1,3)
	
	IF @TimeSheetKey IS NOT NULL
		RETURN 1
		
	--See if a time sheet already exists but was approved or submitted
	SELECT	@TimeSheetKey = MIN(TimeSheetKey)
	FROM	tTimeSheet (NOLOCK)
	WHERE	UserKey = @UserKey
	AND		@Date BETWEEN StartDate AND EndDate
	AND		Status NOT IN (1,3)
	
	IF @TimeSheetKey IS NOT NULL
	BEGIN
		SELECT	@AllowOverlap = AllowOverlap
		FROM	tTimeOption (NOLOCK)
		WHERE	CompanyKey = @CompanyKey
		
		IF @AllowOverlap = 0
			RETURN -1 --A TimeSheet already exists for this date, and overlap is not allowed.
	END

	IF @CreateNewTimeSheet = 1
	BEGIN

		--Create a new TimeSheet for the date
		--Create a temp table for the create TimeSheet SP
		CREATE TABLE #TimePeriods
			(BeginPeriod smalldatetime null,
			EndPeriod smalldatetime null,
			AlreadyCreated char(50) null)

		EXEC spLoadTimePeriods @CompanyKey, @UserKey, 7, @Date
	
		SELECT	@BeginPeriod = BeginPeriod,
				@EndPeriod = EndPeriod
		FROM	#TimePeriods
		WHERE	@Date BETWEEN BeginPeriod AND EndPeriod
	
		IF @BeginPeriod IS NOT NULL
			EXEC @TimeSheetKey = sptTimeSheetInsert
				@CompanyKey,
				@UserKey,
				@BeginPeriod, --@StartDate
				@EndPeriod, --@EndDate
				1, --@Status
				NULL, --@ApprovalComments
				@Date, --@DateCreated
				NULL, --@DateSubmitted
				NULL --@DateApproved

		RETURN 1
	END
	ELSE
	BEGIN
		-- If not creating a Timesheet and there is none return -1 so timesheetkey is set to 0

		RETURN 0

	END
GO
