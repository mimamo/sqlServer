USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostWIP_InOut]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostWIP_InOut]
	(
	@CompanyKey int
	)
AS
	SET NOCOUNT ON 
	
	create table #wip (
		TimeKey uniqueidentifier null
		,LineWIPAmount money null  -- tTime.WIPAmount
		,LineAmount money null     -- act hours * act rate
		,WPDInAmount money null    -- what went in
		,WPDAdjustAmount money null -- adjustments ...should be 0
		,WPDOutAmount money null   -- what went out
		,UpdateFlag int)
		
	declare @WIPLaborAssetAccountKey int
	select @WIPLaborAssetAccountKey = WIPLaborAssetAccountKey
	from   tPreference (nolock)
	where  CompanyKey = @CompanyKey
		
	insert #wip (TimeKey, LineWIPAmount, LineAmount, WPDInAmount, WPDAdjustAmount, WPDOutAmount, UpdateFlag)
	select distinct ti.TimeKey, 0, 0, 0, 0, 0, 0  		
	from tTime ti (nolock)
		inner join tWIPPostingDetail wpd (nolock) on ti.TimeKey = wpd.UIDEntityKey
	where isnull(ti.WIPAmount, 0) > 0
	
	update #wip
	set    #wip.LineWIPAmount = ti.WIPAmount
	      ,#wip.LineAmount = ROUND(ti.ActualHours * ti.ActualRate, 2)
	from   tTime ti (nolock)
	where  #wip.TimeKey = ti.TimeKey
	
	update #wip
	set    #wip.WPDInAmount = wpd.Amount
	from   tWIPPostingDetail wpd (nolock)
			,tTransaction t (nolock)
	where  #wip.TimeKey = wpd.UIDEntityKey
	and    wpd.TransactionKey = t.TransactionKey
	and    t.Reference = 'WIP LABOR IN'	
	and    t.GLAccountKey =	@WIPLaborAssetAccountKey
	
	
	update #wip
	set    #wip.WPDOutAmount = wpd.Amount
	from   tWIPPostingDetail wpd (nolock)
			,tTransaction t (nolock)
	where  #wip.TimeKey = wpd.UIDEntityKey
	and    wpd.TransactionKey = t.TransactionKey
	and    t.Reference = 'WIP LABOR BILL'	
	and    t.GLAccountKey =	@WIPLaborAssetAccountKey
	
	
	update #wip
	set    #wip.WPDAdjustAmount = ISNULL((
		select sum(t.Debit - t.Credit)
	from   tWIPPostingDetail wpd (nolock)
			,tTransaction t (nolock)
	where  #wip.TimeKey = wpd.UIDEntityKey
	and    wpd.TransactionKey = t.TransactionKey
	and    t.Reference = 'WIP LABOR IN - ADJUSTMENT/TRANSFER'	
	and    t.GLAccountKey =	@WIPLaborAssetAccountKey
	),0)
	
	update #wip
	set    #wip.UpdateFlag = 1
	where  #wip.WPDAdjustAmount <> 0
	
	
	update #wip
	set    #wip.UpdateFlag = 1
	where  #wip.WPDOutAmount <> 0
	and    #wip.WPDInAmount <> #wip.WPDOutAmount 
	and    #wip.UpdateFlag = 0
	
	delete #wip where UpdateFlag = 0
	
	select p.ProjectNumber
	      ,u.FirstName + ' ' + u.LastName as UserName
	      ,ti.ActualHours
	      ,ti.ActualRate
	      ,convert(varchar(10), ti.WorkDate, 101) as WorkDate
	      ,ti.TransferComment
	      ,w.* 
	from #wip w
	inner join tTime ti (nolock) on w.TimeKey = ti.TimeKey
	inner join tUser u (nolock) on ti.UserKey = u.UserKey 
	inner join tProject p (nolock) on ti.ProjectKey = p.ProjectKey

	
/* then details		
select wpd.* , t.GLAccountKey, t.TransactionDate, t.Debit, t.Credit, t.Reference, t.ProjectKey
 from tWIPPostingDetail wpd (nolock)
inner join tTransaction t (nolock) on wpd.TransactionKey = t.TransactionKey
 where UIDEntityKey = '6f5522d3-2c97-4cad-a15b-0d139f79c9ec'
order by  t.GLAccountKey, t.TransactionKey
*/
	
	RETURN
GO
