USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLUnPostWIP]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGLUnPostWIP]
(
   @WIPPostingKey int
   ,@UserKey int = null
)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 11/09/09 GHL 10.513 Added unposting history 
  || 12/01/09 GHL 10.514 Added update and use of WIPAmount on the actual transactions
  || 11/05/10 GHL 10.537 Added resetting of OldWIPAmount
  || 07/03/12 GHL 10.557 Added tTransaction.ICTGLCompanyKey
  ||                     Removed the #tTransaction  since we do not call spGLPostVoucher
  || 09/28/12 RLB 10.560  Add MultiCompanyGLClosingDate preference check
  || 12/30/13 GHL 10.575 Added Multi Currency to tTransactionUnpost
  */
  
			
Declare @GLClosedDate smalldatetime
Declare @PostingDate smalldatetime
Declare @CompanyKey int
Declare @WIPVoucherAssetAccountKey int
Declare @WIPExpenseAssetAccountKey int
Declare	@WIPMediaAssetAccountKey int
Declare @TrackWIP int
Declare @SelectThroughDate smalldatetime
Declare @GLCompanyKey int
Declare @ReferenceNumber varchar(100)
Declare @Description varchar(500)
Declare @Error int
Declare @UseMultiCompanyGLCloseDate tinyint
		
	Select 
		  @GLClosedDate = p.GLClosedDate	
		, @PostingDate = wp.PostingDate
		, @WIPVoucherAssetAccountKey = ISNULL(p.WIPVoucherAssetAccountKey, 0)
		, @WIPExpenseAssetAccountKey = ISNULL(p.WIPExpenseAssetAccountKey, 0)
		, @WIPMediaAssetAccountKey = ISNULL(p.WIPMediaAssetAccountKey, 0)
		, @TrackWIP = ISNULL(p.TrackWIP, 0)
		, @CompanyKey = wp.CompanyKey 
		, @GLCompanyKey = wp.GLCompanyKey
		, @ReferenceNumber = null
		, @Description = wp.Comment
		, @SelectThroughDate = wp.SelectThroughDate 
		, @UseMultiCompanyGLCloseDate = ISNULL(p.MultiCompanyClosingDate, 0)
	From
		tWIPPosting wp (nolock) 
		inner join tPreference p (nolock) on wp.CompanyKey = p.CompanyKey
	Where
		wp.WIPPostingKey = @WIPPostingKey
	
	if @UseMultiCompanyGLCloseDate = 1 And ISNULL(@GLCompanyKey, 0) > 0
	BEGIN
		Select 
			@GLClosedDate = GLCloseDate
		From 
			tGLCompany (nolock)
		Where
			GLCompanyKey = @GLCompanyKey			
	END
		
	If not @GLClosedDate is null
		if @GLClosedDate > @PostingDate
			return -1
			
	if exists(Select 1 from tTransaction (nolock) Where Entity = 'WIP' and EntityKey = @WIPPostingKey and Cleared = 1)
		return -2

Begin Transaction

If isnull(@UserKey, 0) > 0
begin 
	declare @UnpostLogKey int
	
	Insert tTransactionUnpostLog (CompanyKey, Entity, EntityKey, EntityDate, PostingDate
       ,UnpostedBy, DateUnposted, ClientKey, VendorKey, GLCompanyKey, ReferenceNumber, Description)
	Select @CompanyKey, 'WIP', @WIPPostingKey, @SelectThroughDate, @PostingDate
	   ,@UserKey, getutcdate(), null, null, @GLCompanyKey, @ReferenceNumber, @Description
	   
	select @Error = @@ERROR, @UnpostLogKey = @@IDENTITY
	
	if @Error <> 0 
	begin
		rollback transaction 
		return -3
	end
		    
	Insert tTransactionUnpost(UnpostLogKey,TransactionKey,CompanyKey,DateCreated,TransactionDate
	       ,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,Memo,PostMonth,PostYear
	       ,Reversed,PostSide,ClientKey,ProjectKey,SourceCompanyKey,Cleared,DepositKey,GLCompanyKey
           ,OfficeKey,DepartmentKey,DetailLineKey,Section,Overhead,ICTGLCompanyKey,CurrencyID,ExchangeRate,HDebit,HCredit)
    Select @UnpostLogKey,TransactionKey,CompanyKey,DateCreated,TransactionDate
	       ,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,Memo,PostMonth,PostYear
	       ,Reversed,PostSide,ClientKey,ProjectKey,SourceCompanyKey,Cleared,DepositKey,GLCompanyKey
           ,OfficeKey,DepartmentKey,DetailLineKey,Section,Overhead,ICTGLCompanyKey,CurrencyID,ExchangeRate,HDebit,HCredit
    From tTransaction (nolock) 
    Where Entity = 'WIP' and EntityKey = @WIPPostingKey

	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -3
	end
                               
end

	Delete from tTransaction
	Where Entity = 'WIP' and EntityKey = @WIPPostingKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -3
	end

	Delete from tWIPPostingDetail
	Where WIPPostingKey = @WIPPostingKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -3
	end

	Delete from tWIPPosting
	Where WIPPostingKey = @WIPPostingKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -3
	end

	Update tTime 
	Set    WIPPostingInKey = 0
	      ,WIPAmount = 0
	Where WIPPostingInKey = @WIPPostingKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end
	
	Update tTime 
	Set WIPPostingOutKey = 0
	Where WIPPostingOutKey = @WIPPostingKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end

	Update tExpenseReceipt 
	Set    WIPPostingInKey = -1    -- clearly mark the old exp receipts
	      ,WIPAmount = 0
	Where WIPPostingInKey = @WIPPostingKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end
	
	Update tExpenseReceipt 
	Set WIPPostingOutKey = 0
	Where WIPPostingOutKey = @WIPPostingKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end

	Update tMiscCost 
	Set    WIPPostingInKey = 0
	      ,WIPAmount = 0
		  ,OldWIPAmount = null -- should be null, not 0 because we use it as isnull(OldWIPAmount, WIPAmount)
	Where WIPPostingInKey = @WIPPostingKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end
	
	Update tMiscCost 
	Set WIPPostingOutKey = 0
	Where WIPPostingOutKey = @WIPPostingKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end

	Update tVoucherDetail 
	Set    WIPPostingInKey = 0
	      ,WIPAmount = 0
		  ,OldWIPAmount = null -- should be null, not 0 because we use it as isnull(OldWIPAmount, WIPAmount)
	Where WIPPostingInKey = @WIPPostingKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end


	-- This would set it to post in again, but if it was posted to wip account, you need to change the gl account on the line.
	-- find all vendor invoices with lines w wi key <= 0 and update the lines with a wip gl account to the item account and repost the voucher.
	
	declare @VoucherKey int
	declare @VoucherDetailKey int
	declare @NewExpenseAccountKey int
	declare @Posted int
	
	/*
	select @VoucherKey = -1
	While 1=1
	begin
			-- find vouchers with lines that have -1 for in key and expense account = wip asset account (any one of the three) and have this batch as the wokey
			-- change the expense account on the lines where the wip asset account is specified to the expense account for the item. 
			-- force unpost/repost of the voucher
			-- set wip in and out key = 0 for that voucher

		select @VoucherKey = Min(v.VoucherKey) 
		from tVoucher v (nolock)
			inner join tVoucherDetail vd (nolock) on vd.VoucherKey = v.VoucherKey 
		Where v.VoucherKey > @VoucherKey
		And   v.CompanyKey = @CompanyKey
		And   vd.WIPPostingInKey = -1
		And   vd.ExpenseAccountKey IN (@WIPVoucherAssetAccountKey, @WIPExpenseAssetAccountKey,
										@WIPMediaAssetAccountKey)
		And WIPPostingOutKey = @WIPPostingKey ---????
					
		If @VoucherKey IS NULL
			BREAK
			
		select @Posted = Posted
		from tVoucher (NOLOCK)
		where VoucherKey = @VoucherKey 								
										
		select @VoucherDetailKey = -1
		while (1=1)
		begin
			select @VoucherDetailKey = min(VoucherDetailKey)
			from tVoucherDetail (nolock)
			where VoucherKey = @VoucherKey 
			and  VoucherDetailKey > @VoucherDetailKey 
			And   WIPPostingInKey = -1
			And   ExpenseAccountKey IN (@WIPVoucherAssetAccountKey, @WIPExpenseAssetAccountKey,
											@WIPMediaAssetAccountKey)
			And WIPPostingOutKey = @WIPPostingKey ---????
			
			IF @VoucherDetailKey IS NULL
				BREAK
				
			select @NewExpenseAccountKey = i.ExpenseAccountKey 
			from   tItem i (NOLOCK)
				inner join tVoucherDetail vd (NOLOCK) ON vd.ItemKey = i.ItemKey
			where  vd.VoucherDetailKey = @VoucherDetailKey	
				
			update tVoucherDetail set WIPPostingInKey = 0, ExpenseAccountKey = @NewExpenseAccountKey
			where VoucherDetailKey = @VoucherDetailKey
		end								
		 
		If @Posted = 1
		begin
			exec spGLUnPostVoucher @VoucherKey, 0   -- do not check closed date
			
			-- no prepost, do not create temp table because we are in sql tran, do not check closed date
			TRUNCATE TABLE #tTransaction
			exec spGLPostVoucher @CompanyKey,@VoucherKey , 0, 0, 0
			
		end
		
	end 
	
	-- Not necessary
	Update tVoucherDetail	
	Set WIPPostingInKey = 0
	from tVoucher (NOLOCK)
	Where WIPPostingOutKey = @WIPPostingKey
	and tVoucher.VoucherKey = tVoucherDetail.VoucherKey
	and tVoucher.Posted = 1
	and tVoucherDetail.WIPPostingInKey = -1
	*/
	
	Update tVoucherDetail 
	Set WIPPostingOutKey = 0
	Where WIPPostingOutKey = @WIPPostingKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end
	


commit Transaction
GO
