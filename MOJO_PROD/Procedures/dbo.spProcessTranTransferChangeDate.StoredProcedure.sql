USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessTranTransferChangeDate]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessTranTransferChangeDate]
	(
	@Entity varchar(50)
	,@EntityKey int      -- Assume that this is the initial key
	,@UIDEntityKey uniqueidentifier
	,@NewDate datetime
	)
AS --Encrypt
	
	SET NOCOUNT ON
	
  /*
  || When     Who Rel     What
  || 03/12/10 GHL 10.519 (75325) Creation to allow users to change the transfer date 
  || 03/19/10 GHL 10.520  Added change of GL transaction date if the voucher is posted
  || 10/13/11 GHL 10.459  Added new entity CREDITCARD
  */
	
	/*       Key   TransferFromKey  TransferToKey   TransferInDate   TransferOutDate  DateBilled
    initial   A         NULL            C              NULL             01/1/2100      01/1/2100
    Reversal  B          A              C             01/1/2100         01/1/2100      01/1/2100
    New       C          A              NULL          01/1/2100         NULL           NULL 
	*/
	
	
	declare @ProjectKey int 
	declare @ReversalKey int
	declare @TransferToKey int
	declare @UIDReversalKey uniqueidentifier
	declare @UIDTransferToKey uniqueidentifier
	declare @Posted int
	declare @VoucherKey int
	declare @TransactionKey int
		
	if @Entity = 'tMiscCost'
	begin
		select @ProjectKey = ProjectKey
		      ,@TransferToKey = TransferToKey
		from   tMiscCost (nolock)
		where  MiscCostKey = @EntityKey 	
	
		-- if not transferred, abort
		if @TransferToKey is null
			return 1
			
		select @ReversalKey = MiscCostKey
		from   tMiscCost (nolock)
		where  ProjectKey = @ProjectKey -- use indexes on ProjectKey
		and    TransferFromKey = @EntityKey	
	    and    TransferToKey = @TransferToKey
	    
	    update tMiscCost
	    set    DateBilled = @NewDate
	          ,TransferOutDate = @NewDate
	    where  MiscCostKey = @EntityKey      
	    
	    update tMiscCost
	    set    DateBilled = @NewDate
			  ,TransferInDate = @NewDate	
	          ,TransferOutDate = @NewDate
	    where  MiscCostKey = @ReversalKey      

	    update tMiscCost
	    set    TransferInDate = @NewDate	
	    where  MiscCostKey = @TransferToKey      
	    
	end
	
	if @Entity = 'tExpenseReceipt'
	begin
		select @ProjectKey = ProjectKey
		      ,@TransferToKey = TransferToKey
		from   tExpenseReceipt (nolock)
		where  ExpenseReceiptKey = @EntityKey 	
	
		-- if not transferred, abort
		if @TransferToKey is null
			return 1
			
		select @ReversalKey = ExpenseReceiptKey
		from   tExpenseReceipt (nolock)
		where  ProjectKey = @ProjectKey -- use indexes on ProjectKey
		and    TransferFromKey = @EntityKey	
	    and    TransferToKey = @TransferToKey
	    
	    update tExpenseReceipt
	    set    DateBilled = @NewDate
	          ,TransferOutDate = @NewDate
	    where  ExpenseReceiptKey = @EntityKey      
	    
	    update tExpenseReceipt
	    set    DateBilled = @NewDate
			  ,TransferInDate = @NewDate	
	          ,TransferOutDate = @NewDate
	    where  ExpenseReceiptKey = @ReversalKey      

	    update tExpenseReceipt
	    set    TransferInDate = @NewDate	
	    where  ExpenseReceiptKey = @TransferToKey      
	    
	end

	if @Entity = 'tVoucherDetail'
	begin
		select @ProjectKey = vd.ProjectKey
		      ,@TransferToKey = vd.TransferToKey
		      ,@VoucherKey = vd.VoucherKey
		      ,@Posted = v.Posted
		from   tVoucherDetail vd (nolock)
			inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
		where  vd.VoucherDetailKey = @EntityKey 	
	
		-- if not transferred, abort
		if @TransferToKey is null
			return 1
			
		select @ReversalKey = VoucherDetailKey
		from   tVoucherDetail (nolock)
		where  ProjectKey = @ProjectKey -- use indexes on ProjectKey
		and    TransferFromKey = @EntityKey	
	    and    TransferToKey = @TransferToKey
	    
	    update tVoucherDetail
	    set    DateBilled = @NewDate
	          ,TransferOutDate = @NewDate
	    where  VoucherDetailKey = @EntityKey      
	    
	    update tVoucherDetail
	    set    DateBilled = @NewDate
			  ,TransferInDate = @NewDate	
	          ,TransferOutDate = @NewDate
	    where  VoucherDetailKey = @ReversalKey      

	    update tVoucherDetail
	    set    TransferInDate = @NewDate	
	    where  VoucherDetailKey = @TransferToKey      
	    
	    if @Posted = 1
	    begin
			-- now we must change the dates on the 2 GL transactions
			select @TransactionKey = TransactionKey
			from   tTransaction (nolock)
			where  Entity in ('VOUCHER', 'CREDITCARD')
			and    EntityKey = @VoucherKey 
			and    Section = 2
			and    DetailLineKey = @ReversalKey
		    
			if @TransactionKey is not null
				update tTransaction set TransactionDate = @NewDate where TransactionKey = @TransactionKey
				
			select @TransactionKey = null
				
			select @TransactionKey = TransactionKey
			from   tTransaction (nolock)
			where  Entity in ('VOUCHER', 'CREDITCARD')
			and    EntityKey = @VoucherKey 
			and    Section = 2
			and    DetailLineKey = @TransferToKey
		    
			if @TransactionKey is not null
				update tTransaction set TransactionDate = @NewDate where TransactionKey = @TransactionKey
				
		end
			
	end

	if @Entity = 'tPurchaseOrderDetail'
	begin
		select @ProjectKey = ProjectKey
		      ,@TransferToKey = TransferToKey
		from   tPurchaseOrderDetail (nolock)
		where  PurchaseOrderDetailKey = @EntityKey 	
	
		-- if not transferred, abort
		if @TransferToKey is null
			return 1
			
		select @ReversalKey = PurchaseOrderDetailKey
		from   tPurchaseOrderDetail (nolock)
		where  ProjectKey = @ProjectKey -- use indexes on ProjectKey
		and    TransferFromKey = @EntityKey	
	    and    TransferToKey = @TransferToKey
	    
	    update tPurchaseOrderDetail
	    set    DateBilled = @NewDate
	          ,TransferOutDate = @NewDate
	    where  PurchaseOrderDetailKey = @EntityKey      
	    
	    update tPurchaseOrderDetail
	    set    DateBilled = @NewDate
			  ,TransferInDate = @NewDate	
	          ,TransferOutDate = @NewDate
	    where  PurchaseOrderDetailKey = @ReversalKey      

	    update tPurchaseOrderDetail
	    set    TransferInDate = @NewDate	
	    where  PurchaseOrderDetailKey = @TransferToKey      
	    
	end


	if @Entity = 'tTime'
	begin
		select @ProjectKey = ProjectKey
		      ,@UIDTransferToKey = TransferToKey
		from   tTime (nolock)
		where  TimeKey = @UIDEntityKey 	
	
		-- if not transferred, abort
		if @UIDTransferToKey is null
			return 1
			
		select @UIDReversalKey = TimeKey
		from   tTime (nolock)
		where  ProjectKey = @ProjectKey -- use indexes on ProjectKey
		and    TransferFromKey = @UIDEntityKey	
	    and    TransferToKey = @UIDTransferToKey
	    
	    update tTime
	    set    DateBilled = @NewDate
	          ,TransferOutDate = @NewDate
	    where  TimeKey = @UIDEntityKey      
	    
	    update tTime
	    set    DateBilled = @NewDate
			  ,TransferInDate = @NewDate	
	          ,TransferOutDate = @NewDate
	    where  TimeKey = @UIDReversalKey      

	    update tTime
	    set    TransferInDate = @NewDate	
	    where  TimeKey = @UIDTransferToKey      
	    
	end
	
	RETURN
GO
