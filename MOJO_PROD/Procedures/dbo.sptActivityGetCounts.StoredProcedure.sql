USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetCounts]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetCounts]
	(
	@CompanyKey int
	,@AsOfDate datetime
	,@AllActivityTypes int = 1
	,@AllAssignedUsers int = 1
	,@AllFolders int = 1
	,@UserKey int = NULL
	)
	
AS
	SET NOCOUNT ON
	
/*
|| When      Who Rel      What
|| 05/26/09  GHL 10.5.0.0 Creation for Activity Counts widget
|| 05/29/09  GHL 10.5.0.0 Added folder security and changed account managers to assigned users
|| 07/27/12  MFT 10.5.5.8 Added @UserKey param and GL Company restrictions
*/

	-- Assume done in VB
	--create table #activity_params (Entity varchar(20) null, EntityKey int null)
	-- Entity: tActivityType, tUser, tCMFolder
	
	-- we should be able to view activities without folders
	if @AllFolders = 0
		insert #activity_params (Entity, EntityKey)
		values ('tCMFolder', 0)
	
	--Flag for GL Company restrictions
	DECLARE @RestrictToGLCompany tinyint SELECT @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0) FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey

	-- I use a temp db here to limit the number of queries in the permanent tables (2 instead of 8 otherwise) 
	create table #activity(ActivityKey int null, ActivityDate datetime null, DateCompleted datetime null)  
	
	-- YTD Year To Date
	declare @YTDOpen int
	declare @YTDComplete int
	declare @YTDStartDate datetime
	declare @YTDEndDate datetime
		
	select @YTDStartDate = '01/01/' + cast(year(@AsOfDate) as varchar(10))
	select @YTDEndDate = '12/31/' + cast(year(@AsOfDate) as varchar(10))
	
	insert #activity(ActivityKey, ActivityDate, DateCompleted)
	select ActivityKey, ActivityDate, DateCompleted
	from   tActivity  (nolock)
	where  CompanyKey = @CompanyKey
	and    ActivityDate >= @YTDStartDate
	and    ActivityDate <= @YTDEndDate
	and    DateCompleted is null
	and    (@AllActivityTypes = 1 
				or 
			(ActivityTypeKey in (select EntityKey from #activity_params where Entity = 'tActivityType')) 
			)
	and    (@AllFolders = 1 
			or 
			(isnull(CMFolderKey, 0) in (select EntityKey from #activity_params where Entity = 'tCMFolder')) 
			)
	and    (@AllAssignedUsers = 1 
			or 
			(AssignedUserKey in (select EntityKey from #activity_params where Entity = 'tUser')) 
			or 
			(OriginatorUserKey in (select EntityKey from #activity_params where Entity = 'tUser')) 
			)
			
	
	insert #activity(ActivityKey, ActivityDate, DateCompleted)
	select ActivityKey, ActivityDate, DateCompleted
	from   tActivity  (nolock)
	where  CompanyKey = @CompanyKey
	and    DateCompleted >= @YTDStartDate
	and    DateCompleted <= @YTDEndDate
	and    (@AllActivityTypes = 1 
				or 
			(ActivityTypeKey in (select EntityKey from #activity_params where Entity = 'tActivityType')) 
			)
	and    (@AllFolders = 1 
			or 
			(isnull(CMFolderKey, 0) in (select EntityKey from #activity_params where Entity = 'tCMFolder')) 
			)
	and    (@AllAssignedUsers = 1 
			or 
			(AssignedUserKey in (select EntityKey from #activity_params where Entity = 'tUser')) 
			or 
			(OriginatorUserKey in (select EntityKey from #activity_params where Entity = 'tUser')) 
			)
	
	--Removed GL Company restricted records
	IF @RestrictToGLCompany = 1
		BEGIN
			DELETE FROM #activity
			WHERE ActivityKey NOT IN (
				SELECT ActivityKey
				FROM
					tActivity a (nolock)
					INNER JOIN tUserGLCompanyAccess ca (nolock) ON a.GLCompanyKey = ca.GLCompanyKey
				WHERE UserKey = @UserKey
			)
		END
	
	--select * from #activity 
	
	select @YTDOpen = count(*)
	from   #activity (nolock)
	where  DateCompleted is null
	
	select @YTDComplete = count(*)
	from   #activity (nolock)
	where  DateCompleted is not null	

	-- MTD Month To Date
	declare @MTDOpen int
	declare @MTDComplete int
	declare @MTDStartDate datetime
	declare @MTDEndDate datetime
		
	select @MTDStartDate = cast(month(@AsOfDate) as varchar(10)) + '/01/' + cast(year(@AsOfDate) as varchar(10))
	select @MTDEndDate = dateadd(m, 1, @MTDStartDate)
	select @MTDEndDate = dateadd(d, -1, @MTDEndDate)
	
	
	select @MTDOpen = count(*)
	from   #activity (nolock)
	where  ActivityDate >= @MTDStartDate
	and    ActivityDate <= @MTDEndDate
	and    DateCompleted is null
	
	select @MTDComplete = count(*)
	from   #activity (nolock)
	where  DateCompleted >= @MTDStartDate
	and    DateCompleted <= @MTDEndDate
	
	
	-- QTD Quarter To Date
	declare @QTDOpen int
	declare @QTDComplete int
	declare @QTDStartDate datetime
	declare @QTDEndDate datetime
	declare @QTDTemp1 datetime
	declare @QTDTemp2 datetime
		
	select @QTDEndDate = @AsOfDate
	
	select @QTDTemp1 ='01/01/' + cast(year(@AsOfDate) as varchar(10))
	select @QTDTemp2 ='04/01/' + cast(year(@AsOfDate) as varchar(10))
	select @QTDTemp2 = dateadd(d, -1, @QTDTemp2)
	
	if @AsOfDate >= @QTDTemp1 and @AsOfDate <= @QTDTemp2
		select @QTDStartDate = @QTDTemp1, @QTDEndDate = @QTDTemp2
				
	select @QTDTemp1 ='04/01/' + cast(year(@AsOfDate) as varchar(10))
	select @QTDTemp2 ='07/01/' + cast(year(@AsOfDate) as varchar(10))
	select @QTDTemp2 = dateadd(d, -1, @QTDTemp2)
	
	if @AsOfDate >= @QTDTemp1 and @AsOfDate <= @QTDTemp2
		select @QTDStartDate = @QTDTemp1, @QTDEndDate = @QTDTemp2
	
	select @QTDTemp1 ='07/01/' + cast(year(@AsOfDate) as varchar(10))
	select @QTDTemp2 ='10/01/' + cast(year(@AsOfDate) as varchar(10))
	select @QTDTemp2 = dateadd(d, -1, @QTDTemp2)
	
	if @AsOfDate >= @QTDTemp1 and @AsOfDate <= @QTDTemp2
		select @QTDStartDate = @QTDTemp1, @QTDEndDate = @QTDTemp2
	
	
	select @QTDTemp1 ='10/01/' + cast(year(@AsOfDate) as varchar(10))
	select @QTDTemp2 ='12/31/' + cast(year(@AsOfDate) as varchar(10))
	
	if @AsOfDate >= @QTDTemp1 and @AsOfDate <= @QTDTemp2
		select @QTDStartDate = @QTDTemp1, @QTDEndDate = @QTDTemp2
	
	select @QTDOpen = count(*)
	from   #activity (nolock)
	where  ActivityDate >= @QTDStartDate
	and    ActivityDate <= @QTDEndDate
	and    DateCompleted is null
	
	select @QTDComplete = count(*)
	from   #activity (nolock)
	where  DateCompleted >= @QTDStartDate
	and    DateCompleted <= @QTDEndDate
	
	-- WTD Week To date
	declare @WeekDay int
	declare @WTDOpen int
	declare @WTDComplete int
	declare @WTDStartDate datetime
	declare @WTDEndDate datetime
	
	select @WeekDay = datepart(weekday, @AsOfDate)
	if @WeekDay = 1 -- S
		select @WTDStartDate = @AsOfDate, @WTDEndDate = dateadd(d, 6, @AsOfDate)
	else if @WeekDay = 2 -- M
		select @WTDStartDate = dateadd(d, -1, @AsOfDate), @WTDEndDate = dateadd(d, 5, @AsOfDate)
	else if @WeekDay = 3 -- T
		select @WTDStartDate = dateadd(d, -2, @AsOfDate), @WTDEndDate = dateadd(d, 4, @AsOfDate)
	else if @WeekDay = 4 -- W
		select @WTDStartDate = dateadd(d, -3, @AsOfDate), @WTDEndDate = dateadd(d, 3, @AsOfDate)
	else if @WeekDay = 5 -- Th
		select @WTDStartDate = dateadd(d, -4, @AsOfDate), @WTDEndDate = dateadd(d, 2, @AsOfDate)
	else if @WeekDay = 6 -- F
		select @WTDStartDate = dateadd(d, -5, @AsOfDate), @WTDEndDate = dateadd(d, 1, @AsOfDate)
	else
		select @WTDStartDate = dateadd(d, -6, @AsOfDate), @WTDEndDate = @AsOfDate
	
	-- for some reasons, when adding days, we get hours
	select @WTDStartDate = convert(varchar(10), @WTDStartDate, 101)
	select @WTDEndDate = convert(varchar(10), @WTDEndDate, 101)
	
	
	select @WTDOpen = count(*)
	from   #activity (nolock)
	where  ActivityDate >= @WTDStartDate
	and    ActivityDate <= @WTDEndDate
	and    DateCompleted is null
	
	select @WTDComplete = count(*)
	from   #activity (nolock)
	where  DateCompleted >= @WTDStartDate
	and    DateCompleted <= @WTDEndDate
	
	-- use dates for drilldowns, no need to recalc them
	select  @YTDOpen			as YTDOpen 
			,@YTDComplete		as YTDComplete
			,@YTDStartDate		as YTDStartDate 
			,@YTDEndDate		as YTDEndDate 
	
	        ,@MTDOpen			as MTDOpen 
			,@MTDComplete		as MTDComplete
			,@MTDStartDate		as MTDStartDate 
			,@MTDEndDate		as MTDEndDate 
	
	        ,@QTDOpen			as QTDOpen 
			,@QTDComplete		as QTDComplete
			,@QTDStartDate		as QTDStartDate 
			,@QTDEndDate		as QTDEndDate 

	        ,@WTDOpen			as WTDOpen 
			,@WTDComplete		as WTDComplete
			,@WTDStartDate		as WTDStartDate 
			,@WTDEndDate		as WTDEndDate 
	
	RETURN 1
GO
