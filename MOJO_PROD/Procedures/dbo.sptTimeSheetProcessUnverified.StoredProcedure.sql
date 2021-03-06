USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeSheetProcessUnverified]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeSheetProcessUnverified]
	@TimeSheetKey int
AS

/*
Return values:
1: Success
-1: Unverified Time exists
-2: Auto verify could not complete because of Time Options
*/

/*
|| When      Who Rel	  What
|| 10/06/10  RTC 10.5.3.6 Created to process the unverified time entries based on the company option in tPreference
|| 06/19/12 RLB 10.5.5.7  HMI Change 
*/

	--Option Constants
	DECLARE @THROW_ERROR int  SELECT @THROW_ERROR = 0
	DECLARE @AUTO_VERIFY int  SELECT @AUTO_VERIFY = 1
	DECLARE @REMOVE_UNVERIFIED int  SELECT @REMOVE_UNVERIFIED = 2

	DECLARE	@CompanyKey int
	SELECT	@CompanyKey = CompanyKey
	FROM	tTimeSheet (nolock)
	WHERE	TimeSheetKey = @TimeSheetKey

	DECLARE	@UnverifiedTimeOption smallint
	SELECT	@UnverifiedTimeOption = ISNULL(UnverifiedTimeOption, @THROW_ERROR)
	FROM	tPreference (nolock)
	WHERE	CompanyKey = @CompanyKey

	IF NOT EXISTS
			(SELECT	NULL
			FROM	tTime (nolock)
			WHERE	TimeSheetKey = @TimeSheetKey
			AND		ISNULL(Verified, 0) = 0)
		RETURN 1 --No unverified time, just return 1

	IF @UnverifiedTimeOption = @THROW_ERROR
		RETURN -1 --Just return error

	IF @UnverifiedTimeOption = @REMOVE_UNVERIFIED
	BEGIN
		DELETE	tTime
		WHERE	TimeSheetKey = @TimeSheetKey
		AND		ISNULL(Verified, 0) = 0
		
		RETURN 1
	END

	--If we've made it to here, then the option is auto verify
	DECLARE	@UserKey int,
			@RequireTimeDetails tinyint,
			@RequireCommentsOnTime tinyint

	SELECT	@UserKey = UserKey
	FROM	tTimeSheet (nolock)
	WHERE	TimeSheetKey = @TimeSheetKey

	SELECT	@RequireTimeDetails = ISNULL(u.RequireUserTimeDetails, 0),
			@RequireCommentsOnTime = ISNULL(pref.RequireCommentsOnTime, 0)				
	FROM	tUser u (nolock)
	INNER JOIN tPreference pref (nolock) ON ISNULL(u.OwnerCompanyKey, u.CompanyKey) = pref.CompanyKey 
	WHERE	UserKey = @UserKey

	--If time options prevent the time entries from being auto verified, return -2
	IF EXISTS
			(SELECT	NULL
			FROM	tTime (nolock)
			WHERE	TimeSheetKey = @TimeSheetKey
			AND		ISNULL(Verified, 0) = 0
			AND		((@RequireTimeDetails = 1 AND (StartTime IS NULL OR EndTime IS NULL))
					OR
					(@RequireCommentsOnTime = 1 AND Comments IS NULL)))
		RETURN -2

	--If we've made it here, then auto verify
	UPDATE	tTime
	SET		Verified = 1
	WHERE	TimeSheetKey = @TimeSheetKey
	AND		ISNULL(Verified, 0) = 0

	RETURN 1
GO
