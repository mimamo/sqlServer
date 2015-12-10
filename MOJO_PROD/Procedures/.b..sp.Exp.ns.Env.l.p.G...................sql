USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptExpenseEnvelopeGet]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptExpenseEnvelopeGet]
 @ExpenseEnvelopeKey int
AS --Encrypt

/*
|| When      Who Rel      What
|| 7/17/07   CRG 8.5      (9833) Added VendorID
|| 10/15/09  GWG 10.512   Added Expense Approver key
|| 12/10/09  GWG 10.514   Modified the get for billing to not include transfers and only when on real invoices
|| 02/07/10  GWG 10.5.1.8 Limited the check on DetailPaid to not include transfered transactions
|| 02/09/11  RLB 10.542   (100772) getting sales tax information
|| 10/08/12  RLB 10.561   Getting the GLCompanyKey from the user on the Expense report
|| 10/23/12  KMC 10.561   Added the BackupApproverKey so the Edit Timesheet screen can enable/disable the Approve/Reject button 
|| 04/22/13  KMC 10.567   (175039) Updated the BackupApprover to BackupExpenseApprover to stay consistent with
||                        user data pulled in spInitLoad
|| 07/17/13  WDF 10.5.7.0 (176497) Added VoucherID
|| 11/26/13  GHL 10.5.7.4 Added currency info
|| 06/18/14  MAS 10.5.8.0 Added ApprovalStatus, ReceiptCount and ExpenseTotal for the new app
|| 07/28/14  MAS 10.5.8.2 Added CurrencyDescription for the new app
*/

Declare @WipPost tinyint, @Billed tinyint, @Registered tinyint, @UserKey int, @BillingDetail int, @DetailPaid tinyint, @NotifyEmail varchar(200)
Declare @GLCompanyKey int, @CompanyKey int

if exists(Select 1 from tExpenseReceipt (nolock) Where ExpenseEnvelopeKey = @ExpenseEnvelopeKey and (WIPPostingInKey = 1 or WIPPostingOutKey = 1))
	Select @WipPost = 1
else
	Select @WipPost = 0
	
if exists(Select 1 from tExpenseReceipt (nolock) Where ExpenseEnvelopeKey = @ExpenseEnvelopeKey and TransferToKey is null and InvoiceLineKey > 0)
	Select @Billed = 1
else
	Select @Billed = 0
	
if exists(Select 1 from tExpenseReceipt (nolock) Where ExpenseEnvelopeKey = @ExpenseEnvelopeKey and VoucherDetailKey is not null and TransferToKey is null)
	Select @DetailPaid = 1
else
	Select @DetailPaid = 0

if exists(Select 1 from tBillingDetail bd (nolock)
					inner join tExpenseReceipt er (nolock) on bd.EntityKey = er.ExpenseReceiptKey
					inner join tBilling b (nolock) on bd.BillingKey = b.BillingKey  
				Where er.ExpenseEnvelopeKey = @ExpenseEnvelopeKey
				And   bd.Entity = 'tExpenseReceipt'
				And   b.Status < 5)
	Select @BillingDetail = 1
else
	Select @BillingDetail = 0


Select @UserKey = UserKey from tExpenseEnvelope (nolock) Where ExpenseEnvelopeKey = @ExpenseEnvelopeKey
if exists(Select 1 From tUser (nolock) Where UserKey = @UserKey and	Len(UserID) > 0 and	Active = 1 and ClientVendorLogin = 0)
	Select @Registered = 1
else
	Select @Registered = 0
	
Select @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey) 
      ,@GLCompanyKey = ISNULL(GLCompanyKey, 0)
from tUser (nolock) 
Where UserKey = @UserKey
       
Select @NotifyEmail = Email
From
	tUser u (nolock)
	Inner join tPreference p (nolock) on u.UserKey = p.NotifyExpenseReport
Where
	p.CompanyKey = @CompanyKey
	
-- for multi currency
DECLARE @MultiCurrency int
DECLARE @AsOfDate smalldatetime
DECLARE @CurrencyID varchar(10)
DECLARE @ExchangeRate decimal(24,7) -- not the rate on the check header but the one in rate history
DECLARE @RateHistory int

select @CurrencyID = env.CurrencyID
	  ,@MultiCurrency = isnull(pref.MultiCurrency, 0)
from   tExpenseEnvelope env (nolock)
inner join tPreference pref (nolock) on env.CompanyKey = pref.CompanyKey
where  env.ExpenseEnvelopeKey = @ExpenseEnvelopeKey    

select @AsOfDate = getdate() -- there is no date on the expense envelope 
	
-- get the rate history for day/gl comp/curr needed to display on screen
if @MultiCurrency = 1 and isnull(@CurrencyID, '') <> ''
	exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @CurrencyID, @AsOfDate, @ExchangeRate output, @RateHistory output

  SELECT env.*
		,u.FirstName + ' ' + u.LastName as UserName
		,u.FirstName
		,u.LastName
		,u.Email
		,u.GLCompanyKey
		,app.FirstName + ' ' + app.LastName as ApproverName
		,app.Email as ApproverEmail
		,u.ExpenseApprover
		,app.BackupApprover as BackupExpenseApprover
		,@NotifyEmail as NotifyEmail
		,@WipPost as WIPPost
		,@Billed as Billed
		,@BillingDetail as BillingDetail
		,@DetailPaid as DetailPaid
		,@Registered as RegisteredUser
        ,isnull((select sum(ActualCost) from tExpenseReceipt cst (nolock)
          where env.ExpenseEnvelopeKey = cst.ExpenseEnvelopeKey),0) as TotalCost
        ,v.InvoiceNumber
        ,v.VoucherID
        ,vend.VendorID
        ,vend.CompanyName
		,st.SalesTaxID
		,st.SalesTaxName
		,st.TaxRate
		,st.PiggyBackTax
		,st2.SalesTaxID as SalesTax2ID
		,st2.SalesTaxName as SalesTax2Name
		,st2.TaxRate as TaxRate2
		,st2.PiggyBackTax as PiggyBackTax2
		,@RateHistory as RateHistory,
		case env.Status
			When 1 then 'Unsubmitted'
			When 2 then 'Submitted'
			When 3 then 'Rejected'
			When 4 then 'Approved' end as ApprovalStatus,
		0 as ReceiptCount,
		0 as ExpenseTotal,
		tc.Description AS 'CurrencyDescription'
  FROM tExpenseEnvelope env (nolock)
  inner join tUser u (nolock) on env.UserKey = u.UserKey
  left outer join tUser app (nolock) on u.ExpenseApprover = app.UserKey
  left outer join tVoucher v (nolock) on env.VoucherKey = v.VoucherKey
  left outer join tCompany vend (nolock) on env.VendorKey = vend.CompanyKey
  left outer join tSalesTax st (nolock) on env.SalesTaxKey = st.SalesTaxKey
  left outer join tSalesTax st2 (nolock) on env.SalesTax2Key = st2.SalesTaxKey
  left outer join tCurrency tc (nolock) on env.CurrencyID = tc.CurrencyID
  WHERE env.ExpenseEnvelopeKey = @ExpenseEnvelopeKey
    and env.Status in (1,2,3, 4)
   
 return 1
GO
