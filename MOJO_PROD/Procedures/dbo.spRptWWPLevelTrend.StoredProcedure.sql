USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptWWPLevelTrend]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptWWPLevelTrend]
	(
	@AsOfMonday datetime, -- This should be a Monday 
	@CompanyKey int,
	@AccountManagerKey int, -- -1 All or > 0 valid user
	@NumWeeks int = 12
	)
AS
	SET NOCOUNT ON
	
  /*
  || When     Who Rel       What
  || 06/01/09 GHL 10.5.0.0  Creation for Blair's WWP Business Development Report
  || 06/03/09 GHL 10.5.0.0  Added @NumWeeks param for more flexibility
  || 08/11/09 GHL 10.5.0.7  (58984) Reviewed the way the level trend is calculated
  ||                        If there are level 3, 4 weeks ago and nothing has changed
  ||                        They should still be counted in this week's levels
  ||                        Previous design was simply calculating # of level changes for the week
  || 08/26/09 GWG 10.5.9.6  Fixed the total lead logic
  || 09/01/09 GHL 10.509    (61803) Querying now tLevelHistory in a loop
  || 10/01/09 GHL 10.5.1.1  (63702) Week dates should be from Sunday to Saturday
  ||                        Add column called Revenue Builder = total lvl 1-4, put between leads and lvl 1
  ||                        Remove pos / neg outcomes
  ||                        Add contacts to level 1
  || 10/15/09 GWG 10.5.1.2  Made minor changes to the calculations for adding in contacts for lvl1
  || 10/15/13 GWG 10.5.7.3  Fixed the join to users
  */


	
	create table #wksummary(
		WeekNo int null
		,StartDate datetime null
	    ,EndDate datetime null
	    
	    ,Level1 int null
	    ,Level2 int null
	    ,Level3 int null
	    ,Level4 int null
	    
	    ,Level1Contacts int null
	    ,RevenueBuilder int null
	    ,TotalLeads int null
	    )

	create table #wklevelentity(
		WeekNo int null
		,LevelNo int null
		,Entity varchar(50) null
		,EntityKey int null)

	create table #wkdetail(
	    Entity varchar(50) null
		,EntityKey int null
		,LevelNo int null
		,LevelDate datetime null
		,WeekNo int null
		
		,GPFlag int null
		)
	
	-- no nulls or zeroes
	select @AccountManagerKey = isnull(@AccountManagerKey, -1)
	if @AccountManagerKey = 0 select @AccountManagerKey = -1
	
	-- no division by zero    
	if @NumWeeks <= 0 select @NumWeeks = 12
	    
	declare @WeekNo int -- will go from 1 to NumWeeks
	declare @StartDate datetime
	declare @EndDate datetime
	
	-- Adjust back to the beginning of the week (Sunday)
	select @AsOfMonday = DATEADD(d, -1 * (DATEPART(Weekday, @AsOfMonday) -1), @AsOfMonday)  
	
	select @WeekNo = @NumWeeks
	select @StartDate = @AsOfMonday
	select @EndDate = dateadd(d,6,@StartDate)
    
	insert #wksummary (WeekNo, StartDate, EndDate)
	select @WeekNo, @StartDate, @EndDate
	
	while (@WeekNo > 1)
	begin
		select @WeekNo = @WeekNo - 1
		
		select @StartDate = dateadd(d,-7,@StartDate)
    	select @EndDate = dateadd(d,-7,@EndDate)
    	
		insert #wksummary (WeekNo, StartDate, EndDate)
		select @WeekNo, @StartDate, @EndDate
	end	
	
	--update #wksummary set StartDate = '01/01/1900' where WeekNo = 1
	
	select @EndDate = EndDate from #wksummary where WeekNo = @NumWeeks
	
	
	--select * from #wksummary order by WeekNo	
	
	select @WeekNo = @NumWeeks
	while (@WeekNo >= 1)
	begin
		select @StartDate = StartDate, @EndDate = EndDate from #wksummary where WeekNo = @WeekNo

		truncate table #wkdetail
			
		-- With Max(lh.LevelDate) we should have only record per Entity, EntityKey 	
		insert #wkdetail(Entity,EntityKey,LevelNo,LevelDate,GPFlag)
		select lh.Entity,lh.EntityKey,1,Max(lh.LevelDate), 0     
		from tLevelHistory lh (nolock)
		inner join tLead l (nolock) on lh.EntityKey = l.LeadKey 
		where l.CompanyKey = @CompanyKey
		and   (@AccountManagerKey = -1 Or l.AccountManagerKey = @AccountManagerKey) 
		and   lh.Entity = 'tLead'
		and   lh.LevelDate <= @EndDate
		and    (l.ActualCloseDate is null or l.ActualCloseDate > @EndDate )
		group by lh.Entity,lh.EntityKey 
		
		-- now get the correct level i.e. last one		
		update #wkdetail
		set #wkdetail.LevelNo = lh.Level
		from tLevelHistory lh (nolock)
		where #wkdetail.Entity = 'tLead'
		and lh.Entity = 'tLead'
		and #wkdetail.EntityKey = lh.EntityKey
		and #wkdetail.LevelDate = lh.LevelDate

		-- now add contacts
		-- where tUser.DateConverted < StartDate of the week
		-- and associated tLead (opportunity) thru tLeadUser has tLead.ActualCloseDate null or greater than EndDate  
		insert #wkdetail(Entity,EntityKey,LevelNo, GPFlag)
		select DISTINCT 'tUser', u.UserKey, 1, 0 
		from   tUser u (nolock)
			inner join tLeadUser lu (nolock) on u.UserKey = lu.UserKey
			inner join tLead l (nolock) on lu.LeadKey = l.LeadKey
		where  u.OwnerCompanyKey = @CompanyKey
		and    u.DateConverted < @EndDate
        and    (l.ActualCloseDate is null or l.ActualCloseDate > @StartDate )
		
		insert #wklevelentity(WeekNo, LevelNo, Entity, EntityKey)
		select @WeekNo, LevelNo, Entity, EntityKey
		from #wkdetail
		
		select @WeekNo = @WeekNo -1

--select @WeekNo
	end
	

	
	update #wksummary
	set    #wksummary.Level1 = ISNULL((
		select count(*) from #wklevelentity d (nolock)
		where d.WeekNo = #wksummary.WeekNo 
		and   d.Entity in ( 'tLead', 'tUser') -- we take opportunities and contacts
		and   d.LevelNo = 1 
		),0)
		
	update #wksummary
	set    #wksummary.Level2 = ISNULL((
		select count(*) from #wklevelentity d (nolock)
		where d.WeekNo = #wksummary.WeekNo
		and   d.Entity = 'tLead' -- we only take opportunities 
		and   d.LevelNo = 2 
		),0)
				
	update #wksummary
	set    #wksummary.Level3 = ISNULL((
		select count(*) from #wklevelentity d (nolock)
		where d.WeekNo = #wksummary.WeekNo
		and   d.Entity = 'tLead' -- we only take opportunities 
		and   d.LevelNo = 3 
		),0)

	update #wksummary
	set    #wksummary.Level4 = ISNULL((
		select count(*) from #wklevelentity d (nolock)
		where d.WeekNo = #wksummary.WeekNo
		and   d.Entity = 'tLead' -- we only take opportunities 
		and   d.LevelNo = 4 
		),0)

	-- Revenue Builder is just the sum of all levels
	update #wksummary
	set    #wksummary.RevenueBuilder =  #wksummary.Level1 + 
										#wksummary.Level2 +
										#wksummary.Level3 +
										#wksummary.Level4
	
	
	-- total number of "Active" Leads from tUserLead (date created before end of period)
	update #wksummary
	set    #wksummary.TotalLeads = ISNULL((
		select count(*) from tUserLead ul (nolock)
		where ul.CompanyKey = @CompanyKey
		and   (@AccountManagerKey = -1 Or ul.OwnerKey = @AccountManagerKey) 
		and   ul.DateAdded <= #wksummary.EndDate
		and   (ul.InactiveDate is null or  ul.InactiveDate> #wksummary.EndDate)
		),0)
	
	-- add all users with a lead created date before end of period 
	-- but date converted blank or after the period end date
	update #wksummary
	set    #wksummary.TotalLeads = #wksummary.TotalLeads + ISNULL((
		select count(*) from tUser u (nolock)
		where u.OwnerCompanyKey = @CompanyKey
		and   (@AccountManagerKey = -1 Or u.OwnerKey = @AccountManagerKey) 
		and   u.DateLeadCreated <= #wksummary.EndDate
		and   u.DateConverted > #wksummary.EndDate
		),0)
	
	-- insert AVG line as WeekNo = 1000
	insert #wksummary (WeekNo, Level1, Level2, Level3, Level4, RevenueBuilder, TotalLeads)
	select 1000, sum(Level1)/@NumWeeks,  sum(Level2)/@NumWeeks, sum(Level3)/@NumWeeks, sum(Level4)/@NumWeeks
	       , sum(RevenueBuilder)/@NumWeeks, sum(TotalLeads)/@NumWeeks
	from #wksummary
	
	select * from #wksummary
	order by WeekNo desc
	
	--select * from #wklevelentity
	--select * from #wkdetail Where EntityKey = 9571
		
	RETURN 1
GO
