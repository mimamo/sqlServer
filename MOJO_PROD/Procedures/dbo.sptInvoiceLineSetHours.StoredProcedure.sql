USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineSetHours]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[sptInvoiceLineSetHours]
	(
	@InvoiceKey int
	)
as --Encrypt

 /*
  || When     Who Rel		What
  || 03/19/15 GHL 10.5.9.1  For Abelson Taylor set Hours on Title/Service lines on detail lines
  ||                        and rollup to summary lines
  || 03/20/15 GHL 10.5.9.1  Removed the update of the summary lines after testing Layout printing with Matt
  || 03/24/15 GHL 10.5.9.1  Added back the update of the summary lines as explained below
  */
    
  /* This is how we should update the summary lines

  segment / sub item details			Qty = 0
      project / sub item details		Qty = 0
	    bill item / sub item details	Qty = 0
		   service / detail or tran     Qty = 6
				time 2 hours
				time 4 hours

	 segment / sub item details			Qty = 0
      project / sub item details		Qty = 0
	    bill item / details				Qty = 6
		   service / detail or tran     Qty = 6

	 segment / sub item details			Qty = 0
      project / details					Qty = 6
	    bill item / details				Qty = 6
		   service / detail or tran     Qty = 6

	 segment / details					Qty = 6
      project / details					Qty = 6
	    bill item / details				Qty = 6
		   service / detail or tran     Qty = 6

  */

  create table #laborlines (ParentLineKey int null, InvoiceLineKey int null
  , Hours decimal(24,4) null, UnitAmount money null, TotalAmount money null
  , LineType int null, DisplayOption int null, RolledUp int null)

  insert #laborlines (ParentLineKey, InvoiceLineKey, Hours, TotalAmount,LineType, DisplayOption)
  select ParentLineKey, InvoiceLineKey, 0, 0, LineType, DisplayOption
  from   tInvoiceLine (nolock)
  where  InvoiceKey = @InvoiceKey
  and    LineType = 2 -- Detail
  and    BillFrom = 2 -- TM
  and    Entity in ('tService', 'tTitle')

  if (select count(*) from #laborlines) = 0
	return 1

  update #laborlines 
  set    #laborlines.Hours = ( select sum(BilledHours)
				from   tTime t (nolock)
				 where  #laborlines.InvoiceLineKey = t.InvoiceLineKey
				 )
		,#laborlines.TotalAmount = ( select sum(round(BilledHours * BilledRate, 2))
				  from   tTime t (nolock)
				  where  #laborlines.InvoiceLineKey = t.InvoiceLineKey
				  )

-- removed the update of the summary lines after testing with Matt

  -- now add the parents of the detail lines
  insert #laborlines (ParentLineKey, InvoiceLineKey, LineType, DisplayOption)
  select distinct il.ParentLineKey, il.InvoiceLineKey, 1, il.DisplayOption
  from   tInvoiceLine il (nolock)
  inner join #laborlines b on il.InvoiceLineKey = b.ParentLineKey
  where  il.InvoiceKey = @InvoiceKey   

  -- and rollup hours and total on parents
  update #laborlines
  set    #laborlines.Hours = (select sum(Hours)
			from #laborlines children
			where children.ParentLineKey = #laborlines.InvoiceLineKey) 
		,#laborlines.TotalAmount = (select sum(TotalAmount)
			from #laborlines children
			where children.ParentLineKey = #laborlines.InvoiceLineKey)
		,#laborLines.RolledUp = 1 
	where LineType = 1 -- summary
	and   isnull(RolledUp, 0) = 0

  -- second pass
  insert #laborlines (ParentLineKey, InvoiceLineKey, LineType, DisplayOption)
  select distinct il.ParentLineKey, il.InvoiceLineKey, 1, il.DisplayOption
  from   tInvoiceLine il (nolock)
  inner join #laborlines b on il.InvoiceLineKey = b.ParentLineKey and b.LineType = 1
  where  il.InvoiceKey = @InvoiceKey   
  and    il.InvoiceLineKey not in (select InvoiceLineKey from #laborlines)

  update #laborlines
  set    #laborlines.Hours = (select sum(Hours)
			from #laborlines children
			where children.ParentLineKey = #laborlines.InvoiceLineKey) 
		,#laborlines.TotalAmount = (select sum(TotalAmount)
			from #laborlines children
			where children.ParentLineKey = #laborlines.InvoiceLineKey)
		,#laborLines.RolledUp = 1 
	where LineType = 1 -- summary
	and   isnull(RolledUp, 0) = 0

  -- third pass
  insert #laborlines (ParentLineKey, InvoiceLineKey, LineType, DisplayOption)
  select distinct il.ParentLineKey, il.InvoiceLineKey, 1, il.DisplayOption
  from   tInvoiceLine il (nolock)
  inner join #laborlines b on il.InvoiceLineKey = b.ParentLineKey and b.LineType = 1
  where  il.InvoiceKey = @InvoiceKey   
  and    il.InvoiceLineKey not in (select InvoiceLineKey from #laborlines)

  update #laborlines
  set    #laborlines.Hours = (select sum(Hours)
			from #laborlines children
			where children.ParentLineKey = #laborlines.InvoiceLineKey) 
		,#laborlines.TotalAmount = (select sum(TotalAmount)
			from #laborlines children
			where children.ParentLineKey = #laborlines.InvoiceLineKey)
		,#laborLines.RolledUp = 1 
	where LineType = 1 -- summary
	and   isnull(RolledUp, 0) = 0

  -- 4 pass
  insert #laborlines (ParentLineKey, InvoiceLineKey, LineType, DisplayOption)
  select distinct il.ParentLineKey, il.InvoiceLineKey, 1, il.DisplayOption
  from   tInvoiceLine il (nolock)
  inner join #laborlines b on il.InvoiceLineKey = b.ParentLineKey and b.LineType = 1
  where  il.InvoiceKey = @InvoiceKey   
  and    il.InvoiceLineKey not in (select InvoiceLineKey from #laborlines)

  update #laborlines
  set    #laborlines.Hours = (select sum(Hours)
			from #laborlines children
			where children.ParentLineKey = #laborlines.InvoiceLineKey) 
		,#laborlines.TotalAmount = (select sum(TotalAmount)
			from #laborlines children
			where children.ParentLineKey = #laborlines.InvoiceLineKey)
		,#laborLines.RolledUp = 1 
	where LineType = 1 -- summary
	and   isnull(RolledUp, 0) = 0

  -- 5 pass
  insert #laborlines (ParentLineKey, InvoiceLineKey, LineType, DisplayOption)
  select distinct il.ParentLineKey, il.InvoiceLineKey, 1, il.DisplayOption
  from   tInvoiceLine il (nolock)
  inner join #laborlines b on il.InvoiceLineKey = b.ParentLineKey and b.LineType = 1
  where  il.InvoiceKey = @InvoiceKey   
  and    il.InvoiceLineKey not in (select InvoiceLineKey from #laborlines)

  update #laborlines
  set    #laborlines.Hours = (select sum(Hours)
			from #laborlines children
			where children.ParentLineKey = #laborlines.InvoiceLineKey) 
		,#laborlines.TotalAmount = (select sum(TotalAmount)
			from #laborlines children
			where children.ParentLineKey = #laborlines.InvoiceLineKey)
		,#laborLines.RolledUp = 1 
	where LineType = 1 -- summary
	and   isnull(RolledUp, 0) = 0


  -- 6 pass
  insert #laborlines (ParentLineKey, InvoiceLineKey, LineType, DisplayOption)
  select distinct il.ParentLineKey, il.InvoiceLineKey, 1, il.DisplayOption
  from   tInvoiceLine il (nolock)
  inner join #laborlines b on il.InvoiceLineKey = b.ParentLineKey and b.LineType = 1
  where  il.InvoiceKey = @InvoiceKey   
  and    il.InvoiceLineKey not in (select InvoiceLineKey from #laborlines)

  update #laborlines
  set    #laborlines.Hours = (select sum(Hours)
			from #laborlines children
			where children.ParentLineKey = #laborlines.InvoiceLineKey) 
		,#laborlines.TotalAmount = (select sum(TotalAmount)
			from #laborlines children
			where children.ParentLineKey = #laborlines.InvoiceLineKey)
		,#laborLines.RolledUp = 1 
	where LineType = 1 -- summary
	and   isnull(RolledUp, 0) = 0


  -- 7 pass
  insert #laborlines (ParentLineKey, InvoiceLineKey, LineType, DisplayOption)
  select distinct il.ParentLineKey, il.InvoiceLineKey, 1, il.DisplayOption
  from   tInvoiceLine il (nolock)
  inner join #laborlines b on il.InvoiceLineKey = b.ParentLineKey and b.LineType = 1
  where  il.InvoiceKey = @InvoiceKey   
  and    il.InvoiceLineKey not in (select InvoiceLineKey from #laborlines)

  update #laborlines
  set    #laborlines.Hours = (select sum(Hours)
			from #laborlines children
			where children.ParentLineKey = #laborlines.InvoiceLineKey) 
		,#laborlines.TotalAmount = (select sum(TotalAmount)
			from #laborlines children
			where children.ParentLineKey = #laborlines.InvoiceLineKey)
		,#laborLines.RolledUp = 1 
	where LineType = 1 -- summary
	and   isnull(RolledUp, 0) = 0

  -- 8 pass
  insert #laborlines (ParentLineKey, InvoiceLineKey, LineType, DisplayOption)
  select distinct il.ParentLineKey, il.InvoiceLineKey, 1, il.DisplayOption
  from   tInvoiceLine il (nolock)
  inner join #laborlines b on il.InvoiceLineKey = b.ParentLineKey and b.LineType = 1
  where  il.InvoiceKey = @InvoiceKey   
  and    il.InvoiceLineKey not in (select InvoiceLineKey from #laborlines)

  update #laborlines
  set    #laborlines.Hours = (select sum(Hours)
			from #laborlines children
			where children.ParentLineKey = #laborlines.InvoiceLineKey) 
		,#laborlines.TotalAmount = (select sum(TotalAmount)
			from #laborlines children
			where children.ParentLineKey = #laborlines.InvoiceLineKey)
		,#laborLines.RolledUp = 1 
	where LineType = 1 -- summary
	and   isnull(RolledUp, 0) = 0
	
-- 9 pass
  insert #laborlines (ParentLineKey, InvoiceLineKey, LineType, DisplayOption)
  select distinct il.ParentLineKey, il.InvoiceLineKey, 1, il.DisplayOption
  from   tInvoiceLine il (nolock)
  inner join #laborlines b on il.InvoiceLineKey = b.ParentLineKey and b.LineType = 1
  where  il.InvoiceKey = @InvoiceKey   
  and    il.InvoiceLineKey not in (select InvoiceLineKey from #laborlines)

  update #laborlines
  set    #laborlines.Hours = (select sum(Hours)
			from #laborlines children
			where children.ParentLineKey = #laborlines.InvoiceLineKey) 
		,#laborlines.TotalAmount = (select sum(TotalAmount)
			from #laborlines children
			where children.ParentLineKey = #laborlines.InvoiceLineKey)
		,#laborLines.RolledUp = 1 
	where LineType = 1 -- summary
	and   isnull(RolledUp, 0) = 0

	
  update #laborlines 
  set    #laborlines.UnitAmount = TotalAmount / Abs(Hours) -- careful about voided invoices
  where  Hours <> 0

  update #laborlines 
  set    #laborlines.UnitAmount = TotalAmount
  where  Hours = 0

  update #laborlines 
  set    #laborlines.Hours = 0
        ,#laborlines.UnitAmount = 0
  where  LineType = 1	  -- summary
  and    DisplayOption = 2 -- Sub Item Display

  delete #laborlines 
  where  InvoiceLineKey not in (select InvoiceLineKey from tInvoiceLine (nolock) where InvoiceKey = @InvoiceKey) 

  update tInvoiceLine
  set    tInvoiceLine.Quantity = b.Hours
        ,tInvoiceLine.UnitAmount = b.UnitAmount
		--,tInvoiceLine.TotalAmount = b.TotalAmount -- do not update the Total Amount, it is correctly rolledup by the Invoice Printout designer
  from  #laborlines b
  where tInvoiceLine.InvoiceLineKey = b.InvoiceLineKey


--  select * from #laborlines
GO
