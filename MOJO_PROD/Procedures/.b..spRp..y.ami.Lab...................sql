USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptPyramidLabor]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[spRptPyramidLabor]
	(
	@CompanyKey int 
	,@StartDate smalldatetime
	,@EndDate smalldatetime
	,@UserKey int = null
	,@ProjectTypeKey int = null
	,@ClientKey int = null
	,@CampaignKey int = null
	,@ProjectKey int = null 
	,@AccountManager int = null
	)
AS --Encrypt

/*
|| When     Who Rel    What
|| 09/21/11 GHL 10.548 (109668) Customization for Pyramid
|| 10/31/11 GHL 10.549 (125131) See request below
|| 11/15/11 GHL 10.550 (125078, 123484) See request below
|| 11/18/11 GHL 10.550 (125078 #2) Corrected Col T and U
||                     as Total Hours Worked = Billable Hours + Non Billable + Probono Hours           
|| 12/14/11 GHL 10.550  (123484) removed written off as WriteOffReasonKey <> ProbonWOKey
||                     because they made the probono reason inactive
|| 01/03/12 GHL 10.551 (130320) put back written off as WriteOffReasonKey <> ProbonWOKey
||                     because we are double dipping with Probono Hours
||                     the probono reason is 503 captured now because I removed the check on Active = 1
|| 01/20/12 GHL 10.552 (132036) (130866) New requests from Pyramid
|| 02/14/12 GHL 10.552 (132036) Adjustments should be where ServiceKey = BilledService (no change of service) 
||                      All other changes except D fone
|| 03/22/12 GHL 10.554 Must display budget data even if no hours worked or billed                    
|| 05/01/12 GHL 10.555 (142018) In #budget take HourlyRate from project first, contradicts prior request: see (132036) (130866)
||						Column Q is also not calculating the correct total. It should be the
||						billable rate of the person multiplied by the remaining hours in the budget.
|| 05/22/12 GHL 10.556  (143556) After talk to them during the conference and by phone (GG)
||                      So, lets change it so hourly rate is what is on the time sheet, not the assignment.
||                      then for the displayed hourly rate, it should be the average hourly rate 
||                      for that project, person and task.
||                      ****But for Probono Amt, take HourlyRate when ActualRate = 0
|| 06/05/12 GHL 10.556  Corrected HourlyRate calculation + Remaining $$ Amount
|| 06/11/12 GHL 10.556  Calculating now ActualBillableAmtOnTime based on BilledRate or ActualRate
|| 06/14/12 GHL 10.557  Changed logic for ActualBillableAmtOnTime
*/

/* 
(142018)

Hi Greg,
Just wanted to let you know that Mae and I took a cursory look at the
report before she left for the conference and it looks like the filters and
date range field are all working correctly. We haven't completed our
regular testing process to make sure that the other fields are still
working correctly but we will complete that when Mae returns from the
conference.
There is one new thing that we noticed that I'm hoping you and Mae could
find a moment to talk about at the conference. We recently changed the
rates of many of our employees and noticed that the report changes all the
historical data to use the new rate -- instead of using the rate at the
time that the work was done. This will obviously affect all of the
financial data in the reports. Is there a way to have the report respect
what the billing rate was at the time the work was executed?
Many thanks,
Rosalie

(132036)

Hi Greg,
Mae and I had a chance to test the corrected version of the report and
things are looking good for the most part. There are still a few issues
that may be easier to talk through over the phone and it probably is a good
idea since we are so very close, but I'll try to also explain them over
email. Would you have any time Wednesday or Thursday next week?

A) The Accounting Adjustments columns: *These are the only columns* *not
currently working correctly.
In the billing worksheet:
When we move time from the Billable service code to the Non Billable
service code, the dollar amount is shown in the "Acctg Adjustments - $$"
column. It shouldn't.
When we move time from the Probono service code to the Billable service
code, the dollar amount is shown in the "Acctg Adjustments - $$" column. It
shouldn't.
When we move time from the Billable service code to the Probono service
code, the dollar amount is shown in the "Acctg Adjustments - $$" column. It
shouldn't.
When we move time from the Billable service code to the NonBillable service
code, the dollar amount is shown in the "Acctg Adjustments - $$" column. It
shouldn't.
The only adjustments that should show up in these columns are when someone
manually changes the Dollars and Hours fields in the Billing Worksheet --
not when time is moved from one service code to another.
If someone changes the number of hours, the equivalent dollar amount should
show up in the "Acctg Adjustments - $$" column. For example, if someone has
a billing rate of $100 and one hour is added in the Billing Worksheet
"Hours" field, one hour should show up in the "Acctg Adjustments - Hrs."
column and $100 should show up in the "Acctg Adjustments - $$" column.

B)Report Name: *
Is there a way to - move the report? Rename the report? Or make the name of
the report in all caps? Something to make it stand out? I think we've
already asked you this -- I acknowledge that - we're grasping at straws
with the all caps part.

C)Dropdown menus: *
Can the drop down menus for Projects and Campaigns only show the Projects
and Campaigns for the Client - if one is selected?

D)Staff with hours assigned regardless of whether they have entered time or
not: *
Did you have a chance to check on whether people who have not entered time
can be shown on the report with zero totals so that it doesn't affect the
budget number totals?  When the 3 of us had the last call you said you
thought it was possible.

E)Can we change the headings of columns: R&S: *
R should be labeled: Total NB, PB & WO - Hrs.
S should be labeled: Total NB, PB & WO - $$
Many thanks,
Rosalie


(132036) (130866)

In the billing worksheet we did a partial write off of ..25 billable hours
(equal to $25 due to the rate of the individual).
We moved .5 hours from a Non Billable service code to a Billable service
code.
We moved .25 hours from a ProBono service code to a Billable service code.
We moved .75 hours from a Billable service code to a Probono service code.
We moved 1 hour from a Billable service code to a Non Billable service code.
We made the following accounting adjustments:
We added 1 hour (equal to $100)
We added $33 dollars
We deducted .33 dollars
We deducted .18 hours (equal to $8)
On the report, the following columns are calculating incorrectly (see
attached report)
Column H after the transactions we ran should equal 1.25 and it shows 1.5
instead. I think this is because write offs are not being subtracted from
this column.
Column I still isn't calculating correctly. It should be the rate of the
person multiplied by the number of billable hours.
Column Q is also not calculating the correct total. It should be the
billable rate of the person multiplied by the remaining hours in the
budget.
Column U is not calculating correctly. It should be the billable rate of
the person multiplied by the total number of hours worked.
Accounting adjustment Hours (column W) is not calculating correctly. It
should have the total of $32.67. I can't tell what transactions are also
being included, but I assume it is from moving time from service codes. The
only things that we want to show up in the Accounting Adjustments columns
(V & W) are when the Accounting department overwrites dollars or hours
manually in the billing worksheet.
Let me know when you think you might have some time to take a look at this.
I know Mae is in the midst of year end close and was hoping to be able to
release this report before the end of the year. If it is easier to talk
through any of these items - please just let me know and we can schedule a
call.
Many thanks,
Rosalie

(130320)

Hi Greg,
I'm just taking a preliminary look at the report before Mae and I get
together for final testing next week. There are still some issues that I
can see:
   - Project: 11-807-021 - ESA - Workamajig Example: Website - Content -
   This project has 5 written off hours but it isn't calculating the written
   off dollar amount. It should say $500 but it says 0.
   - Same project. There are 13 hours budgeted. 4 Billable hours were
   worked. It shows that there are 14 hours remaining in the budget when it
   should show 9.
   - These are the most obvious ones. I can dig deeper when Mae and I get
   together to run actual transactions but it would be great if these couple
   of issues could be resolved before we meet on Tuesday.
Many thanks,
Rosalie

(123484)

Hi Greg,
Mae and I haven't gotten together to do our final testing but we did notice
that now the Write Off columns no longer seem to be working. Can you take a
look at those columns first? Then we'll do the final testing.
You can use this project as a test: Project 11-1076-049 should have
4,487.50 in WRITTEN OFF
Many thanks,
Rosalie

(125078 #2)

Hi Greg,
Mae and I were able to get together today to test the report. There is one
new issue -- Now columns T and U are no longer calculating correctly. You
can look at project 11-807-021 as an example. The hours should be the total
of all Billable, Nonbillable, and Probono hours. The total should be 15 for
that project - but it is only showing 10.
We also ran into an issue while testing on project 11-807-023:
We had 5 hours of Billable time, 5 b hours of Non Billable time and 5 Hours
of ProBono time to start. We changed the service code for 1 of the Billable
hours to a ProBono service. We ran the report again. Now we had 4 hours of
Billable and 6 Hours of Probono. This was correct. Then, when Mae wrote off
the 6 hours of ProBono time using the ProBono write off reason and we ran
the report again -- now we had 5 hours of Billable and 5 Hours of ProBono
again. I'm not sure what could be causing that issue but we would love to
have it resolved before we introduce it to the project managers.
We also would like to get your thoughts on the way we are dealing with Pro
Bono time and see if perhaps there is an easier way than what Sheila and
Mike recommended. I understand that this may be outside of the scope of
this project - just let us know.
Here's a little history:
We used to set up Probono service codes in our system as Non Billable.
Then, after meeting with Sheila and eventually Mike to determine whether
there was a way to determine the value of those hours -- they recommended
that we change all the ProBono service codes to Billable services and write
off any time to them to a special write off code. It seems to me (and it
may be more complicated than this... ) that if you can determine the value
of the Non Billable time on this report (by calculating the number of non
billable hours and multiplying that by the person's rate) - that the same
thing could be done for Pro Bono time -- and there is no need to have it be
a billable service and go through the process of writing everything off
each month.
I'm asking because the report we've had you construct has issues with the
Probono time depending on how it is calculated.
For example, if the ProBono time is calculated by adding up all the hours
that were written off to the ProBono write off reason -- then  ProBono only
shows up on the report AFTER the write offs have happened. This normally
happens once per month so the report would only be accurate for Project
managers once a month. Not ideal.
Now, we thought that by calculating the ProBono time by adding up all the
hours that were entered to service codes starting with "PB" we would fix
that problem. It did - but it caused a different problem. Now, if we want
to make a time entry that was originally a billable service a probono
service instead - Mae has to change the service code - and then write off
the time using the probono write off reason. This adds an additional step
to the process (and doesn't seem to work correctly - see my issue #2 above).
How hard would it be to calculate the value of the ProBono time by
multiplying the number of hours (those entered on timesheets and those
changed to that service code later) by the rate of the person doing the
work?


(125078)

Mae and I had a chance to go over the revised report. See my notes below:
Columns J & K: Previously Probono was showing up in the columns H & I. Now
it is showing up in columns J & K. We do not want Probono to show up in any
column except the Probono Columns: L & M. Can you remove it from the
Columns: J&K?

We are also wondering how you are pulling the Probono information for
columns L & M. It currently doesn't show up until we write off the time to
the Probono write off code. Is it possible to have it show time that is
entered to the Probono services instead? They all begin with 'PB'. We had
asked about this before but I'm not sure if this is an out of scope item --
or one that just hadn't been addressed yet.

Columns F&G: The budgeted hours aren't showing up in these columns although
they seemed to have been working before. You can look at two projects as
examples: 11.1342.007 shows budgeted hours - but not the same number as in
the actual budget of the project. And project 11.807.021 has 13 hours
budgeted that don't show up in the report at all.
There are other columns - like the Remaining budgeted hours/amounts that we
can't test until the correct data is being fed into columns F&G.
Let me know if you would like to go over any of this on the phone -
sometimes that's easier to make sure we are on the same page.

NOTE: 11.1342.07 had missing actuals and 11.807.021 had estimate by task/service

(123484)
Take probono out of billable and non billable.
Budgeted hours are not showing up at all.
probono only on starting w PB

(125131)

- Columns H and I. I made a mistake when I sent over the formulas and we
   just noticed it in our testing. Previously, Sheila had us move our probono
   time to a billable service code so that we would be able to track the
   dollar amount of probono time. I didn't take that into account when I
   created the formula. We would like that column to show all time that is
   entered to a billable service code (minus any that was moved from billable
   to non-billable service codes) - UNLESS that service code is a ProBono
   service code. They all start with "PB" if that is something you can use to
   exclude data from those two columns. If not, let's talk about what our
   other options might be.

H= Actual Billable Hours from Timesheets
I= Actual Billable DOLLAR Amounts from Timesheets

   - Columns P and Q: Could you adjust the formula to disregard the Probono
   time (see item above -- probono should be removed from the total column so
   we don't need to remove it here again). Formula should be "Actual Billable
   minus Written off Non Probono"

P=Remaining Hours on budget
Q=Remaining Dollar Amt on budget
*/

	SET NOCOUNT ON 

	declare @ProBonoWOKey int

	select @ProBonoWOKey = WriteOffReasonKey -- should be 503, could have been hardcoded
	from   tWriteOffReason (nolock)
	where  CompanyKey = @CompanyKey
	--and    Active = 1 -- They made it inactive on 12/14/2011
	and    ReasonName like '%Pro Bono%'

	-- A service is considered NON Billable if the Service Code contains NONBILL Or HourlyRate1 = 0 
	create table #service (ServiceKey int null, IsBillable int null, IsProBono int null)

	insert #service (ServiceKey, IsBillable, IsProBono)
	select  ServiceKey
	        ,case when HourlyRate1 = 0 then 0
			      else
				     case when ServiceCode like '%NONBILL%' then 0
					 else 1
				  end
			 end
			 -- added for 125078 and 123484
			 ,case when UPPER(ServiceCode) like 'PB%' then 1 else 0 end
	from    tService (nolock)
	where   CompanyKey = @CompanyKey

	-- for 125131
	-- removed for 125078 and 123484
	/*
	update #service 
	set    #service.IsBillable = 0  
	from   tService s (nolock)
	where  #service.ServiceKey = s.ServiceKey
	and    #service.IsBillable = 1
	and    UPPER(s.ServiceCode) like 'PB%' -- If probono service code, it is not billable 
	*/

	create table #time (
		Type varchar(20) null -- actual, billed, invoiced, budgeted
		,TimeKey uniqueidentifier null

		-- for initial queries
        ,CampaignKey int null
		,AccountManager int null
		,ProjectTypeKey int null
		,ClientKey int null

		,ProjectKey int null		-- Part of the composite key for this report
		,TaskKey int null			-- Part of the composite key for this report
		,UserKey int null			-- Part of the composite key for this report

		,ServiceKey int null
		,ActualHours  decimal(24,4) null
		,ActualRate money null
		,BilledService int null
		,BilledHours  decimal(24,4) null
		,BilledRate money null
		,WriteOff tinyint null
		,WriteOffReasonKey int null
		,InvoiceLineKey int null

		,IsBillable int null
		,IsProBono int null

		-- the hourly rate of the staff member for that project
		,HourlyRate money null  -- hourly rates from tAssignment, all projects use method Project/User for get rate from

		-- COLUMN H
		-- Hours entered on timesheets as billable
		-- if hours are changed from non billable to billable by Accounting, they should appear here
		,ActualBillableHoursOnTime decimal(24,4) null
		
		-- COLUMN I
		-- The dollar value entered on timesheets to billable services
		-- if hours are changed from non billable to billable by Accounting their value should appear here
		,ActualBillableAmtOnTime money null
		
		-- COLUMN J
		-- Number of hours entered on timesheets to non billable services
		-- if hours are moved from non billable to billable by Accounting, they should NOT appear here
		,ActualNonBillableHoursOnTime decimal(24,4) null
		
		-- COLUMN K
		-- The calculation of the dollar value of the non billable hours
	    -- = Number of hours non billable * person's rate
		-- if hours are changed from non billable to billable by Accounting their value should NOT appear here
		,ActualNonBillableAmtOnTime money null
		
		-- COLUMN L
		-- Hours calculated from the ProBono write off reason
		-- These should not be included in the WriteOff Hours column
		,ProBonoHours decimal(24, 4) null

		-- COLUMN M
		-- Dollar amount calculated from the ProBono write off reason
		-- These should not be included in the WriteOff Amt column
		,ProBonoAmt money null

		-- COLUMN N
		-- Number hours written off by task and person, not including ProBono hours 
		,WriteOffHours decimal(24, 4) null

		-- COLUMN O
		-- Dollar amount written off by task and person, not including ProBono amount 
		,WriteOffAmt decimal(24, 4) null

		-- COLUMN R
		-- Calculated by adding columns:
		-- Actual non billable hours on timesheets + ProBono hours + written off hours
		-- WILL BE CALCULATED AT THE END. Note: I know for a fact that we will double dip
		-- because some non billable hours have been written off but GG says it is OK
		,TotalNonBillableHours decimal(24,4) null

		-- COLUMN S
		-- Calculated by adding columns:
		-- Actual non billable value on timesheets + ProBono amt + written off amt
		-- WILL BE CALCULATED AT THE END. Note: I know for a fact that we will double dip
		-- because some non billable hours have been written off but GG says it is OK
		-- issue 125131 from Pyramid attempts to fix that?
		,TotalNonBillableAmt money null

		-- COLUMN T
		-- This column should include all hours worked billable + non billable--all of them
		-- I see it as ActualBillableHoursOnTime + ActualNonBillableHoursOnTime
		,TotalHoursWorked decimal(24,4) null

		-- This column should include the dollar value of all work done
		-- this should include the number of non billable work by multiplying 
		-- the number of hours worked by the billable rate of the person doing the work
		
		-- COLUMN U
		-- I see it as ActualBillableAmtOnTime + ActualNonBillableAmtOnTime
		,TotalAmtWorked money null

		-- COLUMN V
		-- Accounting adjustments in the transactions and billing worksheet screens
		-- Billed Hours - Actual Hours
		,AccountingAdjustedHours decimal(24, 4) null

		-- Accounting adjustments in the transactions and billing worksheet screens. For example:
		-- 1) Adding hours to an individual
		-- 2) Changing hours from billable service to non billable service
		-- 3) Entering a credit memo

		-- COLUMN W
		-- In the brain: Billed - Actual = ROUND( BilledHours * BilledRate - ActualHours * ActualRate, 2) 
		,AccountingAdjustedAmt money null

		-- COLUMN X
		-- invoiced hours
		,InvoicedHours decimal(24, 4) null

		-- COLUMN Y
		-- invoiced dollar amount
		,InvoicedAmt money null

		)

	-- This is not time sensitive
	-- so we have to recalc the actuals
	create table #budget(
		CampaignKey int null
		,AccountManager int null
		,ProjectTypeKey int null
		,ClientKey int null
		
		,ProjectKey int null
		,TaskKey int null
		,UserKey int null
		,HourlyRate money null

		-- number of hours allocated to a person in the project budget
		,BudgetHours decimal(24, 4) null

		-- dollar amount allocated to a person in the project budget
		,BudgetAmt money null

		-- Dollar amount left in the budget
		-- Calculated: Budget Amount - (
		-- Actual billable dollar amount - written off amount (probono + non probono) ) -- discard probono for 125131
		,RemainingHours decimal(24, 4) null -- COLUMN P :not in original excel spreadsheet, but I will calculate it
		,RemainingAmt money null			-- COLUMN Q
		
		-- we will have to recalc actuals without time restrictions
		,ActualAmt money null
		,ActualHours decimal(24, 4) null 
 
		,UpdateFlag int null
		)

	-- 1) CAPTURE ACTUALS BASED ON WORKDATE

	-- every time entry has a user belonging to Pyramid
	-- every time entry has a project 

	-- take them all, including the transfers, the reversals should make the numbers right
	insert #time (Type,TimeKey,CampaignKey, AccountManager, ClientKey,  ProjectTypeKey, ProjectKey, TaskKey, UserKey)
	select 'actual', t.TimeKey, p.CampaignKey, p.AccountManager, p.ClientKey, p.ProjectTypeKey, t.ProjectKey, t.TaskKey, t.UserKey
	from   tTime t (nolock)
	inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
	where p.CompanyKey = @CompanyKey
	and   (@StartDate is null or @StartDate <= t.WorkDate) 
	and   (@EndDate is null or t.WorkDate <= @EndDate)
	and   (@UserKey is null or t.UserKey = @UserKey)
	and   (@ClientKey is null or p.ClientKey = @ClientKey)
	and   (@ProjectTypeKey is null or p.ProjectTypeKey = @ProjectTypeKey)
	and   (@ProjectKey is null or t.ProjectKey = @ProjectKey)
	and   (@AccountManager is null or p.AccountManager = @AccountManager)
	and   (@CampaignKey is null or p.CampaignKey = @CampaignKey)
   
   -- no TaskKey because not in index
   insert #time (Type,TimeKey, CampaignKey, AccountManager, ClientKey, ProjectTypeKey, ProjectKey, UserKey)
	select 'billed', t.TimeKey, p.CampaignKey, p.AccountManager, p.ClientKey, p.ProjectTypeKey, t.ProjectKey, t.UserKey
	from   tTime t  (nolock)
	inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
	where p.CompanyKey = @CompanyKey
	and   (@StartDate is null or @StartDate <= t.DateBilled) 
	and   (@EndDate is null or t.DateBilled <= @EndDate)
	and   (@UserKey is null or t.UserKey = @UserKey) 
	and   (@ClientKey is null or p.ClientKey = @ClientKey)
	and   (@ProjectTypeKey is null or p.ProjectTypeKey = @ProjectTypeKey)
	and   (@ProjectKey is null or t.ProjectKey = @ProjectKey)
	and   (@AccountManager is null or p.AccountManager = @AccountManager)
	and   (@CampaignKey is null or p.CampaignKey = @CampaignKey)
	and   t.TimeKey not in (select TimeKey from #time)			-- prevent duplicates

	/*
	3 possible cases:

                       StartDate                             EndDate

     WorkDate                          DateBilled
	                             WorkDate and DateBilled
								        WorkDate                             DateBilled

	*/

	update #time 
	set #time.TaskKey = t.TaskKey 
	from tTime t (nolock) where #time.TimeKey = t.TimeKey
	and #time.Type= 'billed'  
	
	 
	 update #time
	set    #time.ActualRate = t.ActualRate
	      ,#time.ActualHours = t.ActualHours
		  ,#time.ServiceKey = t.ServiceKey
		  
	      ,#time.BilledRate = t.BilledRate
		  ,#time.BilledHours = t.BilledHours
		  ,#time.BilledService = t.BilledService
		  
		  ,#time.WriteOff = t.WriteOff
		  ,#time.WriteOffReasonKey = t.WriteOffReasonKey
		  ,#time.InvoiceLineKey = t.InvoiceLineKey

	from   tTime t (nolock)
	where  #time.TimeKey = t.TimeKey 

	/* I will recalculate below
	update #time
	set    #time.HourlyRate = a.HourlyRate
	from   tAssignment a (nolock)
	where  #time.UserKey = a.UserKey 
	and    #time.ProjectKey = a.ProjectKey

	-- found out that a lot of HourlyRate are null
	-- so get it from tUser
	update #time
	set    #time.HourlyRate = u.HourlyRate
	from   tUser u (nolock)
	where  #time.UserKey = u.UserKey 
	and    #time.HourlyRate is null
	*/

	update #time
	set    #time.ActualRate = isnull(#time.ActualRate, 0)
		  ,#time.BilledRate = isnull(#time.BilledRate, 0)
		  ,#time.BilledHours = isnull(#time.BilledHours, 0)
		  ,#time.ActualHours = isnull(#time.ActualHours, 0)

	-- I assume that Accounting changes the service and the new service is BilledService
	-- so billable is set based on BilledService
	update #time
	set    #time.IsBillable = s.IsBillable
	      ,#time.IsProBono = s.IsProBono
	from   #service s
	where  isnull(#time.BilledService, #time.ServiceKey) = s.ServiceKey

	-- 6/11/2012 calculate the Actual Billable differently if billed or not
	update #time
	set    ActualBillableHoursOnTime = ActualHours 
	       --,ActualBillableAmtOnTime = ROUND(ActualHours * ActualRate, 2)
		   -- changed 1/22/12
		   --,ActualBillableAmtOnTime = ROUND(ActualHours * HourlyRate, 2)
		   -- and changed back 5/22/12 for 143556
		   ,ActualBillableAmtOnTime = ROUND(ActualHours * ActualRate, 2)
	where  IsBillable = 1
	and    IsProBono = 0
	and    WriteOff = 0
	--and    isnull(BilledService, 0) = 0 -- added 6/11/12
	and    (isnull(BilledService, 0) = 0 Or isnull(BilledService, 0) = isnull(ServiceKey, 0) ) -- 6/14/12

	-- added 6/11/2012
	update #time
	set    ActualBillableHoursOnTime = ActualHours 
	       ,ActualBillableAmtOnTime = ROUND(ActualHours * BilledRate, 2)
	where  IsBillable = 1
	and    IsProBono = 0
	and    WriteOff = 0
	--and    isnull(BilledService, 0) > 0 
	and   NOT (isnull(BilledService, 0) = 0 Or isnull(BilledService, 0) = isnull(ServiceKey, 0) ) -- 6/14/12


	-- Recalc hourly rate for 143556
   create table #hourlyrate (UserKey int null, ProjectKey int null, TaskKey int null
						    , HourlyRate money null, TotalHours decimal(24,4) null, TotalAmt money null, UpdateFlag int null)

   insert #hourlyrate (UserKey, ProjectKey, TaskKey, UpdateFlag)
   select distinct UserKey, ProjectKey, TaskKey, 0
   from   #time
	
	-- flag the records with actuals where ActualRate <> 0 (I can calculate an average) 
	update #hourlyrate
	set    #hourlyrate.UpdateFlag = 1
	from   #time
	where  #time.ProjectKey = #hourlyrate.ProjectKey
		and   #time.UserKey = #hourlyrate.UserKey
		and   #time.TaskKey = #hourlyrate.TaskKey
		and   #time.ActualRate <> 0


	update #hourlyrate
	set    #hourlyrate.TotalHours = (select sum(ActualHours) from #time 
		where #time.ProjectKey = #hourlyrate.ProjectKey
		and   #time.UserKey = #hourlyrate.UserKey
		and   #time.TaskKey = #hourlyrate.TaskKey
		and   #time.ActualRate <> 0 -- remove probono entries?? what about non billable ??
		)
    where #hourlyrate.UpdateFlag = 1

	update #hourlyrate
	set    #hourlyrate.TotalAmt = (select sum(ActualHours * ActualRate) from #time 
		where #time.ProjectKey = #hourlyrate.ProjectKey
		and   #time.UserKey = #hourlyrate.UserKey
		and   #time.TaskKey = #hourlyrate.TaskKey
		and   #time.ActualRate <> 0
		)
    where #hourlyrate.UpdateFlag = 1

	update #hourlyrate
	set    #hourlyrate.HourlyRate = TotalAmt / TotalHours
	where  #hourlyrate.TotalHours <> 0 
	and    #hourlyrate.UpdateFlag = 1

	-- where I could not find an actual with ActualRate <> 0, get it from tAssignment or tUser
	update #hourlyrate
	set    #hourlyrate.HourlyRate = a.HourlyRate
	from   tAssignment a (nolock)
	where  #hourlyrate.UserKey = a.UserKey 
	and    #hourlyrate.ProjectKey = a.ProjectKey
	and    #hourlyrate.UpdateFlag = 0

	-- found out that a lot of HourlyRate are null
	-- so get it from tUser
	update #hourlyrate
	set    #hourlyrate.HourlyRate = u.HourlyRate
	from   tUser u (nolock)
	where  #hourlyrate.UserKey = u.UserKey 
	and    #hourlyrate.HourlyRate is null
	and    #hourlyrate.UpdateFlag = 0

	update #hourlyrate
	set    #hourlyrate.HourlyRate = ROUND(isnull(#hourlyrate.HourlyRate, 0), 2)

	-- now update HourlyRate on #time
	update #time
	set    #time.HourlyRate = b.HourlyRate
	from   #hourlyrate b
	where  #time.UserKey = b.UserKey
	and    #time.ProjectKey = b.ProjectKey
	and    #time.TaskKey = b.TaskKey
		
	update #time
	set    #time.HourlyRate = isnull(#time.HourlyRate, 0)

	update #time
	set    ActualNonBillableHoursOnTime = ActualHours
			-- note:not actual rate here
	      ,ActualNonBillableAmtOnTime = ROUND(ActualHours * HourlyRate, 2)
	where  IsBillable = 0
	and    IsProBono = 0
	and    WriteOff = 0
	-- added  5/22/12 for 143556
	and ActualRate = 0

	-- added  5/22/12 for 143556
	update #time
	set    ActualNonBillableHoursOnTime = ActualHours
			-- note:not actual rate here
	      --,ActualNonBillableAmtOnTime = ROUND(ActualHours * HourlyRate, 2)
		  -- and changed  5/22/12 for 143556
		   ,ActualNonBillableAmtOnTime = ROUND(ActualHours * ActualRate, 2) 
	where  IsBillable = 0
	and    IsProBono = 0
	and    WriteOff = 0
	and ActualRate <> 0


	-- For probono time, use the hourly rate from the project because all probono services have a rate of 0 for billing
	update #time
	set    ProBonoHours = ActualHours
	      ,ProBonoAmt = ROUND(ActualHours * HourlyRate, 2)
	-- 123484
	--where WriteOffReasonKey = @ProBonoWOKey
	--and   WriteOff = 1
	where  IsProBono = 1
	-- changed  5/22/12 for 143556 
	and ActualRate = 0
	
	-- Added  5/22/12 for 143556 
	update #time
	set    ProBonoHours = ActualHours
	      ,ProBonoAmt = ROUND(ActualHours * ActualRate, 2)
	-- 123484
	--where WriteOffReasonKey = @ProBonoWOKey
	--and   WriteOff = 1
	where  IsProBono = 1
	and ActualRate <> 0
	   

	-- now writeoffs 
	update #time
	set    WriteOffHours = ActualHours
	      --,WriteOffAmt =ROUND(ActualHours * HourlyRate, 2)
		  --changed  5/22/12 for 143556
		   ,WriteOffAmt =ROUND(ActualHours * ActualRate, 2)
	where WriteOff = 1
	-- removed this on 12/14/2011 because written off means written off now
	-- that Probono hours are flagged from the service code starting with PB
	--and   WriteOffReasonKey <> @ProBonoWOKey

	-- put it back for (130320) 01/03/2012 because we are double-dipping with ProBonoHours
	and   WriteOffReasonKey <> @ProBonoWOKey 
	and   IsProBono = 0

	-- correction for 125078 #2, add Probono Hours 
	update #time
	set    TotalHoursWorked = isnull(ActualBillableHoursOnTime, 0) + isnull(ActualNonBillableHoursOnTime, 0)
			+ isnull(ProBonoHours, 0) + isnull(WriteOffHours, 0) 
	      ,TotalAmtWorked = isnull(ActualBillableAmtOnTime, 0) + isnull(ActualNonBillableAmtOnTime, 0)
			+ isnull(ProBonoAmt, 0) + isnull(WriteOffAmt, 0)


	update #time
	set    #time.WriteOffHours = isnull(#time.WriteOffHours, 0)
		  ,#time.WriteOffAmt = isnull(#time.WriteOffAmt, 0)

		  ,#time.ProBonoHours = isnull(#time.ProBonoHours, 0)
		  ,#time.ProBonoAmt = isnull(#time.ProBonoAmt, 0)

		   ,#time.ActualBillableHoursOnTime = isnull(#time.ActualBillableHoursOnTime, 0)
		  ,#time.ActualBillableAmtOnTime = isnull(#time.ActualBillableAmtOnTime, 0)

		  ,#time.ActualNonBillableHoursOnTime = isnull(#time.ActualNonBillableHoursOnTime, 0)
		  ,#time.ActualNonBillableAmtOnTime = isnull(#time.ActualNonBillableAmtOnTime, 0)

	update #time
	set    AccountingAdjustedHours = BilledHours - ActualHours
	      ,AccountingAdjustedAmt = ROUND(BilledHours * BilledRate - ActualHours * ActualRate, 2)
	where  BilledService is not null
	and    ServiceKey = BilledService -- they want adjustments only (without a change of service)

	update #time
	set    InvoicedHours = BilledHours
		  ,InvoicedAmt = ROUND(BilledHours * BilledRate, 2)
	where  InvoiceLineKey > 0

	--3) CAPTURE BUDGETED DATA
	/* Not an inner join but left outer join 3/22/12

	insert #budget (ProjectKey, TaskKey, UserKey)
	select distinct ProjectKey, TaskKey, UserKey
	from   #time
	*/	

	insert #budget (CampaignKey, AccountManager, ProjectTypeKey, ClientKey, ProjectKey, TaskKey, UserKey)
	select distinct p.CampaignKey, p.AccountManager, p.ProjectTypeKey, p.ClientKey, e.ProjectKey, etl.TaskKey, etl.UserKey
	from  tEstimateTaskLabor etl (nolock)
		inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
		inner join tProject p (nolock) on e.ProjectKey = p.ProjectKey
	where e.CompanyKey = @CompanyKey
	and   etl.UserKey > 0
	and   etl.TaskKey > 0
	and   (@UserKey is null or etl.UserKey = @UserKey)
	and   (@ClientKey is null or p.ClientKey = @ClientKey)
	and   (@ProjectTypeKey is null or p.ProjectTypeKey = @ProjectTypeKey)
	and   (@ProjectKey is null or e.ProjectKey = @ProjectKey)
	and   (@AccountManager is null or p.AccountManager = @AccountManager)
	and   (@CampaignKey is null or p.CampaignKey = @CampaignKey)
    and   e.InternalStatus = 4   -- Pyramid does not have external approvers

    -- Now identify the budget data which have actuals or billed 3/22/12
	update #budget
	set    #budget.UpdateFlag = 0

	update #budget
	set    #budget.UpdateFlag = 1 -- actuals exist
	from   #time
	where  #time.ProjectKey = #budget.ProjectKey and #time.TaskKey = #budget.TaskKey and #time.UserKey = #budget.UserKey

	update #budget
	set    #budget.BudgetHours = ISNULL((
		select sum(etl.Hours) 
		from   tEstimateTaskLabor etl (nolock)
		inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
		where e.ProjectKey = #budget.ProjectKey
		and   etl.TaskKey = #budget.TaskKey
		and   etl.UserKey = #budget.UserKey
		and   e.InternalStatus = 4   -- Pyramid does not have external approvers
		),0)

		,#budget.BudgetAmt = ISNULL((
		select sum(round(etl.Hours * etl.Rate, 2)) 
		from   tEstimateTaskLabor etl (nolock)
		inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
		where e.ProjectKey = #budget.ProjectKey
		and   etl.TaskKey = #budget.TaskKey
		and   etl.UserKey = #budget.UserKey
		and   e.InternalStatus = 4   -- Pyramid does not have external approvers
		),0)

		-- corrected equation for Remaining Dollar=
		--= Budgeted Dollar - Actual Billable from Timesheets + written off dollars + probono dollars
		update #budget
		set    #budget.ActualHours = ISNULL((
			--select sum(isnull(#time.ActualBillableHoursOnTime, 0) - isnull(#time.WriteOffHours, 0) - isnull(#time.ProBonoHours, 0))
			-- for 125131 discard Probono hours
			  --select sum(isnull(#time.ActualBillableHoursOnTime, 0) - isnull(#time.WriteOffHours, 0) )
			  -- remove wo
			  select sum(isnull(#time.ActualBillableHoursOnTime, 0) )

			from   #time
			where  #time.ProjectKey = #budget.ProjectKey and #time.TaskKey = #budget.TaskKey and #time.UserKey = #budget.UserKey
		),0)

		update #budget
		set    #budget.ActualAmt = ISNULL((
			--select sum(isnull(#time.ActualBillableAmtOnTime, 0) - isnull(#time.WriteOffAmt, 0) - isnull(#time.ProBonoAmt, 0))
			-- for 125131 discard Probono hours
			--select sum(isnull(#time.ActualBillableAmtOnTime, 0) - isnull(#time.WriteOffAmt, 0) )
			select sum(isnull(#time.ActualBillableAmtOnTime, 0)  )
			from   #time
			where  #time.ProjectKey = #budget.ProjectKey and #time.TaskKey = #budget.TaskKey and #time.UserKey = #budget.UserKey
		),0)


		-- where Actuals exists and ActualRate <> 0, take it from the calculated value in #hourlyrate
		update #budget
		set    #budget.HourlyRate = b.HourlyRate
		from   #hourlyrate b (nolock)
		where  #budget.UserKey = b.UserKey
		and    #budget.TaskKey = b.TaskKey
		and    #budget.ProjectKey = b.ProjectKey

		-- when no actuals, get it from tAssignment or tUser
		update #budget
		set    #budget.HourlyRate = a.HourlyRate
		from   tAssignment a (nolock)
		where  #budget.UserKey = a.UserKey 
		and    #budget.ProjectKey = a.ProjectKey
		and    #budget.HourlyRate is null

		update #budget
		set    #budget.HourlyRate = u.HourlyRate
		from   tUser u (nolock)
		where  #budget.UserKey = u.UserKey 
		and    #budget.HourlyRate is null 
		
		update #budget
		set    #budget.HourlyRate = isnull(#budget.HourlyRate, 0)

		
		update #budget
		set    RemainingHours = isnull(BudgetHours,0) - isnull(ActualHours, 0)
				-- changed 1/21/12 because Pyramid wants RemainingAmt = RemainingHours * HourlyRate 
				--,RemainingAmt = isnull(BudgetAmt, 0) - isnull(ActualAmt, 0)
				-- and put back on 6/5/12
				,RemainingAmt = isnull(BudgetAmt, 0) - isnull(ActualAmt, 0)
				
/* Removed on on 6/5/12
		update #budget
		set    RemainingAmt = RemainingHours * isnull(HourlyRate, 0)
*/	
	
	-- now place the budget data which does not have actuals in #time 3/22/12
	insert #time (Type,TimeKey,CampaignKey, AccountManager, ClientKey,  ProjectTypeKey, ProjectKey, TaskKey, UserKey, HourlyRate)
	select 'budget', NULL, CampaignKey, AccountManager, ClientKey, ProjectTypeKey, ProjectKey, TaskKey, UserKey, HourlyRate
	from   #budget
	where  UpdateFlag = 0 -- indicates no actuals

	--select * from #time

	-- Added this to create total lines 
	create table #results (
		CampaignKey int null
		,AccountManager int null
		,ProjectTypeKey int null
		,ClientKey int null
		,ProjectKey int null		-- Part of the composite key for this report
		,TaskKey int null			-- Part of the composite key for this report
		,UserKey int null			-- Part of the composite key for this report

		,HourlyRate money null  -- hourly rates from tAssignment, all projects use method Project/User for get rate from
								-- or recalc'ed as an average if actuals exist
										
		,ActualBillableHoursOnTime decimal(24,4) null			-- COLUMN H
		,ActualBillableAmtOnTime money null						-- COLUMN I
		,ActualNonBillableHoursOnTime decimal(24,4) null		-- COLUMN J
		,ActualNonBillableAmtOnTime money null					-- COLUMN K
		
		,ProBonoHours decimal(24, 4) null						-- COLUMN L
		,ProBonoAmt money null									-- COLUMN M
		,WriteOffHours decimal(24, 4) null						-- COLUMN N
		,WriteOffAmt decimal(24, 4) null						-- COLUMN O
		
		,TotalNonBillableHours decimal(24,4) null				-- COLUMN R
		,TotalNonBillableAmt money null							-- COLUMN S
		,TotalHoursWorked decimal(24,4) null					-- COLUMN T
		,TotalAmtWorked money null								-- COLUMN U
		
		,AccountingAdjustedHours decimal(24, 4) null			-- COLUMN V
		,AccountingAdjustedAmt money null						-- COLUMN W
		,InvoicedHours decimal(24, 4) null						-- COLUMN X
		,InvoicedAmt money null									-- COLUMN Y

		,BudgetHours decimal(24, 4) null
		,BudgetAmt money null
		,RemainingHours decimal(24, 4) null						-- COLUMN P not in original excel spreadsheet, but I will calculate it
		,RemainingAmt money null								-- COLUMN Q
		
		,TotalLine int null
		)

		insert #results(CampaignKey, ProjectTypeKey, ClientKey, AccountManager, ProjectKey, TaskKey, UserKey, HourlyRate
		,ActualBillableHoursOnTime ,ActualBillableAmtOnTime
		,ActualNonBillableHoursOnTime ,ActualNonBillableAmtOnTime 
		,ProBonoHours ,ProBonoAmt 
		,WriteOffHours,WriteOffAmt 
		,TotalNonBillableHours ,TotalNonBillableAmt 
		,TotalHoursWorked ,TotalAmtWorked 
		,AccountingAdjustedHours ,AccountingAdjustedAmt 
		,InvoicedHours,InvoicedAmt
		)
		select CampaignKey, ProjectTypeKey, ClientKey, AccountManager, ProjectKey, TaskKey, UserKey, HourlyRate

		,sum(ActualBillableHoursOnTime)										as ActualBillableHoursOnTime	
		,sum(ActualBillableAmtOnTime)										as ActualBillableAmtOnTime
		,sum(ActualNonBillableHoursOnTime)									as ActualNonBillableHoursOnTime
		,sum(ActualNonBillableAmtOnTime)									as ActualNonBillableAmtOnTime

		,sum(ProBonoHours)													as ProBonoHours
		,sum(ProBonoAmt)													as ProBonoAmt
		,sum(WriteOffHours)													as WriteOffHours
		,sum(WriteOffAmt)													as WriteOffAmt

		,sum(isnull(ActualNonBillableHoursOnTime, 0) + isnull(ProBonoHours, 0) + isnull(WriteOffHours, 0))	as TotalNonBillableHours
		,sum(isnull(ActualNonBillableAmtOnTime, 0) + isnull(ProBonoAmt,0) + isnull(WriteOffAmt,0))			as TotalNonBillableAmt
		
		,sum(TotalHoursWorked)												as TotalHoursWorked
		,sum(TotalAmtWorked)												as TotalAmtWorked
		
		,sum(AccountingAdjustedHours)										as AccountingAdjustedHours
		,sum(AccountingAdjustedAmt)											as AccountingAdjustedAmt
		,sum(InvoicedHours)													as InvoicedHours
		,sum(InvoicedAmt)													as InvoicedAmt
			
		from #time

		group by CampaignKey, ProjectTypeKey, ClientKey, AccountManager, ProjectKey, TaskKey, UserKey, HourlyRate
			
		update #results
		set    #results.BudgetHours = #budget.BudgetHours
		      ,#results.BudgetAmt = #budget.BudgetAmt
			  ,#results.RemainingHours = #budget.RemainingHours
		      ,#results.RemainingAmt = #budget.RemainingAmt
		from   #budget
		where  #results.ProjectKey = #budget.ProjectKey
		and    #results.TaskKey = #budget.TaskKey
		and    #results.UserKey = #budget.UserKey

-- calculate totals only if we have some records 
if exists (select 1 from #results)
		insert #results (TotalLine
		,ActualBillableHoursOnTime 
		,ActualBillableAmtOnTime
		,ActualNonBillableHoursOnTime 
		,ActualNonBillableAmtOnTime  
		,ProBonoHours 
		,ProBonoAmt  
		,WriteOffHours 
		,WriteOffAmt  
		,TotalNonBillableHours 
		,TotalNonBillableAmt  
		,TotalHoursWorked  
		,TotalAmtWorked  
		,AccountingAdjustedHours 
		,AccountingAdjustedAmt  
		,InvoicedHours 
		,InvoicedAmt  
		,BudgetHours 
		,BudgetAmt  
		,RemainingAmt  
		,RemainingHours )
		select 1
		,sum(ActualBillableHoursOnTime) 
		,sum(ActualBillableAmtOnTime)
		,sum(ActualNonBillableHoursOnTime) 
		,sum(ActualNonBillableAmtOnTime)  
		,sum(ProBonoHours) 
		,sum(ProBonoAmt)  
		,sum(WriteOffHours) 
		,sum(WriteOffAmt)  
		,sum(TotalNonBillableHours) 
		,sum(TotalNonBillableAmt)  
		,sum(TotalHoursWorked)  
		,sum(TotalAmtWorked)  
		,sum(AccountingAdjustedHours) 
		,sum(AccountingAdjustedAmt)  
		,sum(InvoicedHours) 
		,sum(InvoicedAmt)  
		,sum(BudgetHours) 
		,sum(BudgetAmt)  
		,sum(RemainingAmt)  
		,sum(RemainingHours)
		from #results

	select   ca.CampaignName -- CampaignID is same as CampaignName at Pyramid
		    ,pt.ProjectTypeName
		    ,c.CustomerID
			,c.CompanyName
			,p.ProjectNumber
		    ,p.ProjectName
		    ,ta.TaskID
		    ,ta.TaskName
			,isnull(u.FirstName + ' ', '')+isnull(u.LastName, '') as UserName
			,isnull(am.FirstName + ' ', '')+isnull(am.LastName, '') as AccountManagerName
			
			,#results.*
	from #results
			
	left outer join tCampaign ca (nolock) on #results.CampaignKey = ca.CampaignKey 
	left outer join tProjectType pt (nolock) on #results.ProjectTypeKey = pt.ProjectTypeKey
	left outer join tCompany c (nolock) on #results.ClientKey = c.CompanyKey
	left outer join tProject p (nolock) on #results.ProjectKey = p.ProjectKey
	left outer join tTask ta (nolock) on #results.TaskKey = ta.TaskKey
	left outer join tUser am (nolock) on #results.AccountManager = am.UserKey
	left outer join tUser u (nolock) on #results.UserKey = u.UserKey 
	 
	 order by isnull(#results.TotalLine,0), ca.CampaignName,p.ProjectNumber,p.ProjectName,ta.TaskName,isnull(u.FirstName + ' ', '')+isnull(u.LastName, '')


/*
	select   ca.CampaignName -- CampaignID is same as CampaignName at Pyramid
		    ,pt.ProjectTypeName
		    ,c.CustomerID
			,c.CompanyName
			,p.ProjectNumber
		    ,p.ProjectName
		    ,ta.TaskID
		    ,ta.TaskName
			,isnull(u.FirstName + ' ', '')+isnull(u.LastName, '') as UserName
			,isnull(am.FirstName + ' ', '')+isnull(am.LastName, '') as AccountManagerName
			
			,act.*
			
			,bud.BudgetHours
			,bud.BudgetAmt
			,bud.RemainingHours
			,bud.RemainingAmt

	from   (
			select CampaignKey, ProjectTypeKey, ClientKey, AccountManager, ProjectKey, TaskKey, UserKey, HourlyRate

			,sum(ActualBillableHoursOnTime)										as ActualBillableHoursOnTime
			,sum(ActualBillableAmtOnTime)										as ActualBillableAmtOnTime
			,sum(ActualNonBillableHoursOnTime)									as ActualNonBillableHoursOnTime
			,sum(ActualNonBillableAmtOnTime)									as ActualNonBillableAmtOnTime
			,sum(ProBonoHours)													as ProBonoHours
			,sum(ProBonoAmt)													as ProBonoAmt
			,sum(WriteOffHours)													as WriteOffHours
			,sum(WriteOffAmt)													as WriteOffAmt
			,sum(ActualNonBillableHoursOnTime + ProBonoHours + WriteOffHours)	as TotalNonBillableHours
			,sum(ActualNonBillableAmtOnTime + ProBonoAmt + WriteOffAmt)			as TotalNonBillableAmt
			,sum(TotalHoursWorked)												as TotalHoursWorked
			,sum(TotalAmtWorked)												as TotalAmtWorked
			,sum(AccountingAdjustedHours)										as AccountingAdjustedHours
			,sum(AccountingAdjustedAmt)											as AccountingAdjustedAmt
			,sum(InvoicedHours)													as InvoicedHours
			,sum(InvoicedAmt)													as InvoicedAmt
			
			from #time

			group by CampaignKey, ProjectTypeKey, ClientKey, AccountManager, ProjectKey, TaskKey, UserKey, HourlyRate
			 
			) as act

	inner join #budget bud on bud.ProjectKey = act.ProjectKey and bud.TaskKey = act.TaskKey and bud.UserKey = act.UserKey

	left outer join tCampaign ca (nolock) on act.CampaignKey = ca.CampaignKey 
	left outer join tProjectType pt (nolock) on act.ProjectTypeKey = pt.ProjectTypeKey
	left outer join tCompany c (nolock) on act.ClientKey = c.CompanyKey
	left outer join tProject p (nolock) on act.ProjectKey = p.ProjectKey
	left outer join tTask ta (nolock) on act.TaskKey = ta.TaskKey
	left outer join tUser am (nolock) on act.AccountManager = am.UserKey
	inner join tUser u (nolock) on act.UserKey = u.UserKey 
	 
	 order by ca.CampaignName,p.ProjectNumber,p.ProjectName,ta.TaskName,isnull(u.FirstName + ' ', '')+isnull(u.LastName, '')
*/

	RETURN 1
GO
