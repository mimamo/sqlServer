USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingInvoiceOneLinePerTaskFF]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingInvoiceOneLinePerTaskFF]
	(
		@CompanyKey INT
		,@NewInvoiceKey INT
		,@BillingKey INT
		,@BillingMethod INT
		,@ProjectKey INT
		,@DefaultSalesAccountKey int
		,@DefaultClassKey int
		,@DefaultWorkTypeKey int		
		,@ParentInvoiceLineKey int
		,@EstimateKey int
	)
AS -- Encrypt

  /*
  || When     Who Rel   What
  || 07/28/06 GHL 8.4   Added TrackBudget in task temp tables
  || 07/09/07 GHL 8.5	Added logic for office/department  
  || 10/13/08 GHL 10.010 (37465) If tTask.ShowDescOnEst = 1 bring over task description
  || 11/05/08 GHL 10.012 (39611) Rolled back change for 37465 
  || 07/15/09 GHL 10.505 (56484) Added support of the [No Task] line
  || 10/28/10 GHL 10.537 Put back description at KN's request
  || 12/17/10 GHL 10.539 (97621) Removed amount recalcs to improve performance 
  */

	SET NOCOUNT ON

	-- Similar to sptInvoiceLineProjectInsert used in original FF screen
	
	DECLARE @BillingFixedFeeKey INT
	       ,@Entity VARCHAR(50)
		   ,@EntityKey INT
		   ,@Percentage DECIMAL(24, 4)
	       ,@Amount MONEY
	       ,@Taxable1 INT
	       ,@Taxable2 INT
	       ,@SalesAccountKey INT
	       ,@LineSubject VARCHAR(100)
	       ,@WorkTypeKey INT
		   ,@RetVal INT
		   ,@NewInvoiceLineKey INT
		   ,@OfficeKey INT
		   ,@DepartmentKey INT

-- Added for tasks
declare @NextRootTaskKey int
declare @NextRootDisplayOrder int
declare @TaskName varchar(100)
declare @Description varchar(4000)
declare @TaskType smallint
declare @BillFrom smallint
declare @NextInvoiceDisplayOrder int
Declare @TrackBudget int
Declare @LineType int
		   			   		
	TRUNCATE TABLE #tInvcTask
	TRUNCATE TABLE #tInvcRootTask

	  insert #tInvcTask
		select w.EntityKey
	    	  ,0 -- ta.SummaryTaskKey
		      ,2 -- ta.TaskType
		      ,-1 -- ta.DisplayOrder
		      ,0 --isnull(ta.Taxable, 0)
		      ,0 --isnull(ta.Taxable2, 0)
		      ,0 --ta.WorkTypeKey
		      ,1 --ta.TrackBudget
		      ,'No Task' -- ta.TaskName
		      ,null -- description
		  from tBillingFixedFee w
		 where w.BillingKey = @BillingKey
		   and w.Entity = 'tTask'
		   and w.EntityKey = 0
			
		--get labor
	  insert #tInvcTask
		select distinct ta.TaskKey
	    	  ,ta.SummaryTaskKey
		      ,ta.TaskType
		      ,ta.DisplayOrder
		      ,isnull(ta.Taxable, 0)
		      ,isnull(ta.Taxable2, 0)
		      ,ta.WorkTypeKey
		      ,ta.TrackBudget
		      ,ta.TaskName
		      ,case when isnull(ta.ShowDescOnEst, 0) = 0 then null
		            else ta.Description  
		      end
		  from tBillingFixedFee w
		      ,tTask ta (nolock)
		 where w.BillingKey = @BillingKey
		   and w.Entity = 'tTask'
		   and w.EntityKey = ta.TaskKey
		   and ta.TaskKey not in (select TaskKey from #tInvcTask)
		      
		if @@ERROR <> 0 
		  begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -11				   	
		  end

			--recursively fill in the missing summary nodes
		exec spCreateInvoiceTree
		if @@ERROR <> 0 
		  begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -15				   	
		  end
		  
		--order the root level nodes
		insert #tInvcRootTask
		select *
		  from #tInvcTask		
		 where #tInvcTask.SummaryTaskKey = 0
		if @@ERROR <> 0 
		  begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -16				   	
		  end

		select @NextInvoiceDisplayOrder = 0
	
		SELECT @OfficeKey = OfficeKey
		FROM   tBilling (NOLOCK)
		WHERE  BillingKey = @BillingKey  	
	
		--loop through root tasks in order
		select @NextRootDisplayOrder = -2
		while (1=1)
		  begin
			select @NextRootDisplayOrder = min(DisplayOrder)
			  from #tInvcRootTask
		     where DisplayOrder > @NextRootDisplayOrder
			if @NextRootDisplayOrder is null
				break
				
	    	select @NextRootTaskKey = TaskKey
			      ,@TaskName = isnull(left(TaskName,100),'No Task Name')
			      ,@Description = left(Description, 4000)
			      ,@TaskType = TaskType
				  ,@WorkTypeKey = WorkTypeKey
				  ,@TrackBudget = TrackBudget
			  from #tInvcRootTask
		     where DisplayOrder = @NextRootDisplayOrder
			
			select @SalesAccountKey =  null
			
			if isnull(@WorkTypeKey, 0) > 0 
				Select @SalesAccountKey = GLAccountKey 
				from tWorkType (nolock) 
				Where WorkTypeKey = @WorkTypeKey
						
			if isnull(@SalesAccountKey, 0) = 0
				Select @SalesAccountKey = @DefaultSalesAccountKey
			
			/*
			BillFrom = 0 Summary
			BillFrom = 1 No Transactions (Amounts are entered directly)
			BillFrom = 2 Use Transactions
			
			LineType = 1 Summary
			LineType = 2 Detail		 
			*/
			
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
			
			--create single invoice line
			exec @RetVal = sptInvoiceLineInsertMassBilling
						   @NewInvoiceKey				-- Invoice Key
						 ,@ProjectKey					-- ProjectKey
						  ,@NextRootTaskKey				-- TaskKey
						  ,@TaskName					-- Line Subject
						  ,@Description                 -- Line description
						  ,@BillFrom      				-- Bill From 
						  ,1							-- Quantity
						  ,@Amount						-- Unit Amount
						  ,@Amount						-- Line Amount
						  ,@LineType					-- line type
						  ,@ParentInvoiceLineKey		-- parent line key
						  ,@SalesAccountKey				-- Default Sales AccountKey
						  ,@DefaultClassKey             -- Class Key
						  ,@Taxable1					-- Taxable
						  ,@Taxable2					-- Taxable2
						  ,@WorkTypeKey					-- Work TypeKey
						  ,0 -- @PostSalesUsingDetail==> No do it like sptInvoiceLineProjectInsert used for FF
						  ,NULL							-- Entity
						  ,NULL							-- EntityKey
						  ,@OfficeKey
						  ,@DepartmentKey
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

 			IF ISNULL(@EstimateKey, 0) > 0
 				UPDATE tInvoiceLine
 				SET    EstimateKey = @EstimateKey
 				WHERE  InvoiceLineKey = @NewInvoiceLineKey
			
			--exec sptInvoiceRecalcAmounts @NewInvoiceKey 

			 
			if @LineType = 1  --only summary lines
			  begin
				--recursively create subordinate lines
				exec @RetVal = spBillingInvoiceTaskLineTreeFF 
										 @NextRootTaskKey
										,@NewInvoiceKey
										,@BillingKey
			                            ,@ProjectKey
										,@DefaultSalesAccountKey
			                            ,@DefaultClassKey
			                            ,@NewInvoiceLineKey
			                            ,@EstimateKey
			                          
				if @RetVal <> 1 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -23					   	
				  end
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -24					   	
				  end	
			end --end of recursive call		                            
				
		end --end of root task loop
	
	
	
	RETURN 1
GO
