USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRecurTranUpdateMasterTransaction]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRecurTranUpdateMasterTransaction]
	(
	@RecurTranKey int
	,@NewMasterTransactionKey int
	)
AS --Encrypt
 
 /*
  || When     Who Rel    What
  || 06/21/11 GHL 10.545 (114333) Creation so that we can change the master transaction on a recurring tran
  ||                     this way it is possible to change things before generating new recurrences   
  || 11/03/11 GHL 10.549  Added support of Credit Cards                     
  */

	SET NOCOUNT ON 
	
	if isnull(@NewMasterTransactionKey, 0) <= 0
		return -1 

	declare @CompanyKey int
	declare @Entity varchar(50)
	declare @OldMasterTransactionKey int

	select @CompanyKey = CompanyKey
		  ,@Entity = Entity
		  ,@OldMasterTransactionKey = EntityKey
	from   tRecurTran (nolock)
	where  RecurTranKey = @RecurTranKey

	update tRecurTran
	set    EntityKey = @NewMasterTransactionKey
	where  RecurTranKey = @RecurTranKey

	if isnull(@OldMasterTransactionKey, 0) <= 0
		return -1 

	if @Entity = 'GENJRNL'
		update tJournalEntry
		set    RecurringParentKey = @NewMasterTransactionKey
		where  CompanyKey = @CompanyKey
		and    RecurringParentKey = @OldMasterTransactionKey

	else if @Entity = 'INVOICE'
		update tInvoice
		set    RecurringParentKey = @NewMasterTransactionKey
		where  CompanyKey = @CompanyKey
		and    RecurringParentKey = @OldMasterTransactionKey

	else if @Entity IN ('VOUCHER', 'CREDITCARD')
		update tVoucher
		set    RecurringParentKey = @NewMasterTransactionKey
		where  CompanyKey = @CompanyKey
		and    RecurringParentKey = @OldMasterTransactionKey

	else if @Entity = 'PAYMENT'
		update tPayment
		set    RecurringParentKey = @NewMasterTransactionKey
		where  CompanyKey = @CompanyKey
		and    RecurringParentKey = @OldMasterTransactionKey

	else if @Entity = 'RECEIPT'
		update tCheck
		set    RecurringParentKey = @NewMasterTransactionKey
		where  CompanyKey = @CompanyKey
		and    RecurringParentKey = @OldMasterTransactionKey
	
	RETURN 1
GO
