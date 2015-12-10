USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerUpdateTime]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerUpdateTime]
	@TimeKey uniqueidentifier,
	@WorkDate smalldatetime,
	@StartTime smalldatetime,
	@EndTime smalldatetime,
	@UserKey int,
	@SetVerified tinyint = 1, --Default it to true
	@Copy tinyint = 0
AS

/*
|| When      Who Rel      What
|| 6/18/10   CRG 10.5.3.0 Created for time drag and drop from the calendar
|| 8/11/10   CRG 10.5.3.3 Modified to set Verified to 1 as long as all required fields have values and the user is updating their own record.
|| 8/30/10   CRG 10.5.3.4 Modified to get the TimeSheetKey everytime in case they dropped the time into a new time sheet period.
|| 9/24/10   CRG 10.5.3.5 Added @SetVerified parameter to add the ability to update time from drag/drop and NOT set Verified to 1.
|| 5/23/11   CRG 10.5.4.4 Added @Copy parmameter to allow a time entry to be copied.
|| 9/13/11   CRG 10.5.4.8 (120439) Fixed Duration calculation because DATEDIFF and DATEADD with hh returns an int
|| 9/19/12   RLB 10.5.5.7  Pull RequireUserTimeDetail from user instead of RequireTimeDetail from Company Pref
|| 11/13/14  CRG 10.5.8.6 (236307) Fixed bug where it was getting the time sheet based on the logged in user instead of the user who the time entry belongs to.
*/

	DECLARE	@TimeSheetKey int,
			@CompanyKey int,
			@TimeUserKey int
	
	SELECT	@CompanyKey = ts.CompanyKey,
			@TimeUserKey = ts.UserKey
	FROM	tTimeSheet ts (nolock)
	INNER JOIN tTime t (nolock) ON ts.TimeSheetKey = t.TimeSheetKey
	WHERE	TimeKey = @TimeKey

	EXEC sptTimeSheetGetByDate @CompanyKey, @TimeUserKey, @WorkDate, @TimeSheetKey output

	IF @TimeSheetKey < 0
		RETURN -1

	IF @Copy = 1
	BEGIN
		DECLARE	@RetVal int,
				@NewTimeKey uniqueidentifier,
				@Duration decimal(24, 4)
		
		EXEC @RetVal = sptTimeCopy @TimeKey, @TimeSheetKey, @NewTimeKey output
		
		IF @RetVal < 0
			RETURN @RetVal

		--On a copy, the StartTime and EndTime come in equal because of how the drag/drop work on the calendar.
		--So we need to get the duration of the original time entry first
		IF @StartTime IS NOT NULL
		BEGIN
			SELECT	@Duration = 
						CASE
							WHEN StartTime IS NULL THEN 1
							ELSE DATEDIFF(mi, StartTime, EndTime) / 60.0
						END
			FROM	tTime (nolock)
			WHERE	TimeKey = @TimeKey

			SELECT	@EndTime = DATEADD(mi, @Duration * 60, @StartTime)
		END

		SELECT	@TimeKey = @NewTimeKey
	END

	IF @StartTime IS NULL
		UPDATE	tTime
		SET		TimeSheetKey = @TimeSheetKey,
				WorkDate = @WorkDate
		WHERE	TimeKey = @TimeKey
	ELSE
	BEGIN
		UPDATE	tTime
		SET		TimeSheetKey = @TimeSheetKey,
				WorkDate = @WorkDate,
				StartTime = @StartTime,
				EndTime = @EndTime,
				ActualHours = DATEDIFF(mi, @StartTime, @EndTime) / 60.0
		WHERE	TimeKey = @TimeKey

		DECLARE	@ProjectKey int
		SELECT	@ProjectKey = ProjectKey
		FROM	tTime (nolock)
		WHERE	TimeKey = @TimeKey

		IF @ProjectKey IS NOT NULL
			EXEC sptProjectRollupUpdate @ProjectKey, 1, 1, 1, 1, 1
	END

	--Now determine whether verified can be marked
	DECLARE @Comments varchar(2000),
			@ServiceKey int
			
	SELECT	@Comments = Comments,
			@ServiceKey = ServiceKey,
			@StartTime = StartTime, --Can't use the parms because if dragged/dropped between days on the calendar, these parms will be null coming in
			@EndTime = EndTime
	FROM	tTime (nolock)
	WHERE	TimeKey = @TimeKey

	IF @SetVerified = 1
	BEGIN
		IF @UserKey = @TimeUserKey
		BEGIN
			DECLARE	@RequireTimeDetails tinyint,
					@RequireCommentsOnTime tinyint,
					@ReqServiceOnTime tinyint

			SELECT @RequireTimeDetails = u.RequireUserTimeDetails
			FROM tUser u (nolock)
			WHERE u.UserKey = @UserKey

			SELECT	@RequireCommentsOnTime = p.RequireCommentsOnTime
			FROM	tPreference p (nolock)
			WHERE	CompanyKey = @CompanyKey

			SELECT	@ReqServiceOnTime = topt.ReqServiceOnTime
			FROM	tTimeOption topt (nolock)
			WHERE	CompanyKey = @CompanyKey

			IF @RequireTimeDetails = 1
			BEGIN
				IF @StartTime IS NULL
					SELECT @SetVerified = 0
				IF @EndTime IS NULL
					SELECT @SetVerified = 0
			END

			IF @RequireCommentsOnTime = 1
				IF ISNULL(@Comments, '') = ''
					SELECT @SetVerified = 0

			IF @ReqServiceOnTime = 1
				IF ISNULL(@ServiceKey, 0) = 0
					SELECT @SetVerified = 0

			IF @SetVerified = 1
				UPDATE	tTime
				SET		Verified = 1
				WHERE	TimeKey = @TimeKey
		END
	END
GO
