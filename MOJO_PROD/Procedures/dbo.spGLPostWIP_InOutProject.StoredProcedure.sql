USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostWIP_InOutProject]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostWIP_InOutProject]
	(
	@ProjectKey int
	)
AS
	SET NOCOUNT ON 
	
		select  wpd.UIDEntityKey, t.GLAccountKey, ti.WIPAmount, ROUND(ti.ActualHours * ti.ActualRate, 2)
		, SUM(case when t.PostSide = 'D' then wpd.Amount else -1 * wpd.Amount end)
	from   tWIPPostingDetail wpd (nolock)
		inner join tTransaction t (nolock) on wpd.TransactionKey = t.TransactionKey
		inner join tTime ti (nolock) on wpd.UIDEntityKey = ti.TimeKey
	where  t.ProjectKey = @ProjectKey
	and    t.Entity = 'WIP'
	and    t.Reference like 'WIP LABOR%'
	group by wpd.UIDEntityKey, t.GLAccountKey, ti.WIPAmount, ti.ActualHours,ti.ActualRate
	order by wpd.UIDEntityKey, t.GLAccountKey, ti.WIPAmount, ti.ActualHours,ti.ActualRate
	
/* then details		
select wpd.* , t.GLAccountKey, t.TransactionDate, t.Debit, t.Credit, t.Reference, t.ProjectKey
 from tWIPPostingDetail wpd (nolock)
inner join tTransaction t (nolock) on wpd.TransactionKey = t.TransactionKey
 where UIDEntityKey = '6f5522d3-2c97-4cad-a15b-0d139f79c9ec'
order by  t.GLAccountKey, t.TransactionKey
*/
	
	RETURN
GO
