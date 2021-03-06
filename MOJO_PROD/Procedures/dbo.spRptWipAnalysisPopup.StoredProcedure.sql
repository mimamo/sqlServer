USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptWipAnalysisPopup]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptWipAnalysisPopup]
	(
	@CompanyKey int,
	@AsOfDate smallDatetime,
	@PopupItem varchar(100)
	)
AS -- Encrypt

  /*
  || When     Who Rel   What
  || 06/27/07 GHL 8.5   Filtering out now labor, misc cost, er on projects with retainers 
  */

	SET NOCOUNT ON
	
-- Get Default Accounts (Copied from spRptWipAnalysis)
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

from tPreference  (nolock)
Where CompanyKey = @CompanyKey
	
	IF UPPER(@PopupItem) = 'LABORNOTPOSTEDIN'
	BEGIN
	
		select tTime.TimeKey
			,tTime.TimeSheetKey
			,tTime.WorkDate
			,isnull(tUser.FirstName, '') + ' ' + isnull(tUser.LastName, '') AS UserName
			,tProject.ProjectNumber
			,tTime.ActualHours
			,tTime.ActualRate
			,tTime.ActualHours * tTime.ActualRate As Total
		from tTime (nolock) 
			inner join tTimeSheet (nolock) on tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
			inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
			inner join tUser (nolock) on tTime.UserKey = tUser.UserKey
		Where WorkDate <= @AsOfDate and WIPPostingInKey = 0 and Status = 4 
		and tProject.NonBillable = 0 and tProject.CompanyKey = @CompanyKey
		and ISNULL(tProject.RetainerKey, 0) = 0

	END
	
	
	IF UPPER(@PopupItem) = 'LABORNONBILLABLEPROJECTS'
	BEGIN
	
		select tTime.TimeKey
			,tTime.TimeSheetKey
			,tTime.WorkDate
			,isnull(tUser.FirstName, '') + ' ' + isnull(tUser.LastName, '') AS UserName
			,tProject.ProjectNumber
			,tTime.ActualHours
			,tTime.ActualRate
			,tTime.ActualHours * tTime.ActualRate As Total
		from tTime (nolock) 
			inner join tTimeSheet (nolock) on tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
			inner join tProject (nolock) on tTime.ProjectKey = tProject.ProjectKey
			inner join tUser (nolock) on tTime.UserKey = tUser.UserKey
		Where WorkDate <= @AsOfDate and WIPPostingInKey > 0
		and tProject.NonBillable = 1 and tProject.CompanyKey = @CompanyKey
	
	END
	
	IF UPPER(@PopupItem) = 'ERMISSING'
	BEGIN
	
		Select er.ExpenseReceiptKey
			  ,er.ExpenseEnvelopeKey
			  ,ee.EnvelopeNumber
			  ,isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '') AS UserName
			  ,p.ProjectNumber
			  ,er.ActualCost
			  ,er.ExpenseDate
		from tExpenseReceipt er (nolock) 
		Inner join tProject p (nolock) on er.ProjectKey = p.ProjectKey
		Inner join tExpenseEnvelope ee (nolock) on er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
		Inner join tUser u (nolock) on ee.UserKey = u.UserKey
		Where er.ExpenseDate <= @AsOfDate and WIPPostingInKey = 0
		and p.NonBillable = 0 and p.CompanyKey = @CompanyKey
		and ISNULL(p.RetainerKey, 0) = 0

	END

	IF UPPER(@PopupItem) = 'MCMISSING'
	BEGIN
	
		Select mc.MiscCostKey
			  ,mc.TotalCost 
			  ,p.ProjectKey
			  ,p.ProjectNumber
			  ,mc.ShortDescription
			  ,mc.ExpenseDate
		from tMiscCost mc (nolock) 
		Inner join tProject p (nolock) on mc.ProjectKey = p.ProjectKey
		Where ExpenseDate <= @AsOfDate and WIPPostingInKey = 0
		and p.NonBillable = 0 and p.CompanyKey = @CompanyKey
		and ISNULL(p.RetainerKey, 0) = 0

	END

	IF UPPER(@PopupItem) = 'VIWRONGACCOUNT'
	BEGIN

		Select  v.InvoiceNumber
				,v.VoucherKey
				,v.InvoiceDate
				,vd.TotalCost
				,p.ProjectKey 
				,p.ProjectNumber
				,c.VendorID
				,gl.AccountNumber
				,gl.AccountName	
				,vd.ShortDescription
				,vd.VoucherDetailKey			
		from tVoucherDetail vd (nolock)
			inner join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
			inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
			left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
			left outer join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
			left outer join tGLAccount gl (nolock) on vd.ExpenseAccountKey = gl.GLAccountKey
		Where p.CompanyKey = @CompanyKey
		and p.NonBillable = 0
		and vd.ExpenseAccountKey not in (@WIPExpenseAssetAccountKey, @WIPMediaAssetAccountKey)
		and v.PostingDate <= @AsOfDate
		and pod.InvoiceLineKey is null

	END

	-- labor			
	IF UPPER(@PopupItem) = 'OTHERLABORASSET'
	BEGIN
			
		Select TransactionKey, Entity, EntityKey, Debit, Credit, TransactionDate, Reference
		,Debit - Credit AS Total
		From tTransaction (nolock) 
		Where CompanyKey = @CompanyKey 
		and TransactionDate <= @AsOfDate 
		and GLAccountKey = @WIPLaborAssetAccountKey 
		
	END
	
	IF UPPER(@PopupItem) = 'OTHERLABORINCOME'
	BEGIN
			
		Select TransactionKey, Entity, EntityKey, Debit, Credit, TransactionDate, Reference
		,Credit - Debit AS Total
		From tTransaction (nolock) 
		Where CompanyKey = @CompanyKey 
		and TransactionDate <= @AsOfDate 
		and GLAccountKey = @WIPLaborIncomeAccountKey 
		
	END	

	IF UPPER(@PopupItem) = 'OTHERLABORWRITEOFF'
	BEGIN
			
		Select TransactionKey, Entity, EntityKey, Debit, Credit, TransactionDate, Reference
		,Debit - Credit AS Total
		From tTransaction (nolock) 
		Where CompanyKey = @CompanyKey 
		and TransactionDate <= @AsOfDate 
		and GLAccountKey = @WIPLaborWOAccountKey 
		
	END	

	-- Expense
	IF UPPER(@PopupItem) = 'OTHEREXPENSEASSET'
	BEGIN
			
		Select TransactionKey, Entity, EntityKey, Debit, Credit, TransactionDate, Reference
		,Debit - Credit AS Total
		From tTransaction (nolock) 
		Where CompanyKey = @CompanyKey 
		and TransactionDate <= @AsOfDate 
		and GLAccountKey = @WIPExpenseAssetAccountKey 
		
	END
	
	IF UPPER(@PopupItem) = 'OTHEREXPENSEINCOME'
	BEGIN
			
		Select TransactionKey, Entity, EntityKey, Debit, Credit, TransactionDate, Reference
		,Credit - Debit AS Total
		From tTransaction (nolock) 
		Where CompanyKey = @CompanyKey 
		and TransactionDate <= @AsOfDate 
		and GLAccountKey = @WIPExpenseIncomeAccountKey 
		
	END	

	IF UPPER(@PopupItem) = 'OTHEREXPENSEWRITEOFF'
	BEGIN
			
		Select TransactionKey, Entity, EntityKey, Debit, Credit, TransactionDate, Reference
		,Debit - Credit AS Total
		From tTransaction (nolock) 
		Where CompanyKey = @CompanyKey 
		and TransactionDate <= @AsOfDate 
		and GLAccountKey = @WIPExpenseWOAccountKey 
		
	END	
				
	-- Media
	IF UPPER(@PopupItem) = 'OTHERMEDIAASSET'
	BEGIN
			
		Select TransactionKey, Entity, EntityKey, Debit, Credit, TransactionDate, Reference
		,Debit - Credit AS Total
		From tTransaction (nolock) 
		Where CompanyKey = @CompanyKey 
		and TransactionDate <= @AsOfDate 
		and GLAccountKey = @WIPMediaAssetAccountKey 
		
	END
	
	IF UPPER(@PopupItem) = 'OTHERMEDIAINCOME'
	BEGIN
			
		Select TransactionKey, Entity, EntityKey, Debit, Credit, TransactionDate, Reference
		,Credit - Debit AS Total
		From tTransaction (nolock) 
		Where CompanyKey = @CompanyKey 
		and TransactionDate <= @AsOfDate 
		and GLAccountKey = @WIPMediaIncomeAccountKey 
		
	END	

	IF UPPER(@PopupItem) = 'OTHERMEDIAWRITEOFF'
	BEGIN
			
		Select TransactionKey, Entity, EntityKey, Debit, Credit, TransactionDate, Reference
		,Debit - Credit AS Total
		From tTransaction (nolock) 
		Where CompanyKey = @CompanyKey 
		and TransactionDate <= @AsOfDate 
		and GLAccountKey = @WIPMediaWOAccountKey 
		
	END	
					
	RETURN 1
GO
