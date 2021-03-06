USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingInvoiceTaskLineTreeFF]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spBillingInvoiceTaskLineTreeFF]
	 @SummaryTaskKey int
	,@NewInvoiceKey int
	,@BillingKey int
	,@ProjectKey int
	,@DefaultSalesAccountKey int
	,@DefaultClassKey int
	,@ParentLineKey int
	,@EstimateKey int
	
AS --Encrypt

   /*
  || When     Who Rel   What
  || 07/31/06 GHL 8.4   Added use of TrackBudget
  || 07/09/07 GHL 8.5	Added logic for office/department  
  || 10/13/08 GHL 10.010 (37465) If tTask.ShowDescOnEst = 1 bring over task description
  || 11/05/08 GHL 10.012 (39611) Rolled back change for 37465     
  || 10/28/10 GHL 10.537 Put back description at KN's request    
  */
declare @NbrOfChildren int
declare @NewInvoiceLineKey int
declare @CompanyKey int	
declare @ClientKey int
declare @BillingContactKey int 
declare @RetVal int
declare @TodaysDate smalldatetime
declare @ProjectName varchar(100)
declare @TotHours decimal(9,3)
declare @TotLabor money
declare @TotExpenseRcpt money
declare @TotMiscExpense money
declare @TotVoucher money
declare @TotPO money
declare @TotExpense money
declare @NextRootTaskKey int
declare @NextRootDisplayOrder int
declare @NextRootTaskType smallint
declare @NextRootSummaryTaskKey int
declare @TaskName varchar(100)
declare @Description varchar(4000)
declare @TaskType smallint
declare @Taxable1 tinyint, @Taxable2 tinyint 
declare @WorkTypeKey int
declare @BillFrom smallint
declare @NextInvoiceDisplayOrder int
declare @SalesGLAccountKey int
declare @Amount money
declare @LineType int
declare @TrackBudget int
declare @OfficeKey int
declare @DepartmentKey int

	select @NbrOfChildren = isnull(count(*),0)
	  from #tInvcTask
	 where SummaryTaskKey = @SummaryTaskKey
	if @NbrOfChildren = 0 
		return 1
	
	SELECT @OfficeKey = OfficeKey
	FROM   tBilling (NOLOCK)
	WHERE  BillingKey = @BillingKey  	
	
	select @NextInvoiceDisplayOrder = 0
		
	--loop through tasks in order
	select @NextRootDisplayOrder = -1
	while (1=1)
	  begin
		select @NextRootDisplayOrder = min(DisplayOrder)
		  from #tInvcTask
		 where DisplayOrder > @NextRootDisplayOrder
		   and SummaryTaskKey = @SummaryTaskKey
		if @NextRootDisplayOrder is null
			break
				
	    select @NextRootTaskKey = TaskKey
		      ,@TaskName = left(TaskName,100)
		      ,@Description = left(Description, 4000)
		      ,@TaskType = TaskType
		      ,@WorkTypeKey = WorkTypeKey
		      ,@TrackBudget = TrackBudget
		  from #tInvcTask
		 where DisplayOrder = @NextRootDisplayOrder
		   and SummaryTaskKey = @SummaryTaskKey
		     		  
		select @SalesGLAccountKey =  null
			
		if isnull(@WorkTypeKey, 0) > 0 
			Select @SalesGLAccountKey = GLAccountKey 
			from tWorkType (nolock) 
			Where WorkTypeKey = @WorkTypeKey
						
		if isnull(@SalesGLAccountKey, 0) = 0
			Select @SalesGLAccountKey = @DefaultSalesAccountKey
					 
		--if @TaskType = 1
		if @TrackBudget = 0
			BEGIN
				-- Summary Task
				SELECT @BillFrom = 0
					  ,@LineType = 1
					  ,@Amount = 0
				      ,@Taxable1 = 0
				      ,@Taxable2 = 0
			END
			ELSE
			BEGIN
				-- Detail Task
				SELECT @BillFrom = 1
					  ,@LineType = 2
						
				-- Reset variables because we are in a loop
				SELECT @Amount = NULL
					  ,@Taxable1 = NULL 	
					  ,@Taxable2 = NULL 	

				SELECT @Amount = Amount
					   ,@Taxable1 = Taxable1
					   ,@Taxable2 = Taxable2	
					   ,@DepartmentKey = DepartmentKey				   
				FROM tBillingFixedFee (NOLOCK)
				WHERE  BillingKey = @BillingKey
				AND    Entity = 'tTask'
				AND    EntityKey = @NextRootTaskKey

				SELECT @Amount = ISNULL(@Amount, 0)
					  ,@Taxable1 = ISNULL(@Taxable1, 0) 	
					  ,@Taxable2 = ISNULL(@Taxable2, 0) 	
			END

			 
		exec @RetVal = sptInvoiceLineInsertMassBilling
					   @NewInvoiceKey				-- Invoice Key
					  ,@ProjectKey					-- ProjectKey
					  ,@NextRootTaskKey				-- Task Key
					  ,@TaskName					-- Line Subject
					  ,@Description                 -- Line description
					  ,@BillFrom               		-- Bill From 
					  ,1							-- Quantity
					  ,@Amount						-- Unit Amount
					  ,@Amount						-- Line Amount
					  ,@LineType					-- line type
					  ,@ParentLineKey				-- parent line key
					  ,@SalesGLAccountKey			-- Default Sales AccountKey
					  ,@DefaultClassKey             -- Class Key
					  ,@Taxable1					-- Taxable
					  ,@Taxable2					-- Taxable2
					  ,@WorkTypeKey					-- Work TypeKey
					  ,0							--@PostSalesUsingDetail
					  ,NULL							-- Entity
					  ,NULL							-- EntityKey
					  ,@OfficeKey
					  ,@DepartmentKey
					  ,@NewInvoiceLineKey output

		  if @@ERROR <> 0 
		  begin
			return -17					   	
		  end		
		  if @RetVal <> 1 
		  begin
			return -17					   	
		  end
	           		     		  
			IF ISNULL(@EstimateKey, 0) > 0
 				UPDATE tInvoiceLine
 				SET    EstimateKey = @EstimateKey
 				WHERE  InvoiceLineKey = @NewInvoiceLineKey
		
		if @LineType = 1  --only summary lines
		  begin
			--recursively create subordinate lines
			exec spBillingInvoiceTaskLineTreeFF @NextRootTaskKey
			                            ,@NewInvoiceKey
			                            ,@BillingKey
			                            ,@ProjectKey
			                            ,@DefaultSalesAccountKey
										,@DefaultClassKey
										,@NewInvoiceLineKey
										,@EstimateKey
													        
			  if @@ERROR <> 0 
			  begin
				return -24					   	
			  end	
			  if @RetVal <> 1 
			  begin
				return -23					   	
			  end

		end --end of recursive sub task call		                    
				
	end --end of root task loop
		  
	                       
	return 1
GO
