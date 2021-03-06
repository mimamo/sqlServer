USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRetainerMarkLaborAsBilled]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRetainerMarkLaborAsBilled]
	(
	@RetainerKey int
	,@PostingDate smalldatetime = null
	)
AS --Encrypt

 /*
  || When     Who Rel    What
  || 03/19/12 GHL 10.554 (136416) mark as billed time entries for the retainer
  ||                      Include Labor = 0
  ||                         1) All time entries must be billed
  ||                      Include Labor = 1
  ||                         2)If in tRetainerItems will be marked as billed
  ||                         3)If not in tRetainerItems must be billed
  ||                         4)If no service, must be billed
  ||
  ||                       They bill at the beginning of each month
  ||                       The goal is to mark as billed during the month (for reports)
  ||                       so that they do not have to wait till the end of the month  
  */

	SET NOCOUNT ON

	declare @CompanyKey int
	declare @IncludeLabor int
	declare @DateBilled smalldatetime

	if isnull(@RetainerKey, 0) = 0
		return 1

	select @CompanyKey = CompanyKey
	      ,@IncludeLabor = IncludeLabor 
	from   tRetainer (nolock) 
	where  RetainerKey = @RetainerKey
	
	if @@ROWCOUNT = 0 or isnull(@IncludeLabor, 0) = 0
		return 1
	 
	if @PostingDate is null 
		select @DateBilled = getdate()
	else
		select @DateBilled = @PostingDate
	
	select @DateBilled = cast(cast(DATEPART(m,@DateBilled) as varchar(5))+'/'+cast(DATEPART(d,@DateBilled) as varchar(5))+'/'+cast(DATEPART(yy,@DateBilled)as varchar(5)) as smalldatetime)
		
	create table #time (TimeKey uniqueidentifier null)

	-- same query as in spMassBillingBillRetainer
	insert #time (TimeKey)
	select  t.TimeKey
	from    tTime t (nolock)
	inner join tTimeSheet ts (nolock) on t.TimeSheetKey = ts.TimeSheetKey
   	inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
	inner join tRetainerItems ri (nolock) on t.ServiceKey = ri.EntityKey
	where p.CompanyKey = @CompanyKey
	and   p.RetainerKey = @RetainerKey
	AND   p.NonBillable = 0 -- Could also take all
	AND   p.Closed = 0
	and   ri.RetainerKey = @RetainerKey
	and   ri.Entity = 'tService'
	and	  ts.Status = 4
	--and   t.DateBilled is null -- same as 2 lines below
	and   t.InvoiceLineKey IS NULL
	and   ISNULL(t.WriteOff, 0) = 0
	and   ISNULL(t.OnHold, 0) = 0
	and	  NOT EXISTS (SELECT 1 
			FROM tBillingDetail bd (NOLOCK)
				INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
			WHERE b.CompanyKey = @CompanyKey
			AND   b.Status < 5
			AND   bd.EntityGuid = t.TimeKey  
			AND   bd.Entity = 'tTime'
			)


	update tTime
	set    tTime.InvoiceLineKey = 0
	      ,tTime.WriteOff = 0
	      ,tTime.BilledHours = tTime.ActualHours
	      ,tTime.BilledRate = tTime.ActualRate
	      ,tTime.DateBilled = @DateBilled
	from   #time b
	where  tTime.TimeKey = b.TimeKey


	RETURN 1
GO
