USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRecurTranDelete]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRecurTranDelete]
	(
	@RecurTranKey int
	)

AS
 /*
  || When     Who Rel      What
  || 03/22/11 RLB 10.5.4.2 (106294) removing recurring parent key before deleting 
  || 11/03/11 GHL 10.549   Added support of credit cards      
  || 11/20/12 GHL 10.562 Added update of revenue forecast                      
  */


DECLARE @Entity varchar(50), @EntityKey int

Select @Entity = Entity, @EntityKey = EntityKey from tRecurTran (nolock) where RecurTranKey = @RecurTranKey

if @Entity IN ('VOUCHER', 'CREDITCARD')
	update tVoucher set RecurringParentKey = 0 where RecurringParentKey = @EntityKey

if @Entity = 'INVOICE'
	update tInvoice set RecurringParentKey = 0 where RecurringParentKey = @EntityKey

if @Entity = 'PAYMENT'
	update tPayment set RecurringParentKey = 0 where RecurringParentKey = @EntityKey

if @Entity = 'RECEIPT'
	update tCheck set RecurringParentKey = 0 where RecurringParentKey = @EntityKey

if @Entity = 'GENJRNL'
	update tJournalEntry set RecurringParentKey = 0 where RecurringParentKey = @EntityKey

if @Entity = 'INVOICE'
	begin
		update tForecastDetail
		set    RegenerateNeeded = 1
		where  Entity = 'tInvoice'
		and    EntityKey = @EntityKey
	end

Delete tRecurTranUser Where RecurTranKey = @RecurTranKey
Delete tRecurTran Where RecurTranKey = @RecurTranKey
GO
