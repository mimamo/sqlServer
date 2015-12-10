USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPWorksheetProjectTypeProject]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessWIPWorksheetProjectTypeProject]
	(
	@NewInvoiceKey INT
	,@DefaultSalesAccountKey int
	,@DefaultClassKey int
	,@WorkTypeKey int
	,@PostSalesUsingDetail tinyint
	)
AS --Encrypt

	SET NOCOUNT ON
	
  /*
  || When   Who         Rel    What
  || GHL    02/08/08    8.504 (20788) Creation for Action Integrated Marketing
  ||                    Group by Project Type then Project
  || GHL    02/22/08    8.504 (21706) Fixed bad join when getting BillAmount
  || GHL    04/22/09   10.024 Setting now AccruedCost only if po.BillAt in (0,1)
  || GHL    10/04/13   10.573 Using now PTotalCost for multi currency
  || 11/07/13 GHL 10.574 pod.AccruedCost is in HC
  */
	
	/* Assume done in calling program
	create table #tProcWIPKeys (ProjectKey int null					
							, EntityType varchar(20) null
							, EntityKey varchar(50) null
							, Action int null)
	*/

	-- One invoice line per project
	create table #projecttype (ProjectKey int null
						, ProjectNumber varchar(50) null
						, ProjectName varchar(100) null
						, ProjectTypeName varchar(100) null
						, BillAmount money null
						, InvoiceLineKey int null)
	
	insert #projecttype (ProjectKey, ProjectNumber, ProjectName, ProjectTypeName, BillAmount)
	select distinct a.ProjectKey, p.ProjectNumber, p.ProjectName, isnull(pt.ProjectTypeName, ''), 0
	from   #tProcWIPKeys a
	inner join tProject p (nolock) on a.ProjectKey = p.ProjectKey
	left outer join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey	
	
	declare @ProjectKey int
	declare @ProjectNumber varchar(50)
	declare @ProjectName varchar(100)
	declare @ProjectTypeName varchar(100)
	declare @ParentInvoiceLineKey int
	declare @NewInvoiceLineKey int
	declare @RetVal int
	declare @BillAmount money
	declare @LineSubject varchar(100)
	
		-- get amount to billed
				  	
		-- Time
		update #projecttype
		set    BillAmount = BillAmount + isnull((
			select (sum(round(isnull(ActualHours,0)*isnull(ActualRate,0), 2)))
			from tTime t (nolock) ,#tProcWIPKeys w
			where w.EntityType = 'Time'
			and t.TimeKey = cast(w.EntityKey as uniqueidentifier)
			and t.ProjectKey = #projecttype.ProjectKey
			),0)

		update #projecttype
		set    BillAmount = BillAmount + isnull((
			select sum(BillableCost)
			from tExpenseReceipt t (nolock),#tProcWIPKeys w
			where w.EntityType = 'Expense'
			and t.ExpenseReceiptKey = cast(w.EntityKey as integer)
			and t.ProjectKey = #projecttype.ProjectKey
			),0)

		update #projecttype
		set    BillAmount = BillAmount + isnull((
			select sum(BillableCost)
			from tMiscCost t (nolock),#tProcWIPKeys w
			where w.EntityType = 'MiscExpense'
			and t.MiscCostKey = cast(w.EntityKey as integer)
			and t.ProjectKey = #projecttype.ProjectKey
			),0)


		update #projecttype
		set    BillAmount = BillAmount + isnull((
			select sum(BillableCost)
			from tVoucherDetail t (nolock),#tProcWIPKeys w
			where w.EntityType = 'Voucher'
			and t.VoucherDetailKey = cast(w.EntityKey as integer)		   
			and t.ProjectKey = #projecttype.ProjectKey
			),0)

		update #projecttype
		set    BillAmount = BillAmount + isnull((
			select sum(Case ISNULL(po.BillAt, 0) 
			When 0 then isnull(BillableCost,0)
			When 1 then isnull(PTotalCost,isnull(TotalCost,0))
			When 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end )
			from tPurchaseOrderDetail pod (nolock), tPurchaseOrder po (nolock)
				,#tProcWIPKeys w
			where w.EntityType = 'Order'
			and pod.PurchaseOrderDetailKey = cast(w.EntityKey as integer)
			and po.PurchaseOrderKey = pod.PurchaseOrderKey   
			and pod.ProjectKey = #projecttype.ProjectKey
			),0)


--select * from #projecttype
--select * from #tProcWIPKeys

	-- First loop
	-- insert first by project where there is no project type
	select @ProjectNumber = ''	
	while (1=1)
	begin	
		select @ProjectNumber = MIN(ProjectNumber)
		from  #projecttype
		where ProjectNumber > @ProjectNumber
		and   ProjectTypeName = ''
		
		if @ProjectNumber is null
			break
			
		select @ProjectKey = ProjectKey
			  ,@ProjectName = ProjectName
			  ,@BillAmount = BillAmount
		from   #projecttype
		where  ProjectNumber = @ProjectNumber

		select @LineSubject = left(@ProjectNumber + ' ' + @ProjectName, 100)
		
		-- insert invoice line
		exec @RetVal = sptInvoiceLineInsert
					  @NewInvoiceKey				-- Invoice Key
					  ,@ProjectKey					-- ProjectKey
					  ,NULL							-- TaskKey
					  ,@LineSubject					-- Line Subject
					  ,NULL    						-- Line description
					  ,2               				-- Bill From 
					  ,0							-- Quantity
					  ,0							-- Unit Amount
					  ,@BillAmount					-- Line Amount
					  ,2							-- line type
					  ,0							-- parent line key
					  ,@DefaultSalesAccountKey		-- Default Sales AccountKey
					  ,@DefaultClassKey				-- Class Key
					  ,0							-- Taxable
					  ,0							-- Taxable2
					  ,@WorkTypeKey					-- Work TypeKey
   					  ,@PostSalesUsingDetail
					  ,NULL							-- Entity
					  ,NULL							-- EntityKey
					  ,NULL							-- OfficeKey
					  ,NULL							-- DepartmentKey						  						  
					  ,@NewInvoiceLineKey output
		
		if @@ERROR <> 0 
			begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -17					   	
			end			           	
		if @RetVal <> 1 
			begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -17					   	
			end
				  
		select @NewInvoiceLineKey = @NewInvoiceLineKey
		
		update #projecttype	set InvoiceLineKey = @NewInvoiceLineKey where ProjectKey = @ProjectKey
		
	end	 

	-- Second loop
	select @ProjectTypeName = ''
	while (1=1)
	begin	
		select @ProjectTypeName = MIN(ProjectTypeName)
		from #projecttype
		where ProjectTypeName > @ProjectTypeName
		
		if @ProjectTypeName is null
			break
			
		-- insert invoice line for the project type
		exec @RetVal = sptInvoiceLineInsert
						@NewInvoiceKey				-- Invoice Key
						,NULL						-- ProjectKey 
						,NULL						-- TaskKey
						,@ProjectTypeName			-- Line Subject
						,NULL                 		-- Line description
						,0		      				-- Bill From 
						,0							-- Quantity
						,0							-- Unit Amount
						,0							-- Line Amount
						,1							-- line type = Summary
						,0							-- parent line key
						,@DefaultSalesAccountKey	-- Default Sales AccountKey
						,@DefaultClassKey           -- Class Key
						,0							-- Taxable
						,0							-- Taxable2
						,@WorkTypeKey				-- Work TypeKey
						,@PostSalesUsingDetail
						,NULL							-- Entity
						,NULL							-- EntityKey
						,NULL							-- OfficeKey
						,NULL							-- DepartmentKey
						,@ParentInvoiceLineKey output
		
		if @@ERROR <> 0 
			begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -17					   	
			end			           	
		if @RetVal <> 1 
			begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -17					   	
			end
							  
		select @ProjectNumber = ''	
		while (1=1)
		begin	
			select @ProjectNumber = MIN(ProjectNumber)
			from #projecttype
			where ProjectNumber > @ProjectNumber
			and   ProjectTypeName = @ProjectTypeName
			
			if @ProjectNumber is null
				break

			select @ProjectKey = ProjectKey
				,@ProjectName = ProjectName
				,@BillAmount = BillAmount
			from   #projecttype
			where  ProjectNumber = @ProjectNumber

			select @LineSubject = left(@ProjectNumber + ' ' + @ProjectName, 100)
			  	
			-- insert invoice line
			exec @RetVal = sptInvoiceLineInsert
						@NewInvoiceKey					-- Invoice Key
						,@ProjectKey					-- ProjectKey
						,NULL							-- TaskKey
						,@LineSubject					-- Line Subject
						,NULL    						-- Line description
						,2               				-- Bill From 
						,0								-- Quantity
						,0								-- Unit Amount
						,@BillAmount					-- Line Amount
						,2								-- line type
						,@ParentInvoiceLineKey			-- parent line key
						,@DefaultSalesAccountKey		-- Default Sales AccountKey
						,@DefaultClassKey				-- Class Key
						,0								-- Taxable
						,0								-- Taxable2
						,@WorkTypeKey					-- Work TypeKey
   						,@PostSalesUsingDetail
						,NULL							-- Entity
						,NULL							-- EntityKey
						,NULL							-- OfficeKey
						,NULL							-- DepartmentKey						  						  
						,@NewInvoiceLineKey output
			
			if @@ERROR <> 0 
				begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -17					   	
				end			           	
			if @RetVal <> 1 
				begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -17					   	
				end
				
				update #projecttype	set InvoiceLineKey = @NewInvoiceLineKey where ProjectKey = @ProjectKey
			
		end	 
	
	end	 
	
	-- Labor
	update tTime
	set InvoiceLineKey = b.InvoiceLineKey
		,BilledService = tTime.ServiceKey
		,BilledHours = tTime.ActualHours
		,BilledRate = tTime.ActualRate
	from #tProcWIPKeys a, #projecttype b 
	where a.EntityType = 'Time'
	and tTime.TimeKey = cast(a.EntityKey as uniqueidentifier)					  
	and a.ProjectKey = b.ProjectKey
	
	if @@ERROR <> 0 
	begin
		exec sptInvoiceDelete @NewInvoiceKey
		return -8					   	
	end

	-- expense receipts
	update tExpenseReceipt
		set InvoiceLineKey = b.InvoiceLineKey
			,AmountBilled = BillableCost
		from #tProcWIPKeys a, #projecttype b 
		where a.EntityType = 'Expense'
		and tExpenseReceipt.ExpenseReceiptKey = cast(a.EntityKey as integer)
		and a.ProjectKey = b.ProjectKey

	if @@ERROR <> 0 
		begin
		exec sptInvoiceDelete @NewInvoiceKey
		return -8					   	
		end

	--misc expenses
	update tMiscCost
		set InvoiceLineKey = b.InvoiceLineKey
			,AmountBilled = BillableCost
		from #tProcWIPKeys a, #projecttype b 
		where a.EntityType = 'MiscExpense'
		and tMiscCost.MiscCostKey = cast(a.EntityKey as integer)
		and a.ProjectKey = b.ProjectKey

	if @@ERROR <> 0 
		begin
		exec sptInvoiceDelete @NewInvoiceKey
		return -9					   	
		end
		
	--voucher	   
	update tVoucherDetail
		set InvoiceLineKey = b.InvoiceLineKey
			,AmountBilled = BillableCost
		from #tProcWIPKeys a, #projecttype b 
		where a.EntityType = 'Voucher'
		and tVoucherDetail.VoucherDetailKey = cast(a.EntityKey as integer)
		and a.ProjectKey = b.ProjectKey

	if @@ERROR <> 0 
		begin
		exec sptInvoiceDelete @NewInvoiceKey
		return -10				   	
		end		
		
	--Order	   
	update tPurchaseOrderDetail
		set InvoiceLineKey = b.InvoiceLineKey
		,tPurchaseOrderDetail.AccruedCost = 
			CASE 
				WHEN po.BillAt < 2 THEN ROUND(tPurchaseOrderDetail.TotalCost * isnull(po.ExchangeRate, 1), 2)
				ELSE 0
			END
			,AmountBilled = isnull(Case ISNULL(po.BillAt, 0) 
			When 0 then isnull(BillableCost,0)
			When 1 then isnull(PTotalCost,isnull(TotalCost,0))
			When 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ,0)
		from #tProcWIPKeys a, #projecttype b, tPurchaseOrder po (nolock)
		where a.EntityType = 'Order'
		and tPurchaseOrderDetail.PurchaseOrderDetailKey = cast(a.EntityKey as integer)
		and po.PurchaseOrderKey = tPurchaseOrderDetail.PurchaseOrderKey
		and a.ProjectKey = b.ProjectKey

	if @@ERROR <> 0 
		begin
		exec sptInvoiceDelete @NewInvoiceKey
		return -10				   	
		end

				  
	RETURN 1
GO
