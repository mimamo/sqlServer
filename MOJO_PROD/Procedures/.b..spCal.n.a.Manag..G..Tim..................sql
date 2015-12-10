USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerGetTime]    Script Date: 12/10/2015 10:54:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerGetTime]
	@UserKey int = NULL,
	@StartDate smalldatetime = NULL,
	@EndDate smalldatetime = NULL,
	@TimeKey uniqueidentifier = NULL
AS

/*
    This is used in 2 modes:
      * UserKey, StartDate, and EndDate is not null; TimeKey is null: Gets all Time for the User within the date range
      * UserKey, StartDate, and EndDate are null; TimeKey is not null: Gets the Time entry for the specified TimeKey
    Since this SP has all of the logic for Billed, WipPost, etc., I'm using it for both modes rather than writing another one to return one record
*/

/*
|| When      Who Rel      What
|| 6/16/10   CRG 10.5.3.1 Created for the CalendarManager to get Time for a user
|| 9/15/10   CRG 10.5.3.5 Added DetailTaskName
|| 1/23/12   CRG 10.5.5.2 Fixed logic for WipPost flag
|| 06/12/12  GHL 10.5.5.7 Rearranged queries to better use indexes and limit the reading of tTime
*/

	CREATE TABLE #Time
			(TimeKey uniqueidentifier NULL,
			TimeSheetKey int NULL,

			InvoiceLineKey int null,
			WIPPostingInKey int NULL,
			WIPPostingOutKey int null,
			BillingDetail tinyint NULL
			)

	declare @CompanyKey int -- needed for tBilling
	IF @TimeKey IS NOT NULL
		SELECT @UserKey = UserKey from tTime (nolock) where TimeKey = @TimeKey

	select @CompanyKey = isnull(OwnerCompanyKey, CompanyKey) from tUser (nolock) where UserKey = @UserKey

	IF @TimeKey IS NULL
		-- use Index 6
		INSERT	#Time (TimeKey, TimeSheetKey)
		SELECT	TimeKey, TimeSheetKey
		FROM	tTime t (nolock)
		WHERE	t.UserKey = @UserKey
		AND		t.WorkDate BETWEEN @StartDate AND @EndDate
	ELSE
		INSERT	#Time (TimeKey, TimeSheetKey)
		SELECT	TimeKey, TimeSheetKey
		FROM	tTime t (nolock)
		WHERE	t.TimeKey = @TimeKey

	-- use index 24
	update #Time
	set    #Time.InvoiceLineKey = tTime.InvoiceLineKey 
	      ,#Time.WIPPostingInKey = tTime.WIPPostingInKey
		  ,#Time.WIPPostingOutKey = tTime.WIPPostingOutKey
	from   tTime (nolock)
	where  tTime.TimeKey = #Time.TimeKey		   

	update #Time
	set    #Time.BillingDetail = 1
	from   tBilling b (nolock)
		inner join tBillingDetail bd (nolock) on b.BillingKey = bd.BillingKey
	where  b.CompanyKey = @CompanyKey
	and    bd.Entity = 'tTime'
	and    bd.EntityGuid = #Time.TimeKey
	AND	   b.Status < 5

	CREATE TABLE #TimeSheets
			(TimeSheetKey int NULL,
			UserKey int NULL,
			WipPost tinyint NULL,
			Billed tinyint NULL,
			BillingDetail tinyint NULL,
			RegisteredUser tinyint NULL,
			Status smallint NULL)

	INSERT	#TimeSheets
			(TimeSheetKey)
	SELECT DISTINCT TimeSheetKey
	FROM	#Time

	UPDATE	#TimeSheets
	SET		UserKey = ts.UserKey,
			Status = ts.Status
	FROM	tTimeSheet ts (nolock)
	WHERE	#TimeSheets.TimeSheetKey = ts.TimeSheetKey
	
	UPDATE	#TimeSheets
	SET		WipPost = 1
	FROM    #Time
	WHERE   #TimeSheets.TimeSheetKey = #Time.TimeSheetKey
	AND     (isnull(WIPPostingInKey,0) <> 0 OR isnull(WIPPostingOutKey, 0) <> 0)

	UPDATE	#TimeSheets
	SET		Billed = 1
	FROM    #Time
	WHERE   #TimeSheets.TimeSheetKey = #Time.TimeSheetKey
	AND     InvoiceLineKey > 0 

	UPDATE	#TimeSheets
	SET		#TimeSheets.BillingDetail = 1
	FROM    #Time
	WHERE   #TimeSheets.TimeSheetKey = #Time.TimeSheetKey
	AND     #Time.BillingDetail = 1

	UPDATE	#TimeSheets
	SET		#TimeSheets.WipPost = isnull(#TimeSheets.WipPost, 0)
	       ,#TimeSheets.Billed = isnull(#TimeSheets.Billed, 0)
		   ,#TimeSheets.BillingDetail = isnull(#TimeSheets.BillingDetail, 0)

	UPDATE	#TimeSheets
	SET		RegisteredUser = 
				CASE
					WHEN EXISTS
						(SELECT	NULL
						FROM	tUser (nolock)
						WHERE	UserKey = #TimeSheets.UserKey
						AND		Len(UserID) > 0
						AND		Active = 1 
						AND		ClientVendorLogin = 0) THEN 1
					ELSE 0
				END
	
	SELECT	t.*,
			u.TimeZoneIndex,
			CASE 
				WHEN t.ProjectKey IS NOT NULL THEN ISNULL(p.ProjectNumber, '') + '-' + ISNULL(p.ProjectName, '')
				ELSE NULL
			END AS ProjectName, --We only need to do a case on Project because the flex code checks for ProjectName, then shows Project, Task, Client
			ISNULL(tsk.TaskID, '') + '-' + ISNULL(tsk.TaskName, '') AS TaskName,
			ISNULL(dt.TaskID, '') + '-' + ISNULL(dt.TaskName, '') AS DetailTaskName,
			ISNULL(c.CustomerID, '') + '-' + ISNULL(c.CompanyName, '') AS Client,
			#TimeSheets.*
	FROM	tTime t (nolock)
	INNER JOIN #Time ON t.TimeKey = #Time.TimeKey
	INNER JOIN #TimeSheets ON t.TimeSheetKey = #TimeSheets.TimeSheetKey
	INNER JOIN tUser u (nolock) ON t.UserKey = u.UserKey
	LEFT JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey
	LEFT JOIN tTask tsk (nolock) ON t.TaskKey = tsk.TaskKey
	LEFT JOIN tTask dt (nolock) ON t.DetailTaskKey = dt.TaskKey
	LEFT JOIN tCompany c (nolock) ON p.ClientKey = c.CompanyKey
GO
