USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptWWPActivities]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptWWPActivities]
	(
	@AsOfDate smalldatetime,
	@CompanyKey int,
	@AccountManagerKey int -- -1 All or > 0 valid user
	)
AS
	SET NOCOUNT ON
	
  /*
  || When     Who Rel       What
  || 06/01/09 GHL 10.5.0.0  Creation for Blair's WWP Business Development Report
  || 08/28/09 RLB 10.5.0.8  Commented out parts of the where clause that was not needed
  || 09/02/09 GWG 10.5.0.9  Added logic to find the start of the week
  || 10/01/09 GHL 10.5.1.1  Week dates should be from Sunday to Saturday
  */

	-- Assume done in vb
	-- create table #activity_type (ActivityTypeKey int null)
	
	declare @AllActivities int
	declare @LastWeekStartDate datetime
	declare @LastWeekEndDate datetime
	declare @ThisWeekStartDate datetime
	declare @ThisWeekEndDate datetime
	
	select @AsOfDate = DATEADD(d, -1 * (DATEPART(Weekday, @AsOfDate) -1), @AsOfDate)  -- Adjust back to the beginning of the week
	select @LastWeekStartDate = dateadd(d, -7, @AsOfDate)
	select @LastWeekEndDate = dateadd(d, -1, @AsOfDate)
	select @ThisWeekStartDate = @AsOfDate
	select @ThisWeekEndDate = dateadd(d, 6, @AsOfDate)

	
	if (select count(*) from #activity_type) = 0
		select @AllActivities = 1
	else
		select @AllActivities = 0
	
	
	-- no nulls or zeroes
	select @AccountManagerKey = isnull(@AccountManagerKey, -1)
	if @AccountManagerKey = 0 select @AccountManagerKey = -1


	if @AllActivities = 1
	begin
		select a.Subject
		       ,'Last Week' as WeekType
		from   tActivity a (nolock)
		where  a.CompanyKey = @CompanyKey
		and    (
				(@AccountManagerKey = -1 or a.AssignedUserKey = @AccountManagerKey)
				or
				(@AccountManagerKey = -1 or a.OriginatorUserKey = @AccountManagerKey)
				)
	    and    a.ActivityDate >= @LastWeekStartDate
	    and    a.ActivityDate <= @LastWeekEndDate
	    and    a.Private = 0
--	    and    isnull(a.ContactCompanyKey, 0) = 0
--		and    isnull(a.ContactKey, 0) = 0  -- are these ANDs?
--		and    isnull(a.UserLeadKey, 0) = 0
	    
		union all
		
		select a.Subject
		       ,'This Week' as WeekType
		from   tActivity a (nolock)
		where  a.CompanyKey = @CompanyKey
		and    (
				(@AccountManagerKey = -1 or a.AssignedUserKey = @AccountManagerKey)
				or
				(@AccountManagerKey = -1 or a.OriginatorUserKey = @AccountManagerKey)
				)
	    and    a.ActivityDate >= @ThisWeekStartDate
	    and    a.ActivityDate <= @ThisWeekEndDate
	    and    a.Private = 0
--	    and    isnull(a.ContactCompanyKey, 0) = 0
--		and    isnull(a.ContactKey, 0) = 0  -- are these ANDs?
--		and    isnull(a.UserLeadKey, 0) = 0
	    
	end
	
	else
	
	begin
		select a.Subject
		       ,'Last Week' as WeekType
		from   tActivity a (nolock)
			inner join #activity_type a_t on a.ActivityTypeKey = a_t.ActivityTypeKey
		where  a.CompanyKey = @CompanyKey
		and    (
				(@AccountManagerKey = -1 or a.AssignedUserKey = @AccountManagerKey)
				or
				(@AccountManagerKey = -1 or a.OriginatorUserKey = @AccountManagerKey)
				)
	    and    a.ActivityDate >= @LastWeekStartDate
	    and    a.ActivityDate <= @LastWeekEndDate
	    and    a.Private = 0
--	    and    isnull(a.ContactCompanyKey, 0) = 0
--		and    isnull(a.ContactKey, 0) = 0  -- are these ANDs?
--		and    isnull(a.UserLeadKey, 0) = 0
	    
		union all
		
		select a.Subject
		       ,'This Week' as WeekType
		from   tActivity a (nolock)
			inner join #activity_type a_t on a.ActivityTypeKey = a_t.ActivityTypeKey
		where  a.CompanyKey = @CompanyKey
		and    (
				(@AccountManagerKey = -1 or a.AssignedUserKey = @AccountManagerKey)
				or
				(@AccountManagerKey = -1 or a.OriginatorUserKey = @AccountManagerKey)
				)
	    and    a.ActivityDate >= @ThisWeekStartDate
	    and    a.ActivityDate <= @ThisWeekEndDate
	    and    a.Private = 0
--	    and    isnull(a.ContactCompanyKey, 0) = 0
--		and    isnull(a.ContactKey, 0) = 0  -- are these ANDs?
--		and    isnull(a.UserLeadKey, 0) = 0
	    
	end
	
	RETURN 1
GO
