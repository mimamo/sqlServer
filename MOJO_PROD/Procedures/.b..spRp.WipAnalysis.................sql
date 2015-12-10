USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptWipAnalysis]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptWipAnalysis]

	(
		@CompanyKey int,
		@AsOfDate smallDatetime
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 03/21/07 GHL 8.4   Added Labor Billed but Worked Later total  
  || 06/26/07 GHL 8.43  Filtering out now labor, er, misc transactions on retainer                 
  */
  
-- Update Date Billed Settings
Update tTime 
Set DateBilled = NULL
Where InvoiceLineKey is null and WriteOff = 0 and DateBilled is not null

Update tMiscCost
Set DateBilled = NULL
Where InvoiceLineKey is null and WriteOff = 0 and DateBilled is not null

Update tExpenseReceipt
Set DateBilled = NULL
Where InvoiceLineKey is null and WriteOff = 0 and DateBilled is not null

Update tVoucherDetail
Set DateBilled = NULL
Where InvoiceLineKey is null and WriteOff = 0 and DateBilled is not null

Update tTime
	Set DateBilled = tInvoice.InvoiceDate
From
	tInvoiceLine (nolock), tInvoice (nolock)
Where
	tTime.InvoiceLineKey = tInvoiceLine.InvoiceLineKey and
	tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey and
	(tTime.InvoiceLineKey is not null or WriteOff = 1) and DateBilled is null

Update tExpenseReceipt
	Set DateBilled = tInvoice.InvoiceDate
From
	tInvoiceLine (nolock), tInvoice (nolock)
Where
	tExpenseReceipt.InvoiceLineKey = tInvoiceLine.InvoiceLineKey and
	tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey and
	(tExpenseReceipt.InvoiceLineKey is not null or WriteOff = 1) and DateBilled is null

Update tMiscCost
	Set DateBilled = tInvoice.InvoiceDate
From
	tInvoiceLine (nolock), tInvoice (nolock)
Where
	tMiscCost.InvoiceLineKey = tInvoiceLine.InvoiceLineKey and
	tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey and
	(tMiscCost.InvoiceLineKey is not null or WriteOff = 1) and DateBilled is null

Update tVoucherDetail
	Set DateBilled = tInvoice.InvoiceDate
From
	tInvoiceLine (nolock), tInvoice (nolock)
Where
	tVoucherDetail.InvoiceLineKey = tInvoiceLine.InvoiceLineKey and
	tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey and
	(tVoucherDetail.InvoiceLineKey is not null or WriteOff = 1) and DateBilled is null
	
	
	
-- Get Default Accounts
Declare @WIPLaborAssetAccountKey int, @WIPLaborAssetAccount varchar(1000), @WIPLaborAssetAccountD money, @WIPLaborAssetAccountC money, @WIPLaborAssetAccountDJE money, @WIPLaborAssetAccountCJE money
Declare @WIPLaborIncomeAccountKey int, @WIPLaborIncomeAccount varchar(1000), @WIPLaborIncomeAccountD money, @WIPLaborIncomeAccountC money, @WIPLaborIncomeAccountDJE money, @WIPLaborIncomeAccountCJE money
Declare @WIPLaborWOAccountKey int, @WIPLaborWOAccount varchar(1000), @WIPLaborWOAccountD money, @WIPLaborWOAccountC money, @WIPLaborWOAccountDJE money, @WIPLaborWOAccountCJE money
Declare @WIPExpenseAssetAccountKey int, @WIPExpenseAssetAccount varchar(1000), @WIPExpenseAssetAccountD money, @WIPExpenseAssetAccountC money, @WIPExpenseAssetAccountDJE money, @WIPExpenseAssetAccountCJE money
Declare @WIPExpenseIncomeAccountKey int, @WIPExpenseIncomeAccount varchar(1000), @WIPExpenseIncomeAccountD money, @WIPExpenseIncomeAccountC money, @WIPExpenseIncomeAccountDJE money, @WIPExpenseIncomeAccountCJE money
Declare @WIPExpenseWOAccountKey int, @WIPExpenseWOAccount varchar(1000), @WIPExpenseWOAccountD money, @WIPExpenseWOAccountC money, @WIPExpenseWOAccountDJE money, @WIPExpenseWOAccountCJE money
Declare @WIPMediaAssetAccountKey int, @WIPMediaAssetAccount varchar(1000), @WIPMediaAssetAccountD money, @WIPMediaAssetAccountC money, @WIPMediaAssetAccountDJE money, @WIPMediaAssetAccountCJE money
Declare @WIPMediaIncomeAccountKey int, @WIPMediaIncomeAccount varchar(1000), @WIPMediaIncomeAccountD money, @WIPMediaIncomeAccountC money, @WIPMediaIncomeAccountDJE money, @WIPMediaIncomeAccountCJE money
Declare @WIPMediaWOAccountKey int, @WIPMediaWOAccount varchar(1000), @WIPMediaWOAccountD money, @WIPMediaWOAccountC money, @WIPMediaWOAccountDJE money, @WIPMediaWOAccountCJE money

Select
	@WIPLaborAssetAccountKey = ISNULL(WIPLaborAssetAccountKey, 0),
	@WIPLaborIncomeAccountKey = ISNULL(WIPLaborIncomeAccountKey, 0),
	@WIPLaborWOAccountKey = ISNULL(WIPLaborWOAccountKey, 0),
	@WIPExpenseAssetAccountKey = ISNULL(WIPExpenseAssetAccountKey, 0),
	@WIPExpenseIncomeAccountKey = ISNULL(WIPExpenseIncomeAccountKey, 0),
	@WIPExpenseWOAccountKey = ISNULL(WIPExpenseWOAccountKey, 0),
	@WIPMediaAssetAccountKey = ISNULL(WIPMediaAssetAccountKey, 0),
	@WIPMediaWOAccountKey = ISNULL(WIPMediaWOAccountKey, 0)
from tPreference (nolock) 
Where CompanyKey = @CompanyKey

Select @WIPLaborAssetAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPLaborAssetAccountKey
Select @WIPLaborIncomeAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPLaborIncomeAccountKey
Select @WIPLaborWOAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPLaborWOAccountKey
Select @WIPExpenseAssetAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPExpenseAssetAccountKey
Select @WIPExpenseIncomeAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPExpenseIncomeAccountKey
Select @WIPExpenseWOAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPExpenseWOAccountKey
Select @WIPMediaAssetAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPMediaAssetAccountKey
Select @WIPMediaIncomeAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPMediaIncomeAccountKey
Select @WIPMediaWOAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPMediaWOAccountKey


Select @WIPLaborAssetAccountD = Sum(Debit), @WIPLaborAssetAccountC = sum(Credit)
From tTransaction (nolock) Where CompanyKey = @CompanyKey and TransactionDate <= @AsOfDate and GLAccountKey = @WIPLaborAssetAccountKey and Entity = 'WIP'
Select @WIPLaborIncomeAccountD = Sum(Debit), @WIPLaborIncomeAccountC = sum(Credit)
From tTransaction (nolock) Where CompanyKey = @CompanyKey and TransactionDate <= @AsOfDate and GLAccountKey = @WIPLaborIncomeAccountKey and Entity = 'WIP'
Select @WIPLaborWOAccountD = Sum(Debit), @WIPLaborWOAccountC = sum(Credit)
From tTransaction (nolock) Where CompanyKey = @CompanyKey and TransactionDate <= @AsOfDate and GLAccountKey = @WIPLaborWOAccountKey and Entity = 'WIP'
Select @WIPLaborAssetAccountDJE = Sum(Debit), @WIPLaborAssetAccountCJE = sum(Credit)
From tTransaction (nolock) Where CompanyKey = @CompanyKey and TransactionDate <= @AsOfDate and GLAccountKey = @WIPLaborAssetAccountKey and Entity <> 'WIP'
Select @WIPLaborIncomeAccountDJE = Sum(Debit), @WIPLaborIncomeAccountCJE = sum(Credit)
From tTransaction (nolock) Where CompanyKey = @CompanyKey and TransactionDate <= @AsOfDate and GLAccountKey = @WIPLaborIncomeAccountKey and Entity <> 'WIP'
Select @WIPLaborWOAccountDJE = Sum(Debit), @WIPLaborWOAccountCJE = sum(Credit)
From tTransaction (nolock) Where CompanyKey = @CompanyKey and TransactionDate <= @AsOfDate and GLAccountKey = @WIPLaborWOAccountKey and Entity <> 'WIP'

Select @WIPExpenseAssetAccountD = Sum(Debit), @WIPExpenseAssetAccountC = sum(Credit)
From tTransaction (nolock) Where CompanyKey = @CompanyKey and TransactionDate <= @AsOfDate and GLAccountKey = @WIPExpenseAssetAccountKey and Entity in( 'WIP', 'VOUCHER' )
Select @WIPExpenseIncomeAccountD = Sum(Debit), @WIPExpenseIncomeAccountC = sum(Credit)
From tTransaction (nolock) Where CompanyKey = @CompanyKey and TransactionDate <= @AsOfDate and GLAccountKey = @WIPExpenseIncomeAccountKey and Entity in( 'WIP', 'VOUCHER' )
Select @WIPExpenseWOAccountD = Sum(Debit), @WIPExpenseWOAccountC = sum(Credit)
From tTransaction (nolock) Where CompanyKey = @CompanyKey and TransactionDate <= @AsOfDate and GLAccountKey = @WIPExpenseWOAccountKey and Entity in( 'WIP', 'VOUCHER' )
Select @WIPExpenseAssetAccountDJE = Sum(Debit), @WIPExpenseAssetAccountCJE = sum(Credit)
From tTransaction (nolock) Where CompanyKey = @CompanyKey and TransactionDate <= @AsOfDate and GLAccountKey = @WIPExpenseAssetAccountKey and Entity not in( 'WIP', 'VOUCHER' )
Select @WIPExpenseIncomeAccountDJE = Sum(Debit), @WIPExpenseIncomeAccountCJE = sum(Credit)
From tTransaction (nolock) Where CompanyKey = @CompanyKey and TransactionDate <= @AsOfDate and GLAccountKey = @WIPExpenseIncomeAccountKey and Entity not in( 'WIP', 'VOUCHER' )
Select @WIPExpenseWOAccountDJE = Sum(Debit), @WIPExpenseWOAccountCJE = sum(Credit)
From tTransaction (nolock) Where CompanyKey = @CompanyKey and TransactionDate <= @AsOfDate and GLAccountKey = @WIPExpenseWOAccountKey and Entity not in( 'WIP', 'VOUCHER' )

Select @WIPMediaAssetAccountD = Sum(Debit), @WIPMediaAssetAccountC = sum(Credit)
From tTransaction (nolock) Where CompanyKey = @CompanyKey and TransactionDate <= @AsOfDate and GLAccountKey = @WIPMediaAssetAccountKey and Entity in( 'WIP', 'VOUCHER' )
Select @WIPMediaIncomeAccountD = Sum(Debit), @WIPMediaIncomeAccountC = sum(Credit)
From tTransaction (nolock) Where CompanyKey = @CompanyKey and TransactionDate <= @AsOfDate and GLAccountKey = @WIPMediaIncomeAccountKey and Entity in( 'WIP', 'VOUCHER' )
Select @WIPMediaWOAccountD = Sum(Debit), @WIPMediaWOAccountC = sum(Credit)
From tTransaction (nolock) Where CompanyKey = @CompanyKey and TransactionDate <= @AsOfDate and GLAccountKey = @WIPMediaWOAccountKey and Entity in( 'WIP', 'VOUCHER' )
Select @WIPMediaAssetAccountDJE = Sum(Debit), @WIPMediaAssetAccountCJE = sum(Credit)
From tTransaction (nolock) Where CompanyKey = @CompanyKey and TransactionDate <= @AsOfDate and GLAccountKey = @WIPMediaAssetAccountKey and Entity not in( 'WIP', 'VOUCHER' )
Select @WIPMediaIncomeAccountDJE = Sum(Debit), @WIPMediaIncomeAccountCJE = sum(Credit)
From tTransaction (nolock) Where CompanyKey = @CompanyKey and TransactionDate <= @AsOfDate and GLAccountKey = @WIPMediaIncomeAccountKey and Entity not in( 'WIP', 'VOUCHER' )
Select @WIPMediaWOAccountDJE = Sum(Debit), @WIPMediaWOAccountCJE = sum(Credit)
From tTransaction (nolock) Where CompanyKey = @CompanyKey and TransactionDate <= @AsOfDate and GLAccountKey = @WIPMediaWOAccountKey and Entity not in( 'WIP', 'VOUCHER' )


Declare @LaborPostedIn money, @LaborBilled money, @LaborWO money, @LaborMB money, @LaborNotPostedIn money, @LaborNonBillableProjects money
Declare @LaborBilledWorkedLater money

-- ****************************************************************************************************************************
-- Labor
-- ****************************************************************************************************************************
-- Total Posted In
Select @LaborPostedIn = sum(ROUND(ActualHours * ActualRate, 2)) 
from tTime t (nolock) inner join tWIPPosting wp (nolock) on t.WIPPostingInKey = wp.WIPPostingKey
Where wp.CompanyKey = @CompanyKey and wp.PostingDate <= @AsOfDate


--Billed but Work Day Later
--To correct the problem at ThougtForm where WIP Analysis = 395,909.75
--And Project WIP = 397,035 diff 1125 due to the fact that time entries were Billed in 12/29/2006 and worked in 1/5/2007   
Select @LaborBilledWorkedLater = sum(ROUND(ActualHours * ActualRate, 2)) 
from tTime t (nolock) inner join tWIPPosting wp (nolock) on t.WIPPostingOutKey = wp.WIPPostingKey
Where wp.CompanyKey = @CompanyKey and wp.PostingDate <= @AsOfDate
And t.DateBilled <= @AsOfDate And t.WorkDate > @AsOfDate

-- Billed
Select @LaborBilled = sum(ROUND(ActualHours * ActualRate, 2)) 
from tTime t (nolock) inner join tWIPPosting wp (nolock) on t.WIPPostingOutKey = wp.WIPPostingKey
Where wp.CompanyKey = @CompanyKey and wp.PostingDate <= @AsOfDate and t.InvoiceLineKey > 0

-- Marked Billed
Select @LaborMB = sum(ROUND(ActualHours * ActualRate, 2)) 
from tTime t (nolock) inner join tWIPPosting wp (nolock) on t.WIPPostingOutKey = wp.WIPPostingKey
Where wp.CompanyKey = @CompanyKey and wp.PostingDate <= @AsOfDate and t.InvoiceLineKey = 0

--Write Off
Select @LaborWO = sum(ROUND(ActualHours * ActualRate, 2)) 
from tTime t (nolock) inner join tWIPPosting wp (nolock) on t.WIPPostingOutKey = wp.WIPPostingKey
Where wp.CompanyKey = @CompanyKey and wp.PostingDate <= @AsOfDate and t.WriteOff = 1

-- Time in system, but not posted as of period date
select @LaborNotPostedIn = sum(ROUND(ActualHours * ActualRate, 2)) from tTime (nolock) 
inner join tTimeSheet (nolock) on tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
Where WorkDate <= @AsOfDate and WIPPostingInKey = 0 and Status = 4 and ISNULL(RetainerKey, 0) = 0
and tProject.NonBillable = 0 and tProject.CompanyKey = @CompanyKey
and ISNULL(tProject.RetainerKey, 0) = 0


select @LaborNonBillableProjects = sum(ROUND(ActualHours * ActualRate, 2)) from tTime (nolock) 
inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
Where WorkDate <= @AsOfDate and WIPPostingInKey > 0
and tProject.NonBillable = 1 and tProject.CompanyKey = @CompanyKey

-- ****************************************************************************************************************************
-- Misc Costs
-- ****************************************************************************************************************************
Declare @MCPostedIn money, @MCBilled money, @MCWO money, @MCMB money, @MCMissing money

Select @MCPostedIn = sum(TotalCost) 
from tMiscCost t (nolock) 
inner join tWIPPosting wp (nolock) on t.WIPPostingInKey = wp.WIPPostingKey
Where wp.CompanyKey = @CompanyKey and wp.PostingDate <= @AsOfDate

Select @MCBilled = sum(TotalCost) 
from tMiscCost t (nolock) 
inner join tWIPPosting wp (nolock) on t.WIPPostingOutKey = wp.WIPPostingKey
Where wp.CompanyKey = @CompanyKey and wp.PostingDate <= @AsOfDate and InvoiceLineKey > 0

Select @MCMB = sum(TotalCost) 
from tMiscCost t (nolock) 
inner join tWIPPosting wp (nolock) on t.WIPPostingOutKey = wp.WIPPostingKey
Where wp.CompanyKey = @CompanyKey and wp.PostingDate <= @AsOfDate and InvoiceLineKey = 0

Select @MCWO = sum(TotalCost) 
from tMiscCost t (nolock) 
inner join tWIPPosting wp (nolock) on t.WIPPostingOutKey = wp.WIPPostingKey
Where wp.CompanyKey = @CompanyKey and wp.PostingDate <= @AsOfDate and WriteOff = 1

Select @MCMissing = sum(TotalCost) 
from tMiscCost t (nolock) 
Inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
Where ExpenseDate <= @AsOfDate and WIPPostingInKey = 0
and p.NonBillable = 0 and p.CompanyKey = @CompanyKey
and ISNULL(p.RetainerKey, 0) = 0


-- ****************************************************************************************************************************
-- Expense Reports
-- ****************************************************************************************************************************
Declare @ERPostedIn money, @ERBilled money, @ERWO money, @ERMB money, @ERMissing money
Select @ERPostedIn = sum(ActualCost) 
from tExpenseReceipt t (nolock) 
inner join tWIPPosting wp (nolock) on t.WIPPostingInKey = wp.WIPPostingKey
Where wp.CompanyKey = @CompanyKey and wp.PostingDate <= @AsOfDate

Select @ERBilled = sum(ActualCost) 
from tExpenseReceipt t (nolock) 
inner join tWIPPosting wp (nolock) on t.WIPPostingOutKey = wp.WIPPostingKey
Where wp.CompanyKey = @CompanyKey and wp.PostingDate <= @AsOfDate and InvoiceLineKey > 0

Select @ERMB = sum(ActualCost) 
from tExpenseReceipt t (nolock) 
inner join tWIPPosting wp (nolock) on t.WIPPostingOutKey = wp.WIPPostingKey
Where wp.CompanyKey = @CompanyKey and wp.PostingDate <= @AsOfDate and InvoiceLineKey = 0

Select @ERWO = sum(ActualCost) 
from tExpenseReceipt t (nolock) 
inner join tWIPPosting wp (nolock) on t.WIPPostingOutKey = wp.WIPPostingKey
Where wp.CompanyKey = @CompanyKey and wp.PostingDate <= @AsOfDate and WriteOff = 1

Select @ERMissing = sum(ActualCost) 
from tExpenseReceipt t (nolock) 
Inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
Inner join tExpenseEnvelope ee (nolock) on t.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
Where ExpenseDate <= @AsOfDate and WIPPostingInKey = 0
and p.NonBillable = 0 and p.CompanyKey = @CompanyKey
and ISNULL(p.RetainerKey, 0) = 0


-- ****************************************************************************************************************************
-- Vendor Invoices (Production)
-- ****************************************************************************************************************************
Declare @VIPostedIn money, @VIBilled money, @VIWO money, @VIMB money, @VIMissing money, @VIWrongAccount money, @VIWrongAccount2 money

Select @VIPostedIn = sum(vd.TotalCost) 
from tVoucherDetail vd (nolock) 
Inner join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
Inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
left outer join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
Where p.NonBillable = 0 
and p.CompanyKey = @CompanyKey 
and v.Status = 4
and v.Posted = 1
and vd.ExpenseAccountKey = @WIPExpenseAssetAccountKey
and v.PostingDate <= @AsOfDate
and pod.InvoiceLineKey is null

Select @VIBilled = sum(vd.TotalCost) 
from tVoucherDetail vd (nolock) 
inner join tWIPPosting wp (nolock) on vd.WIPPostingOutKey = wp.WIPPostingKey
Where wp.CompanyKey = @CompanyKey and wp.PostingDate <= @AsOfDate and InvoiceLineKey > 0
and vd.ExpenseAccountKey = @WIPExpenseAssetAccountKey

Select @VIMB = sum(vd.TotalCost) 
from tVoucherDetail vd (nolock) 
inner join tWIPPosting wp (nolock) on vd.WIPPostingOutKey = wp.WIPPostingKey
Where wp.CompanyKey = @CompanyKey and wp.PostingDate <= @AsOfDate and InvoiceLineKey = 0
and vd.ExpenseAccountKey = @WIPExpenseAssetAccountKey

Select @VIWO = sum(vd.TotalCost) 
from tVoucherDetail vd (nolock) 
inner join tWIPPosting wp (nolock) on vd.WIPPostingOutKey = wp.WIPPostingKey
Where wp.CompanyKey = @CompanyKey and wp.PostingDate <= @AsOfDate and WriteOff = 1
and vd.ExpenseAccountKey = @WIPExpenseAssetAccountKey


-- ****************************************************************************************************************************
-- Vendor Invoices (Media)
-- ****************************************************************************************************************************
Declare @VIMPostedIn money, @VIMBilled money, @VIMWO money, @VIMMB money, @VIMMissing money, @VIMWrongAccount money

Select @VIMPostedIn = sum(vd.TotalCost) 
from tVoucherDetail vd (nolock) 
Inner join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
Inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
left outer join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
Where p.NonBillable = 0 
and p.CompanyKey = @CompanyKey 
and v.Status = 4
and v.Posted = 1
and vd.ExpenseAccountKey = @WIPMediaAssetAccountKey
and v.PostingDate <= @AsOfDate
and pod.InvoiceLineKey is null

Select @VIMBilled = sum(vd.TotalCost) 
from tVoucherDetail vd (nolock) 
inner join tWIPPosting wp (nolock) on vd.WIPPostingOutKey = wp.WIPPostingKey
Where wp.CompanyKey = @CompanyKey and wp.PostingDate <= @AsOfDate and InvoiceLineKey > 0
and vd.ExpenseAccountKey = @WIPMediaAssetAccountKey

Select @VIMMB = sum(vd.TotalCost) 
from tVoucherDetail vd (nolock) 
inner join tWIPPosting wp (nolock) on vd.WIPPostingOutKey = wp.WIPPostingKey
Where wp.CompanyKey = @CompanyKey and wp.PostingDate <= @AsOfDate and InvoiceLineKey = 0
and vd.ExpenseAccountKey = @WIPMediaAssetAccountKey

Select @VIMWO = sum(vd.TotalCost) 
from tVoucherDetail vd (nolock) 
inner join tWIPPosting wp (nolock) on vd.WIPPostingOutKey = wp.WIPPostingKey
Where wp.CompanyKey = @CompanyKey and wp.PostingDate <= @AsOfDate and WriteOff = 1
and vd.ExpenseAccountKey = @WIPMediaAssetAccountKey


-- ****************************************************************************************************************************
-- Vendor Invoices Problems
-- ****************************************************************************************************************************

Select @VIWrongAccount = Sum(vd.TotalCost) from tVoucherDetail vd (nolock)
inner join tProject (nolock) on vd.ProjectKey = tProject.ProjectKey
inner join tVoucher (nolock) on tVoucher.VoucherKey = vd.VoucherKey
left outer join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
Where tProject.CompanyKey = @CompanyKey
and tProject.NonBillable = 0
and ExpenseAccountKey not in (@WIPExpenseAssetAccountKey, @WIPMediaAssetAccountKey)
and tVoucher.PostingDate <= @AsOfDate
and pod.InvoiceLineKey is null

Select @VIWrongAccount2 = Sum(vd.TotalCost) from tVoucherDetail vd (nolock)
inner join tProject (nolock) on vd.ProjectKey = tProject.ProjectKey
inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
Where tProject.CompanyKey = @CompanyKey
and tProject.NonBillable = 1
and ExpenseAccountKey in (@WIPExpenseAssetAccountKey, @WIPMediaAssetAccountKey)
and v.PostingDate <= @AsOfDate
and v.Posted = 1

Select
 @WIPLaborAssetAccount as WIPLaborAssetAccount
,ISNULL(@WIPLaborAssetAccountD, 0) as WIPLaborAssetAccountD
,ISNULL(@WIPLaborAssetAccountC, 0) as WIPLaborAssetAccountC
,ISNULL(@WIPLaborAssetAccountDJE, 0) as WIPLaborAssetAccountDJE
,ISNULL(@WIPLaborAssetAccountCJE, 0) as WIPLaborAssetAccountCJE
,@WIPLaborIncomeAccount as WIPLaborIncomeAccount
,ISNULL(@WIPLaborIncomeAccountD, 0) as WIPLaborIncomeAccountD
,ISNULL(@WIPLaborIncomeAccountC, 0) as WIPLaborIncomeAccountC
,ISNULL(@WIPLaborIncomeAccountDJE, 0) as WIPLaborIncomeAccountDJE
,ISNULL(@WIPLaborIncomeAccountCJE, 0) as WIPLaborIncomeAccountCJE
,@WIPLaborWOAccount as WIPLaborWOAccount
,ISNULL(@WIPLaborWOAccountD, 0) as WIPLaborWOAccountD
,ISNULL(@WIPLaborWOAccountC, 0) as WIPLaborWOAccountC
,ISNULL(@WIPLaborWOAccountDJE, 0) as WIPLaborWOAccountDJE
,ISNULL(@WIPLaborWOAccountCJE, 0) as WIPLaborWOAccountCJE
,@WIPExpenseAssetAccount as WIPExpenseAssetAccount
,ISNULL(@WIPExpenseAssetAccountD, 0) as WIPExpenseAssetAccountD
,ISNULL(@WIPExpenseAssetAccountC, 0) as WIPExpenseAssetAccountC
,ISNULL(@WIPExpenseAssetAccountDJE, 0) as WIPExpenseAssetAccountDJE
,ISNULL(@WIPExpenseAssetAccountCJE, 0) as WIPExpenseAssetAccountCJE
,@WIPExpenseIncomeAccount as WIPExpenseIncomeAccount
,ISNULL(@WIPExpenseIncomeAccountD, 0) as WIPExpenseIncomeAccountD
,ISNULL(@WIPExpenseIncomeAccountC, 0) as WIPExpenseIncomeAccountC
,ISNULL(@WIPExpenseIncomeAccountDJE, 0) as WIPExpenseIncomeAccountDJE
,ISNULL(@WIPExpenseIncomeAccountCJE, 0) as WIPExpenseIncomeAccountCJE
,@WIPExpenseWOAccount as WIPExpenseWOAccount
,ISNULL(@WIPExpenseWOAccountD, 0) as WIPExpenseWOAccountD
,ISNULL(@WIPExpenseWOAccountC, 0) as WIPExpenseWOAccountC
,ISNULL(@WIPExpenseWOAccountDJE, 0) as WIPExpenseWOAccountDJE
,ISNULL(@WIPExpenseWOAccountCJE, 0) as WIPExpenseWOAccountCJE
,@WIPMediaAssetAccount as WIPMediaAssetAccount
,ISNULL(@WIPMediaAssetAccountD, 0) as WIPMediaAssetAccountD
,ISNULL(@WIPMediaAssetAccountC, 0) as WIPMediaAssetAccountC
,ISNULL(@WIPMediaAssetAccountDJE, 0) as WIPMediaAssetAccountDJE
,ISNULL(@WIPMediaAssetAccountCJE, 0) as WIPMediaAssetAccountCJE
,@WIPMediaIncomeAccount as WIPMediaIncomeAccount
,ISNULL(@WIPMediaIncomeAccountD, 0) as WIPMediaIncomeAccountD
,ISNULL(@WIPMediaIncomeAccountC, 0) as WIPMediaIncomeAccountC
,ISNULL(@WIPMediaIncomeAccountDJE, 0) as WIPMediaIncomeAccountDJE
,ISNULL(@WIPMediaIncomeAccountCJE, 0) as WIPMediaIncomeAccountCJE
,@WIPMediaWOAccount as WIPMediaWOAccount
,ISNULL(@WIPMediaWOAccountD, 0) as WIPMediaWOAccountD
,ISNULL(@WIPMediaWOAccountC, 0) as WIPMediaWOAccountC
,ISNULL(@WIPMediaWOAccountDJE, 0) as WIPMediaWOAccountDJE
,ISNULL(@WIPMediaWOAccountCJE, 0) as WIPMediaWOAccountCJE
,ISNULL(@LaborPostedIn, 0) as LaborPostedIn
,ISNULL(@LaborBilled, 0) as LaborBilled
,ISNULL(@LaborBilledWorkedLater, 0) as LaborBilledWorkedLater
,ISNULL(@LaborWO, 0) as LaborWO
,ISNULL(@LaborMB, 0) as LaborMB
,ISNULL(@LaborNotPostedIn, 0) as LaborNotPostedIn
,ISNULL(@LaborNonBillableProjects, 0) as LaborNonBillableProjects
,ISNULL(@MCPostedIn, 0) as MCPostedIn
,ISNULL(@MCBilled, 0) as MCBilled
,ISNULL(@MCWO, 0) as MCWO
,ISNULL(@MCMB, 0) as MCMB
,ISNULL(@MCMissing, 0) as MCMissing
,ISNULL(@ERPostedIn, 0) as ERPostedIn
,ISNULL(@ERBilled, 0) as ERBilled
,ISNULL(@ERWO, 0) as ERWO
,ISNULL(@ERMB, 0) as ERMB
,ISNULL(@ERMissing, 0) as ERMissing
,ISNULL(@VIPostedIn, 0) as VIPostedIn
,ISNULL(@VIBilled, 0) as VIBilled
,ISNULL(@VIWO, 0) as VIWO
,ISNULL(@VIMB, 0) as VIMB
,ISNULL(@VIMPostedIn, 0) as VIMPostedIn
,ISNULL(@VIMBilled, 0) as VIMBilled
,ISNULL(@VIMWO, 0) as VIMWO
,ISNULL(@VIMMB, 0) as VIMMB
,ISNULL(@VIWrongAccount, 0) as VIWrongAccount
,ISNULL(@VIWrongAccount2, 0) as VIWrongAccount2
GO
