USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectUpdateMarkAllTransactionsBilled]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectUpdateMarkAllTransactionsBilled]
	@ProjectKey int,
	@BilledDate smalldatetime
 
AS --Encrypt

  /*
  || When     Who Rel      What
  || 09/19/12 RLB 10.560  (154539) Created for Enhancement
  */
  

If Exists(Select 1 from tTime t (nolock) inner join tTimeSheet ts (nolock) on t.TimeSheetKey = ts.TimeSheetKey Where t.ProjectKey = @ProjectKey and ts.Status < 4)
	return -306
If Exists(Select 1 from tExpenseReceipt er (nolock) inner join tExpenseEnvelope ee (nolock) on er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey Where er.ProjectKey = @ProjectKey and ee.Status < 4)
	return -307
If Exists(Select 1 from tVoucherDetail vd(nolock) inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey Where vd.ProjectKey = @ProjectKey and v.Status < 4)
	return -308


BEGIN TRAN

Update tTime Set InvoiceLineKey = 0, WriteOff = 0,  DateBilled = @BilledDate 
From 
	tTimeSheet (nolock)
Where  
	tTime.ProjectKey = @ProjectKey
	and tTimeSheet.Status = 4
	and tTime.InvoiceLineKey is null
	and tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
	and tTime.WriteOff = 0

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN -400
END	


Update tMiscCost Set InvoiceLineKey = 0, WriteOff = 0, DateBilled = @BilledDate 
from 
	tProject  (nolock)
Where
	tMiscCost.ProjectKey = @ProjectKey
	and tMiscCost.InvoiceLineKey is null
	and tMiscCost.ProjectKey = tProject.ProjectKey
	and tMiscCost.WriteOff = 0
	

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN -500
END	

Update tExpenseReceipt Set InvoiceLineKey = 0, WriteOff = 0, DateBilled = @BilledDate 
from 
	tExpenseEnvelope  (nolock)
Where
	tExpenseReceipt.ProjectKey = @ProjectKey
	and tExpenseReceipt.InvoiceLineKey is null
	and tExpenseReceipt.ExpenseEnvelopeKey = tExpenseEnvelope.ExpenseEnvelopeKey
	and tExpenseEnvelope.Status = 4
	and tExpenseReceipt.WriteOff = 0
	

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN -600
END	
	

Update tVoucherDetail Set InvoiceLineKey = 0, WriteOff = 0, DateBilled = @BilledDate 
from 
	tVoucher  (nolock)
Where
	tVoucherDetail.ProjectKey = @ProjectKey
	and tVoucherDetail.InvoiceLineKey is null
	and tVoucherDetail.VoucherKey = tVoucher.VoucherKey
	and tVoucher.Status = 4
	and tVoucherDetail.WriteOff = 0
	
IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN -700
END		

COMMIT TRAN	
exec sptProjectRollupUpdate  @ProjectKey,-1,1,1,1,1
		 
 RETURN 1
GO
