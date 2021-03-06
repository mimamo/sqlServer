USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectRollupQueueUpdate]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectRollupQueueUpdate]
	(
	@ProcessingDelay int = 3 -- 3 minutes by default
	)
AS
	SET NOCOUNT ON

 /*
  || When     Who Rel     What
  || 04/02/12 GHL 10.554  Creation to limit the number of times that the project rollup is called   
  ||                      Used only for labor. The problem is that in the widgets, if we have 10 tasks
  ||                      with the same project, the project rollup is called 10 times.
  ||                      Here an entry is made in the project rollup queue, if the project does not exist.
  ||                      Every 3 mins, the queue is processed by an unlucky user 
  || 04/26/12 GHL 10.555  Added logic for delay so that it can be immediately processed             
  */

	declare @CurrDate datetime			select @CurrDate = getdate()

	create table #tProjectRollup (ProjectKey int, CompanyKey int)

	if @ProcessingDelay <= 0
	begin
		insert #tProjectRollup (ProjectKey, CompanyKey)

		select distinct q.ProjectKey, p.CompanyKey
		from   tProjectRollupQueue q (nolock)
		inner  join tProject p (nolock) on q.ProjectKey = p.ProjectKey
		where  q.Updated = 0 
	end
	else
	begin
		insert #tProjectRollup (ProjectKey, CompanyKey)

		select distinct q.ProjectKey, p.CompanyKey
		from   tProjectRollupQueue q (nolock)
		inner  join tProject p (nolock) on q.ProjectKey = p.ProjectKey
		where  q.Updated = 0 
		and    datediff(mi, DateRequested, @CurrDate) > @ProcessingDelay 
	end
	
	if (select count(*) from #tProjectRollup) = 0
		return 1

	-- do the item project rollup, this works off the #tProjectRollup
	exec sptProjectItemRollupUpdate null, 0, 1, 1, 1, 1, 1 -- MultiMode, tran type = labor

	Update tTask Set TotalActualHours = ISNULL(
		(
		select SUM(ti.ActualHours)
		from tTime ti (nolock)
		where ti.ProjectKey = tTask.ProjectKey -- Added ProjectKey to restrict records 
		-- this will sum up to the Tracking task completely 
		-- + the detail task
		-- will not sum up to the immediate summary task (if not tracking)
		and   (ti.DetailTaskKey = tTask.TaskKey or ti.TaskKey = tTask.TaskKey)
		), 0)
	from  #tProjectRollup roll
	Where tTask.ProjectKey = roll.ProjectKey
	
	declare @UpdatedEnded datetime
	select @UpdatedEnded = getdate()

	update tProjectRollup
	set    tProjectRollup.Hours = pir2.Hours
	      ,tProjectRollup.HoursBilled = pir2.HoursBilled
	      ,tProjectRollup.HoursInvoiced  = pir2.HoursInvoiced 
	      ,tProjectRollup.LaborNet  = pir2.LaborNet 
	      ,tProjectRollup.LaborNetApproved  = pir2.LaborNetApproved 
	      ,tProjectRollup.LaborGross  = pir2.LaborGross 
	      ,tProjectRollup.LaborGrossApproved  = pir2.LaborGrossApproved 
	      ,tProjectRollup.LaborUnbilled  = pir2.LaborUnbilled 
	      ,tProjectRollup.LaborWriteOff  = pir2.LaborWriteOff 
	      ,tProjectRollup.LaborBilled  = pir2.LaborBilled 
	      ,tProjectRollup.LaborInvoiced  = pir2.LaborInvoiced 
		  ,tProjectRollup.UpdateString = 'sptProjectRollupQueueUpdate'
		  ,tProjectRollup.UpdateStarted = @CurrDate
		  ,tProjectRollup.UpdateEnded = @UpdatedEnded
	from (
	
		Select pir.ProjectKey
		,Sum(pir.Hours) as Hours
		,Sum(pir.HoursBilled) as HoursBilled
		,Sum(pir.HoursInvoiced) as HoursInvoiced
		,Sum(pir.LaborNet) as LaborNet 
		,Sum(pir.LaborNetApproved) as LaborNetApproved
		,Sum(pir.LaborGross) as LaborGross
		,Sum(pir.LaborGrossApproved) as LaborGrossApproved 
		,Sum(pir.LaborUnbilled) as LaborUnbilled 
		,Sum(pir.LaborWriteOff) as LaborWriteOff 
		,Sum(pir.LaborBilled) as LaborBilled 
		,Sum(pir.LaborInvoiced) as LaborInvoiced 
		from tProjectItemRollup pir (NOLOCK)
			inner join #tProjectRollup b on pir.ProjectKey = b.ProjectKey
		group by pir.ProjectKey	
		) as pir2
	
	where tProjectRollup.ProjectKey = pir2.ProjectKey

	
	update tProjectRollupQueue
	set    tProjectRollupQueue.Updated = 1
	      ,tProjectRollupQueue.DateUpdated = @UpdatedEnded
	from   #tProjectRollup
	where  #tProjectRollup.ProjectKey = tProjectRollupQueue.ProjectKey
	 
-- I just leave 30 min, to sudy the queue
	delete tProjectRollupQueue
	where  datediff(mi, DateUpdated, @CurrDate) > 30 -- more than 30 min
	and    Updated = 1

	RETURN 1
GO
