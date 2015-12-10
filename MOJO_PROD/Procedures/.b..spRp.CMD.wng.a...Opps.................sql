USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptCMDowngradedOpps]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptCMDowngradedOpps]
	(
    @AsOfDate smalldatetime,
    @CompanyKey int,
    @ContactCompanyKey int, -- -1 All, 0> valid GL Company
	@CheckAmount int,
    @AmountPercChange int,
    @CheckProbability int,
    @ProbabilityPercChange int,
    @CheckEstCloseDate int,
    @EstCloseDateChange int
	)
AS
	
  /*
  || When     Who Rel       What
  || 06/15/09 GHL 10.5.0.0  Created for new 10.5 Downgraded Opportunities report
  ||                        In addition to params -- in temp tables
  ||                        Any Of Account Managers, Any of Stages
  || 06/17/09 GHL 10.5.0.0  The downgrade flags are ORs not ANDs
  || 06/26/09 GHL 10.5.0.0  (55988) Keep the whole history of an opportunity
  ||                        i.e. even if ONLY one history record has been downgraded
  ||                        , the whole history of the opportunity must be displayed  
  */
	
	SET NOCOUNT ON 
	
	-- assume: create table #account_manager (AccountManagerKey int null)
	-- assume: create table #stage (LeadStageKey int null)
	
	-- since the history date is a timestamp, take one more day
	declare @HistoryAsOfDate datetime
	
	select @HistoryAsOfDate = dateadd(day,1, @AsOfDate) 
	
	declare @AllAccountManagers int
	
	-- if no account managers in the temp table, that means take all
	if (select count(*) from #account_manager) = 0
		select @AllAccountManagers = 1
	else
		select @AllAccountManagers = 0
		
	create table #opps (
	    -- these are never nulls
        LeadStageHistoryKey int null
        ,LeadKey int null
        ,LeadStageKey int null
        ,HistoryDate smalldatetime null
	
	    -- these fields may be null
        ,Comment varchar(1000) null
        ,Probability int null
        ,SaleAmount money null
        ,EstCloseDate smalldatetime null 		
           
        -- these fields are needed for calculations   
        ,NextKey int null
        ,PreviousKey int null
        
        ,NextHistoryDate smalldatetime null
        ,DaysAtStage int null 
    
        ,PreviousSaleAmount money null
        ,AmountPercChange money null
		,AmountDowngraded int null
		
        ,PreviousProbability int null
        ,ProbabilityPercChange int null
		,ProbabilityDowngraded int null
		
        ,PreviousEstCloseDate smalldatetime null 		
        ,EstCloseDateChange int null
		,EstCloseDateDowngraded int null
		
		,Downgraded int null
		)
		
     --insert 

	if @AllAccountManagers = 1
	     insert #opps (LeadStageHistoryKey, LeadKey, LeadStageKey, HistoryDate
	                   ,Comment, Probability, SaleAmount, EstCloseDate)	 
		 select lsh.LeadStageHistoryKey, lsh.LeadKey, lsh.LeadStageKey, lsh.HistoryDate
	           ,lsh.Comment, isnull(lsh.Probability, 0), isnull(lsh.SaleAmount, 0), lsh.EstCloseDate
		 from   tLead l (nolock)
		     inner join tLeadStatus ls (nolock) on l.LeadStatusKey = ls.LeadStatusKey
		     inner join tLeadStageHistory lsh (nolock) on l.LeadKey = lsh.LeadKey
		 where  l.CompanyKey = @CompanyKey
		 and    lsh.HistoryDate <= @HistoryAsOfDate
		 and    (@ContactCompanyKey = -1 or l.ContactCompanyKey = @ContactCompanyKey)
		 and    ls.Active = 1
		 
	else
		 insert #opps (LeadStageHistoryKey, LeadKey, LeadStageKey, HistoryDate
	                   ,Comment, Probability, SaleAmount, EstCloseDate)	 
		 select lsh.LeadStageHistoryKey, lsh.LeadKey, lsh.LeadStageKey, lsh.HistoryDate
	           ,lsh.Comment, isnull(lsh.Probability, 0), isnull(lsh.SaleAmount, 0), lsh.EstCloseDate
		 from   tLead l (nolock)
		     inner join tLeadStatus ls (nolock) on l.LeadStatusKey = ls.LeadStatusKey
		     inner join tLeadStageHistory lsh (nolock) on l.LeadKey = lsh.LeadKey
		     inner join #account_manager am on l.AccountManagerKey = am.AccountManagerKey 
		 where  l.CompanyKey = @CompanyKey
		 and    lsh.HistoryDate <= @HistoryAsOfDate
		 and    (@ContactCompanyKey = -1 or l.ContactCompanyKey = @ContactCompanyKey)
         and    ls.Active = 1
		 	     

	-- need to find previous and next keys for calculations
	update #opps
	set    PreviousKey = isnull((
	    select max(b.LeadStageHistoryKey)
	    from   #opps b
	    where  #opps.LeadKey = b.LeadKey
        and    #opps.LeadStageHistoryKey > b.LeadStageHistoryKey	    
		),0)
	
	update #opps
	set    NextKey = isnull((
	    select min(b.LeadStageHistoryKey)
	    from   #opps b
	    where  #opps.LeadKey = b.LeadKey
        and    #opps.LeadStageHistoryKey < b.LeadStageHistoryKey	    
		),0)
		 
	-- calculate the DaysAtStage	 
	Declare @DefaultNextDate smalldatetime 
	if @AsOfDate > GETDATE()
		select @DefaultNextDate = GETDATE()
	else
		select @DefaultNextDate = @AsOfDate
	
	update #opps
	set    #opps.NextHistoryDate = b.HistoryDate
	from   #opps, #opps b
	where  #opps.NextKey = b.LeadStageHistoryKey
	
	update #opps
	set    #opps.NextHistoryDate = @DefaultNextDate
	where  #opps.NextHistoryDate is null
	
	update #opps
	set    #opps.DaysAtStage = datediff(day, HistoryDate, NextHistoryDate)
	
	
	-- Get Previous values
	update #opps
	set    #opps.PreviousSaleAmount = b.SaleAmount
	      ,#opps.PreviousProbability = b.Probability
	      ,#opps.PreviousEstCloseDate = b.EstCloseDate
	from   #opps, #opps b
	where  #opps.PreviousKey = b.LeadStageHistoryKey
	
	/*
	Calculate the % Change in Sale Amount
	
	AmountChange = (SaleAmount - PreviousSaleAmount) / PreviousSaleAmount)
	if %, then muliply by 100
	
	ex: 20,000 to 25,000
	AmountChange = (25,000 - 20,000) / 20,000 = .25 = 25/100
	
	*/
	
	update #opps
	set    #opps.AmountPercChange = (
			((#opps.SaleAmount - #opps.PreviousSaleAmount) 
			/ #opps.PreviousSaleAmount) * 100
			)
	where  isnull(#opps.PreviousSaleAmount, 0) <> 0	
	
	/*
	Calculate the % Change in Probability
	
	ProbabilityChange = (Probability - PreviousProbability) / PreviousProbability)
	
	ex: 40 to 60
	AmountChange = (60 - 40) / 40 = 20 /40 = .5 * 100 = 50
	
	*/
		 
	update #opps
	set    #opps.ProbabilityPercChange = (
			((#opps.Probability - #opps.PreviousProbability) 
			/ #opps.PreviousProbability) * 100
			)
	where  isnull(#opps.PreviousProbability, 0) <> 0	
		 
	/*
	Calculate the diff of days bewteen previous est close date and new ext close dat
	*/
	
	update #opps
	set    #opps.EstCloseDateChange = datediff(day, PreviousEstCloseDate, EstCloseDate)
	
	
	update #opps
	set    AmountDowngraded = 0, ProbabilityDowngraded = 0, EstCloseDateDowngraded = 0
	
	-- check for downgrades in AmountPercChange
	if @CheckAmount = 1
	begin
		/*
		-- delete where null (we could not calculate) or >= 0 (no change or increase)
		delete #opps 
	    where isnull(AmountPercChange, 0) >= 0
	    
	    -- we are left we negative values (downgrades)
	    -- if ABS(@AmountPercChange) = 0 keep them all
	    
	    if ABS(@AmountPercChange) > 0
			delete #opps 
			where AmountPercChange * -1 > ABS(@AmountPercChange)	 
		*/
		
	    if ABS(@AmountPercChange) > 0
			update #opps
			set    AmountDowngraded = 1 
			where  AmountPercChange * -1 > ABS(@AmountPercChange)	 
        else
        	update #opps
			set    AmountDowngraded = 1 
			where  AmountPercChange < 0	 
        
	end
	
	-- check for downgrades in ProbabilityPercChange
	if @CheckProbability = 1
	begin
		/*
		-- delete where null (we could not calculate) or >= 0 (no change or increase)
		--delete #opps 
	    --where isnull(ProbabilityPercChange, 0) >= 0
	    
	    -- we are left we negative values (downgrades)
	    -- if ABS(@ProbabilityPercChange) = 0 keep them all
	    
	    if ABS(@ProbabilityPercChange) > 0
			delete #opps 
			where ProbabilityPercChange * -1 > ABS(@ProbabilityPercChange)	 
		*/
		if ABS(@ProbabilityPercChange) > 0
			update #opps
			set    ProbabilityDowngraded = 1  
			where  ProbabilityPercChange * -1 > ABS(@ProbabilityPercChange)	 
		else
			update #opps
			set    ProbabilityDowngraded = 1  
			where  ProbabilityPercChange < 0	 
		
	end
	
	-- check for slipping in forecasted date
	-- the logic is reversed here
	if @CheckEstCloseDate = 1
	begin
		/*
		-- delete where null (we could not calculate) or <= 0 (no change or decrease)
		delete #opps 
	    where isnull(EstCloseDateChange, 0) <= 0
	
		-- we are left we positive values (slipping or downgrades)
	    if ABS(@EstCloseDateChange) > 0
			delete #opps 
			where EstCloseDateChange > ABS(@EstCloseDateChange)	 
		*/
		
		if ABS(@EstCloseDateChange) > 0
			update #opps 
			set    EstCloseDateDowngraded = 1
			where  EstCloseDateChange > ABS(@EstCloseDateChange)	 
		else
			update #opps 
			set    EstCloseDateDowngraded = 1
			where  EstCloseDateChange > 0	 
		
	end
	
	-- delete where nothing has been downgraded
	if ((@CheckAmount + @CheckProbability + @CheckEstCloseDate) > 0) 
	begin
		update #opps
		set    Downgraded = isnull(AmountDowngraded, 0) 
				+ isnull(ProbabilityDowngraded, 0) + isnull(EstCloseDateDowngraded, 0)
				
		-- as per Kathryn Narayan, as soon as 1 in the history of the opportunity , display
		-- the whole history on the report, i.e. mark them all as Downgraded		
		update #opps
		set    #opps.Downgraded = 1
		where  exists (select 1 from #opps b where b.Downgraded > 0
		       and #opps.LeadKey = b.LeadKey)		
	
		delete #opps 
		where  Downgraded = 0
	end	 

	-- Now delete records
	if (select count(*) from #stage) > 0	 
		delete #opps where LeadStageKey not in (select LeadStageKey from #stage)
		 
	select c.CompanyName
	       ,l.Subject
	       ,ls.LeadStageName
	       ,ls.DisplayOrder
	       ,isnull(am.FirstName, '')+ ' '+isnull(am.LastName, '') as AccountManagerName 
	       ,#opps.* 
	from   #opps	
	inner join tLead l (nolock) on #opps.LeadKey = l.LeadKey     
	inner join tCompany c (nolock) on l.ContactCompanyKey = c.CompanyKey
	inner join tUser am (nolock) on l.AccountManagerKey = am.UserKey
	inner join tLeadStage ls (nolock) on #opps.LeadStageKey = ls.LeadStageKey    
	order by 
	
	   isnull(am.FirstName, '')+ ' '+isnull(am.LastName, '')
	   ,c.CompanyName
	   ,l.Subject
	   ,#opps.HistoryDate DESC
	   
	  	
	RETURN 1
GO
