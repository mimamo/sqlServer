USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptInvoiceAging]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptInvoiceAging]
(
	@CompanyKey int,
	@AsOfDate smalldatetime,
	@ClientKey int,
	@ParentClientKey int,
	@ClassKey int,
	@ProjectKey int = null,       -- ProjectKey on header
	@PostStatus tinyint,
	@AdvBill tinyint,		      -- Include Unapplied Advanced Billings
	@Receipts tinyint,
	@AgingDateOption tinyint,
	@OlderThan smallint,
	@Days1 smallint,
	@Days2 smallint,
	@Days3 smallint,
	@SummaryOnly tinyint,         -- 0: Regular AR Statement or Aging; 1: Used by Running Balance statement to get the Aging totals.
	@GLCompanyKey int = NULL,     -- -1 All, 0 NULL, >0 valid GLCompany
	@Invoices tinyint = 1,        -- Include Invoices
	@AdvBillSalesTax tinyint = 1,  -- Include Sales Taxes on Unapplied Advanced Billings
	@AdvBillMultiplier int = 1,
	@ARAccountKey int,
	@UserKey int = null,
	@AccountManager int = null,
	@CurrencyID varchar(10) = null -- Null Home Currency, or a foreign currency
)
AS --Encrypt
SET NOCOUNT ON

 /*
  || When     Who Rel  What
  || 06/27/06 GHL 8.35 Added ProjectKey parameter and column to include projects 
  ||                   in Client statements. Also added Primary contact 
  ||                   (Bug 4969 McClain-Finlon)
  || 11/06/06 CRG 8.35 Added option for aging based on PostingDate.
  || 11/27/06 CRG 8.35 Added @SummaryOnly parameter to get the Aging totals.
  || 11/28/06 GWG 8.35 Removed the unapplied payment link to invoices to take into account all applications
  || 02/20/07 GHL 8.403 Filtering out now checks which are voided (Bug 8330)
  || 10/17/07 CRG 8.5  Added GLCompanyKey parameter, and OfficeName to the return data
  || 11/27/07 GHL 8.5  Removed alias in ORDER BY for SQL Server 2005
  || 12/13/07 GHL 8.5  Added fields required for AE view, move client key and other keys to top where clauses
  ||                   to reduce the number of records processed
  || 12/21/07 GHL 8.5  Removed needless join in initial queries to speed up perfo 
  || 01/17/08 GHL 8502 Requirements for Project Numbers has changed
  ||                   Old requirement:
  ||					-- when no project on header, look at invoice line or summary, if none display 'None', else 'MULTI'  
  ||                   New requirement:
  ||                    -- display all projects for invoices 
  ||                         proj #1 - proj name 1
  ||                         proj #2 - proj name 2     
  || 01/23/08 GHL 8502 (19016) Removed sort by Office, because it is not showing in Client Statements 
  ||                   and sorting was confusing to user (Open Transaction mode)
  ||                   Also put back project on header for Client Statements  
  || 01/29/08 GHL 8503 (19362) Removed sort by Office in summary section because this is used in conjunction with
  ||                   spRptStatementRunningBalance and there is no office in Client Statement (Statement Period mode) 
  ||                   Added check of posted status in subqueries
  ||                   Added check of invoice posting date in open rec 
  ||                   Did not fix discrepancy with spRptStatementRunningBalance in the case of application to sales
  || 05/18/08 GWG 26882 Added a restrict for prepayments so that they do not get added back in on missing receipts
  || 06/09/08 GHL 8513   (25847) Taking input parameters in account for new AR aging summary
  || 07/01/08 GHL 8515   (29015) Added new parameter @AdvBillOnly so that we only take unapplied adv billings
  || 02/10/09 GHL 10.018 (37631) Changed logic for GLCompany to match change in the UI
  || 03/09/09 GHL 10.020 (48415) Added restriction on invoice posting date <= check posting date for 'Payment'
  ||                      Because if not, there are similar to prepayments
  || 03/16/09 RLB 10.021 (48967) added sorting by invoice number
  || 04/22/09 RLB 10.024 (51346) fixed when summary was checked and due date was aging option it was pulling invoice date is now pulling Due Date
  || 04/28/09 GHL/GWG 10.024 Added Invoices parameter. Added 'Rev AB' type and removed the * -1 so advances show up positive
  || 06/12/09 GWG 10.025 Reversed the fix above from 5/18/2008 as it causes the aging to be off
  || 01/19/10 GHL 10.517 (72581) Added @AdvBillSalesTax param and associated queries
  || 05/05/10 GHL 10.522 (77192) Added @AdvBillMultiplier so that client statements show as negative
  || 06/03/10 GWG 10.530 Added in functions to Group invoices with the same invoice number together on the aging
  || 09/16/10 RLB 10.535 (61907) Added days for enhancement request
  || 01/28/12 RLB 10.552 (129693) Added AR Account filter for enhancement request
  || 04/16/12 GHL 10.555  Added UserKey for UserGLCompanyAccess
  || 08/28/12 GWG 10.559 Fixed a case where an applied receipt was showing up twice because it was applied to an invoice after the as of date.
  || 04/22/13 GHL 10.567 (175324) For unapplied receipts, I am making the distinction between payments and prepayments
  ||                     If the invoice in a prepayment is after the AsOfDate, the check should be considered unapplied
  ||                     so OpenAmount = Check Amount - sum(of prepayments) where invoice posting date <= AsOfDate 
  || 08/26/13 RLB 10.571 (185716) Adding filter for client Account mananger
  || 09/19/13 MFT 10.572 (190363) Added DivisionName.tClientDivision & ProductName.tClientProduct to final output
  || 11/14/13 GHL 10.574 (196587) Check is on 10/21/13 voided check is on 11/7/13. report run as of 10/31
  ||                     user expects to see check on the report but it is not. Changed query from ch.VoidCheckKey = 0
  ||                     to ch.VoidCheckKey = 0 Or void_ch.PostingDate > AsOfDate
  || 01/27/14 GHL 10.576 Added CurrencyID param + @MultiCurrency logic 
  || 03/11/14 RLB 10.578 (160899) Added Parent CompanyKey for enhancement
  || 05/09/14 GHL 10.580 If the report is grouped by project, make sure that there is no difference between NULL and 0
  ||                     The report uses ProjectKey as the group's datafield 
  || 05/13/14 GHL 10.580 (215354) Filter out invoices which are over applied
  || 02/23/15 KMC 10.589 (247059) Added ISNULL check for the Account Manager to default it to the company record Account Manager
  || 03/11/15 GHL 10.590 (248945) Problem when the Advance Bill comes after the regular invoice, the RetainerAmount is not time sensitive
  ||                      For this reason, I recalculate the total adv bill amount with FromAB = 0 (instead of taking i.RetainerAmount) 
  ||                      And we need to add to the applied amount the total adv bill amount with FromAB = 1
  || 04/14/15 GHL 10.591 (253288) Deleting now advance bills where applied amount > invoice amount to correct bad data
  ||                      The data could not be corrected due to GL locking
  || 05/08/15 GHL 10.591 (255992) Because sometimes i.RetainerAmount <> Sum(tInvoiceAdvanceBill.Amount) decided to take RetainerAmount
  ||                      when dealing with old invoices
  */

-- Create table rather than select into to reduce time locking tempdb, 17000 records my be read below
CREATE TABLE #ARAging
	(InvoiceKey INT NULL -- will hold InvoiceKey if Type = 'Invoice', 'Credit', 'Open AB' CheckKey if Type = 'Payment', 'Open Rec'
	,GLCompanyKey INT NULL
	,Type VARCHAR(50) NULL
	,Posted INT NULL
	,ClientKey INT NULL
	,LoggedCompanyKey INT NULL
	,InvoiceNumber VARCHAR(250) NULL
	,ClassKey INT NULL
	,ProjectKey INT NULL
	,ContactName VARCHAR(500) NULL
	,InvoiceDate DATETIME NULL
	,DueDate DATETIME NULL
	,PostingDate DATETIME NULL
	,BilledAmount MONEY NULL
	,AppliedAmount MONEY NULL
	,OfficeKey INT NULL
	,AccountManager INT NULL  -- AE on project on header
	,RealInvoiceKey INT NULL
	,Action INT NULL) -- to determine projects


-- check for the cbre customization
declare @Customizations varchar(2000), @RollUpMatching int
Select @Customizations = LOWER(ISNULL(Customizations, '')) from tPreference (NOLOCK) Where CompanyKey = @CompanyKey
Select @RollUpMatching = CHARINDEX('cbre', @Customizations)

Declare @RestrictToGLCompany int
Declare @MultiCurrency int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
      ,@MultiCurrency = ISNULL(MultiCurrency, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)
       ,@MultiCurrency = isnull(@MultiCurrency, 0)


IF @Invoices = 1
BEGIN
  
	-- Find the open invoices less credits and payments
	Insert Into #ARAging
	(InvoiceKey, GLCompanyKey, Type, Posted, ClientKey, LoggedCompanyKey, InvoiceNumber, ClassKey, ProjectKey, ContactName, InvoiceDate, DueDate, PostingDate
	,BilledAmount, AppliedAmount, OfficeKey, AccountManager, RealInvoiceKey)
	SELECT 
		i.InvoiceKey
		,i.GLCompanyKey
		,'Invoice'
		,i.Posted
		,i.ClientKey
		,@CompanyKey 
		,RTRIM(i.InvoiceNumber)
		,i.ClassKey
		,i.ProjectKey
		,i.ContactName
		,i.InvoiceDate
		,i.DueDate
		,i.PostingDate
		/*
		,ISNULL(i.InvoiceTotalAmount, 0) - isnull(i.DiscountAmount, 0) - ISNULL(i.WriteoffAmount, 0) -- - ISNULL(i.RetainerAmount, 0)
		-- recalc RetainerAmount for 248945
		- (select isnull(sum(iab.Amount), 0) from tInvoiceAdvanceBill iab (nolock) where iab.InvoiceKey = i.InvoiceKey and isnull(FromAB, 0) = 0 )
		AS BilledAmount
		*/
		-- due to the fact that I have too many old invoices popping up, use RetainerAmount or recalculate (there is sometimes a discrepancy between RetainerAmount and SUM(IAB.Amount))
		,case when i.InvoiceDate < '05/08/2014' then
			ISNULL(i.InvoiceTotalAmount, 0) - isnull(i.DiscountAmount, 0) - ISNULL(i.WriteoffAmount, 0) - ISNULL(i.RetainerAmount, 0)
		     else
			ISNULL(i.InvoiceTotalAmount, 0) - isnull(i.DiscountAmount, 0) - ISNULL(i.WriteoffAmount, 0) -- - ISNULL(i.RetainerAmount, 0)
			-- recalc RetainerAmount for 248945
			- (select isnull(sum(iab.Amount), 0) from tInvoiceAdvanceBill iab (nolock) where iab.InvoiceKey = i.InvoiceKey and isnull(FromAB, 0) = 0 )
		end as BilledAmount

		,(Select ISNULL(SUM(ca.Amount), 0)
			from tCheckAppl ca (nolock)
			inner join tCheck ch (nolock) on ch.CheckKey = ca.CheckKey
			Where ca.InvoiceKey = i.InvoiceKey and ch.PostingDate <= @AsOfDate
			and ch.Posted >= @PostStatus -- Added By Gil 1/29/08 to match spRptRunningBalance
			) + 
		 (Select ISNULL(Sum(Amount), 0) 
			from tInvoiceCredit ic (nolock) 
			inner join tInvoice cc (nolock) on cc.InvoiceKey = ic.CreditInvoiceKey
			Where ic.InvoiceKey = i.InvoiceKey AND
				cc.PostingDate <= @AsOfDate
			and cc.Posted >= @PostStatus -- Added By Gil 1/29/08	
				)
			-- Added for 248945
				+ 
		 (Select ISNULL(Sum(iab2.Amount), 0) 
			from tInvoiceAdvanceBill iab2 (nolock) 
			inner join tInvoice ab (nolock) on ab.InvoiceKey = iab2.AdvBillInvoiceKey
			Where iab2.InvoiceKey = i.InvoiceKey AND
				ab.PostingDate <= @AsOfDate
			and ab.Posted >= @PostStatus 	
			and isnull(iab2.FromAB, 0) = 1 
				) 
		as AppliedAmount
		,i.OfficeKey
		,ISNULL(p.AccountManager, c.AccountManagerKey) AS AccountManager
		,i.InvoiceKey
	FROM tInvoice i (nolock)
		LEFT JOIN tProject p (nolock) ON i.ProjectKey = p.ProjectKey 
		LEFT JOIN tCompany c (nolock) on i.ClientKey = c.CompanyKey
	Where
		i.CompanyKey = @CompanyKey 
	And	i.PostingDate <= @AsOfDate 
	And	i.InvoiceTotalAmount >= 0 
	--And	(@GLCompanyKey IS NULL OR ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey) 
	AND (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(i.GLCompanyKey, 0)) )
	And	(@ClientKey IS NULL OR i.ClientKey = @ClientKey)  -- Reduce # of records upfront
	And (@ParentClientKey IS NULL or (i.ClientKey = @ParentClientKey or i.ClientKey in (select CompanyKey from tCompany (nolock) where ParentCompanyKey = @ParentClientKey))) 
	And	(@ClassKey IS NULL OR i.ClassKey = @ClassKey)  -- Reduce # of records upfront
	And (@ProjectKey IS NULL OR i.ProjectKey = @ProjectKey)
	And (@ARAccountKey IS NULL OR ISNULL(i.ARAccountKey, 0) = @ARAccountKey) 
	And (@AccountManager IS NULL OR c.AccountManagerKey = @AccountManager)
	And i.Posted >= @PostStatus	
	AND (@MultiCurrency = 0
		OR isnull(i.CurrencyID, '') = isnull(@CurrencyID, '') )
			
	-- delete if over applied already
	delete #ARAging where BilledAmount < AppliedAmount

	-- Add Back any receipts applied to invoices later than the date window (step Invoice 2)
	Insert Into #ARAging
	(InvoiceKey, GLCompanyKey, Type, Posted, ClientKey, LoggedCompanyKey, InvoiceNumber, ClassKey, ProjectKey, ContactName, InvoiceDate, DueDate, PostingDate
	,BilledAmount, AppliedAmount, OfficeKey, AccountManager, RealInvoiceKey)
	Select
		 ch.CheckKey
	    ,ch.GLCompanyKey
		,'Payment'
		,ch.Posted
		,ch.ClientKey
		,@CompanyKey
		,RTRIM(ch.ReferenceNumber)
		,ch.ClassKey
		,i.ProjectKey
		,i.ContactName
		,ch.CheckDate
		,ch.CheckDate
		,ch.PostingDate
		,ca.Amount * -1
		,0
		,i.OfficeKey
		,ISNULL(p.AccountManager, c.AccountManagerKey) AS AccountManager
		,i.InvoiceKey
	From
		tCheck ch (nolock)
		inner join tCompany c (nolock) on ch.ClientKey = c.CompanyKey
		inner join tCheckAppl ca (nolock) on ch.CheckKey = ca.CheckKey
		inner join tInvoice i (nolock) on ca.InvoiceKey = i.InvoiceKey
		LEFT JOIN tProject p (nolock) ON i.ProjectKey = p.ProjectKey
	Where
		c.OwnerCompanyKey = @CompanyKey 
	And	i.PostingDate > @AsOfDate 
	And	ch.PostingDate <= @AsOfDate 
	And ca.Prepay = 0 -- you dont want the stuff applied as a prepayment as that should come off the other invoice.
	-- Removed the line below as this report can only be run for one section at a time now. the statement below causes the ar aging to be off
	--And i.PostingDate <= ch.PostingDate -- If the check posting date is before the invoice date, it is like a prepayment
	
	--And	(@GLCompanyKey IS NULL OR ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey) 
	AND (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(ch.GLCompanyKey, 0)) ) -- changed 1/16 i.GLCompanyKey to ch.GLCompanyKey
	And	(@ClientKey IS NULL OR ch.ClientKey = @ClientKey)  -- Reduce # of records upfront
	And (@ParentClientKey IS NULL or (ch.ClientKey = @ParentClientKey or ch.ClientKey in (select CompanyKey from tCompany (nolock) where ParentCompanyKey = @ParentClientKey))) 
	And	(@ClassKey IS NULL OR ch.ClassKey = @ClassKey)  -- Reduce # of records upfront
	And (@ProjectKey IS NULL OR i.ProjectKey = @ProjectKey) 
	And (@ARAccountKey IS NULL OR ISNULL(i.ARAccountKey, 0) = @ARAccountKey)
	And (@AccountManager IS NULL OR c.AccountManagerKey = @AccountManager)
	And ch.Posted >= @PostStatus	
	AND (@MultiCurrency = 0
		OR isnull(ch.CurrencyID, '') = isnull(@CurrencyID, '') )
			
	-- Add in any credits that are not fully applied yet
	Insert Into #ARAging
	(InvoiceKey, GLCompanyKey, Type, Posted, ClientKey, LoggedCompanyKey, InvoiceNumber, ClassKey, ProjectKey, ContactName, InvoiceDate, DueDate, PostingDate
	,BilledAmount, AppliedAmount, OfficeKey, AccountManager, RealInvoiceKey)
	Select
		i.InvoiceKey
		,i.GLCompanyKey
		,'Credit'
		,i.Posted
		,i.ClientKey
		,@CompanyKey
		,RTRIM(i.InvoiceNumber)
		,i.ClassKey
		,i.ProjectKey
		,i.ContactName
		,i.InvoiceDate
		,i.DueDate
		,i.PostingDate
		,ISNULL(i.InvoiceTotalAmount, 0) - isnull(i.DiscountAmount, 0) - isnull(i.RetainerAmount, 0) - ISNULL(i.WriteoffAmount, 0)
		,((Select ISNULL(Sum(Amount), 0) 
			from tCheckAppl ca (nolock) 
			inner join tCheck ch (nolock) on ch.CheckKey = ca.CheckKey
			Where ca.InvoiceKey = i.InvoiceKey AND
				ch.PostingDate <= @AsOfDate
			And ch.Posted >= @PostStatus	
			) +  -- Added by Gil
		 (Select ISNULL(Sum(Amount), 0) * -1 
			from tInvoiceCredit icd (nolock) 
			inner join tInvoice ic (nolock) on ic.InvoiceKey = icd.InvoiceKey
			Where icd.CreditInvoiceKey = i.InvoiceKey AND
				ic.PostingDate <= @AsOfDate
			And ic.Posted >= @PostStatus -- Added by Gil
				)) as AmountPaid
		,i.OfficeKey
		,ISNULL(p.AccountManager, c.AccountManagerKey) AS AccountManager
		,i.InvoiceKey
	From
		tInvoice i (nolock) 
		LEFT JOIN tProject p (nolock) ON i.ProjectKey = p.ProjectKey
		LEFT JOIN tCompany c (nolock) on i.ClientKey = c.CompanyKey
	Where
		i.CompanyKey = @CompanyKey 
	And	i.PostingDate <= @AsOfDate 
	And	i.InvoiceTotalAmount < 0 
	--And	(@GLCompanyKey IS NULL OR ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey) 
	AND (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(i.GLCompanyKey, 0)) )
	And	(@ClientKey IS NULL OR i.ClientKey = @ClientKey)  -- Reduce # of records upfront
	And (@ParentClientKey IS NULL or (i.ClientKey = @ParentClientKey or i.ClientKey in (select CompanyKey from tCompany (nolock) where ParentCompanyKey = @ParentClientKey))) 
	And	(@ClassKey IS NULL OR i.ClassKey = @ClassKey)  -- Reduce # of records upfront
	And (@ProjectKey IS NULL OR i.ProjectKey = @ProjectKey)
	And (@ARAccountKey IS NULL OR ISNULL(i.ARAccountKey, 0) = @ARAccountKey) 
	And (@AccountManager IS NULL OR c.AccountManagerKey = @AccountManager)
	And i.Posted >= @PostStatus	
	AND (@MultiCurrency = 0
		OR isnull(i.CurrencyID, '') = isnull(@CurrencyID, '') )
END
	
if @AdvBill = 1 And @AdvBillSalesTax = 1
BEGIN
	-- Add in any unapplied advance billings
	Insert Into #ARAging
	(InvoiceKey, GLCompanyKey, Type, Posted, ClientKey, LoggedCompanyKey, InvoiceNumber, ClassKey, ProjectKey, ContactName, InvoiceDate, DueDate, PostingDate
	,BilledAmount, AppliedAmount, OfficeKey, AccountManager, RealInvoiceKey)
	Select
		i.InvoiceKey
		,i.GLCompanyKey
		,'Open AB'
		,i.Posted
		,i.ClientKey
		,@CompanyKey
		,RTRIM(i.InvoiceNumber)
		,i.ClassKey
		,i.ProjectKey
		,i.ContactName
		,i.InvoiceDate
		,i.DueDate
		,i.PostingDate
		,(ISNULL(i.InvoiceTotalAmount, 0) - isnull(i.DiscountAmount, 0) - isnull(i.RetainerAmount, 0) - ISNULL(i.WriteoffAmount, 0))
		,(Select ISNULL(Sum(Amount), 0)
			from tInvoiceAdvanceBill abi (nolock) 
			inner join tInvoice inv (nolock) on abi.InvoiceKey = inv.InvoiceKey
			Where abi.AdvBillInvoiceKey = i.InvoiceKey and inv.PostingDate <= @AsOfDate
			And inv.Posted >= @PostStatus
			) as AmountPaid
		,i.OfficeKey
		,ISNULL(p.AccountManager, c.AccountManagerKey) AS AccountManager
		,i.InvoiceKey
	From
		tInvoice i (nolock) 
		LEFT JOIN tProject p (nolock) ON i.ProjectKey = p.ProjectKey
		LEFT JOIN tCompany c (nolock) on i.ClientKey = c.CompanyKey
	Where
		i.CompanyKey = @CompanyKey 
	And	i.PostingDate <= @AsOfDate 
	And	i.AdvanceBill = 1 
	--And	(@GLCompanyKey IS NULL OR ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey) 
	AND (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(i.GLCompanyKey, 0)) )
	And	(@ClientKey IS NULL OR i.ClientKey = @ClientKey)  -- Reduce # of records upfront
	And (@ParentClientKey IS NULL or (i.ClientKey = @ParentClientKey or i.ClientKey in (select CompanyKey from tCompany (nolock) where ParentCompanyKey = @ParentClientKey))) 
	And	(@ClassKey IS NULL OR i.ClassKey = @ClassKey)  -- Reduce # of records upfront
	And (@ProjectKey IS NULL OR i.ProjectKey = @ProjectKey)
	And (@ARAccountKey IS NULL OR ISNULL(i.ARAccountKey, 0) = @ARAccountKey) 
	And (@AccountManager IS NULL OR c.AccountManagerKey = @AccountManager)
	And i.Posted >= @PostStatus	
	AND (@MultiCurrency = 0
		OR isnull(i.CurrencyID, '') = isnull(@CurrencyID, '') )

	-- issue 253288 this is a patch to fix a data corruption situation
	-- an advance bill rec was over applied
	DELETE #ARAging WHERE AppliedAmount > BilledAmount

	 -- also insert the real invoices where they have adv bills applied but after the date.
	 Insert Into #ARAging
	 (InvoiceKey, GLCompanyKey, Type, Posted, ClientKey, LoggedCompanyKey, InvoiceNumber, ClassKey, ProjectKey, ContactName, InvoiceDate, DueDate, PostingDate
	 ,BilledAmount, AppliedAmount, OfficeKey, AccountManager, RealInvoiceKey)
	 
	 Select
	  i.InvoiceKey
	  ,i.GLCompanyKey
	  ,'Rev AB'
	  ,i.Posted
	  ,i.ClientKey
	  ,@CompanyKey
	  ,RTRIM(i.InvoiceNumber)
	  ,i.ClassKey
	  ,i.ProjectKey
	  ,i.ContactName
	  ,i.InvoiceDate
	  ,i.DueDate
	  ,i.PostingDate
	  ,0
	  ,abi.Amount
	  ,i.OfficeKey
	  ,ISNULL(p.AccountManager, c.AccountManagerKey) AS AccountManager
	  ,i.InvoiceKey
	 From tInvoice i (nolock) 
	  inner join tInvoiceAdvanceBill abi (nolock) on i.InvoiceKey = abi.InvoiceKey
	  inner join tInvoice ab (nolock) on ab.InvoiceKey = abi.AdvBillInvoiceKey
	  LEFT JOIN tProject p (nolock) ON i.ProjectKey = p.ProjectKey
	  LEFT JOIN tCompany c (nolock) on i.ClientKey = c.CompanyKey
	 Where i.CompanyKey = @CompanyKey 
	  and ab.PostingDate > @AsOfDate 
	  and i.PostingDate <= @AsOfDate
	  AND (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(i.GLCompanyKey, 0)) )
	  And (@ClientKey IS NULL OR i.ClientKey = @ClientKey)  -- Reduce # of records upfront
	  And (@ParentClientKey IS NULL or (i.ClientKey = @ParentClientKey or i.ClientKey in (select CompanyKey from tCompany (nolock) where ParentCompanyKey = @ParentClientKey))) 
	  And (@ClassKey IS NULL OR i.ClassKey = @ClassKey)  -- Reduce # of records upfront
	  And (@ProjectKey IS NULL OR i.ProjectKey = @ProjectKey)
	  And (@ARAccountKey IS NULL OR ISNULL(i.ARAccountKey, 0) = @ARAccountKey) 
	  And (@AccountManager IS NULL OR c.AccountManagerKey = @AccountManager)
	  And i.Posted >= @PostStatus
	  AND (@MultiCurrency = 0
		OR isnull(i.CurrencyID, '') = isnull(@CurrencyID, '') )
	  AND  isnull(abi.FromAB,0) = 0 


END

if @AdvBill = 1 And @AdvBillSalesTax = 0
BEGIN
	-- Add in any unapplied advance billings
	Insert Into #ARAging
	(InvoiceKey, GLCompanyKey, Type, Posted, ClientKey, LoggedCompanyKey, InvoiceNumber, ClassKey, ProjectKey, ContactName, InvoiceDate, DueDate, PostingDate
	,BilledAmount, AppliedAmount, OfficeKey, AccountManager, RealInvoiceKey)
	Select
		i.InvoiceKey
		,i.GLCompanyKey
		,'Open AB'
		,i.Posted
		,i.ClientKey
		,@CompanyKey
		,RTRIM(i.InvoiceNumber)
		,i.ClassKey
		,i.ProjectKey
		,i.ContactName
		,i.InvoiceDate
		,i.DueDate
		,i.PostingDate
		,(ISNULL(i.InvoiceTotalAmount, 0) - isnull(i.DiscountAmount, 0) - isnull(i.RetainerAmount, 0) - ISNULL(i.WriteoffAmount, 0))
		- isnull(i.SalesTaxAmount, 0) -- No Sales Taxes
		,ISNULL((
		    Select ISNULL(Sum(abi.Amount), 0)
			from tInvoiceAdvanceBill abi (nolock) 
			inner join tInvoice inv (nolock) on abi.InvoiceKey = inv.InvoiceKey
			Where abi.AdvBillInvoiceKey = i.InvoiceKey and inv.PostingDate <= @AsOfDate
			And inv.Posted >= @PostStatus
			), 0)
		 -- No Sales Taxes	 
		- ISNULL((
		    Select ISNULL(Sum(abit.Amount), 0)
			from tInvoiceAdvanceBillTax abit (nolock) 
			inner join tInvoice inv (nolock) on abit.InvoiceKey = inv.InvoiceKey
			Where abit.AdvBillInvoiceKey = i.InvoiceKey and inv.PostingDate <= @AsOfDate
			And inv.Posted >= @PostStatus
			), 0)
			as AmountPaid
		,i.OfficeKey
		,ISNULL(p.AccountManager, c.AccountManagerKey) AS AccountManager
		,i.InvoiceKey
	From
		tInvoice i (nolock) 
		LEFT JOIN tProject p (nolock) ON i.ProjectKey = p.ProjectKey
		LEFT JOIN tCompany c (nolock) on i.ClientKey = c.CompanyKey
	Where
		i.CompanyKey = @CompanyKey 
	And	i.PostingDate <= @AsOfDate 
	And	i.AdvanceBill = 1 
	--And	(@GLCompanyKey IS NULL OR ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey) 
	AND (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(i.GLCompanyKey, 0)) )
	And	(@ClientKey IS NULL OR i.ClientKey = @ClientKey)  -- Reduce # of records upfront
	And (@ParentClientKey IS NULL or (i.ClientKey = @ParentClientKey or i.ClientKey in (select CompanyKey from tCompany (nolock) where ParentCompanyKey = @ParentClientKey))) 
	And	(@ClassKey IS NULL OR i.ClassKey = @ClassKey)  -- Reduce # of records upfront
	And (@ProjectKey IS NULL OR i.ProjectKey = @ProjectKey) 
	And (@ARAccountKey IS NULL OR ISNULL(i.ARAccountKey, 0) = @ARAccountKey)
	And (@AccountManager IS NULL OR c.AccountManagerKey = @AccountManager)
	And i.Posted >= @PostStatus	
	AND (@MultiCurrency = 0
		OR isnull(i.CurrencyID, '') = isnull(@CurrencyID, '') )

	-- issue 253288 this is a patch to fix a data corruption situation
	-- an advance bill rec was over applied
	DELETE #ARAging WHERE AppliedAmount > BilledAmount

	 -- also insert the real invoices where they have adv bills applied but after the date.
	 Insert Into #ARAging
	 (InvoiceKey, GLCompanyKey, Type, Posted, ClientKey, LoggedCompanyKey, InvoiceNumber, ClassKey, ProjectKey, ContactName, InvoiceDate, DueDate, PostingDate
	 ,BilledAmount, AppliedAmount, OfficeKey, AccountManager, RealInvoiceKey)
	 
	 Select
	  i.InvoiceKey
	  ,i.GLCompanyKey
	  ,'Rev AB'
	  ,i.Posted
	  ,i.ClientKey
	  ,@CompanyKey
	  ,RTRIM(i.InvoiceNumber)
	  ,i.ClassKey
	  ,i.ProjectKey
	  ,i.ContactName
	  ,i.InvoiceDate
	  ,i.DueDate
	  ,i.PostingDate
	  ,0
	  ,abi.Amount
	   -- No Sales Taxes
	  - ISNULL((
		Select Sum(abit.Amount)
		From   tInvoiceAdvanceBillTax abit (nolock)
		Where  abit.InvoiceKey = i.InvoiceKey
	  ),0)
	  ,i.OfficeKey
	  ,ISNULL(p.AccountManager, c.AccountManagerKey) AS AccountManager
	  ,i.InvoiceKey
	 From tInvoice i (nolock) 
	  inner join tInvoiceAdvanceBill abi (nolock) on i.InvoiceKey = abi.InvoiceKey
	  inner join tInvoice ab (nolock) on ab.InvoiceKey = abi.AdvBillInvoiceKey
	  LEFT JOIN tProject p (nolock) ON i.ProjectKey = p.ProjectKey
	  LEFT JOIN tCompany c (nolock) on i.ClientKey = c.CompanyKey
	 Where i.CompanyKey = @CompanyKey 
	  and ab.PostingDate > @AsOfDate 
	  and i.PostingDate <= @AsOfDate
	  AND (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(i.GLCompanyKey, 0)) )
	  And (@ClientKey IS NULL OR i.ClientKey = @ClientKey)  -- Reduce # of records upfront
	  And (@ParentClientKey IS NULL or (i.ClientKey = @ParentClientKey or i.ClientKey in (select CompanyKey from tCompany (nolock) where ParentCompanyKey = @ParentClientKey))) 
	  And (@ClassKey IS NULL OR i.ClassKey = @ClassKey)  -- Reduce # of records upfront
	  And (@ProjectKey IS NULL OR i.ProjectKey = @ProjectKey)
	  And (@ARAccountKey IS NULL OR ISNULL(i.ARAccountKey, 0) = @ARAccountKey)
	  And (@AccountManager IS NULL OR c.AccountManagerKey = @AccountManager) 
	  And i.Posted >= @PostStatus
	  AND (@MultiCurrency = 0
		OR isnull(i.CurrencyID, '') = isnull(@CurrencyID, '') )
	  AND  isnull(abi.FromAB,0) = 0	-- because there is no reversal on the real invoice side when FromAB=1 (the reversal takes place with the AB invoice)

END

if @Receipts = 1 And @ProjectKey is Null
BEGIN
	-- Add Back any unapplied receipts from the client
	
	Insert Into #ARAging
	(InvoiceKey, GLCompanyKey, Type, Posted, ClientKey, LoggedCompanyKey, InvoiceNumber, ClassKey, ProjectKey, ContactName, InvoiceDate, DueDate, PostingDate
	,BilledAmount, AppliedAmount, OfficeKey, AccountManager, RealInvoiceKey)
	Select
	 ch.CheckKey
	 ,ch.GLCompanyKey
	,'Open Rec'
	,ch.Posted
	,ch.ClientKey
	,@CompanyKey
	,RTRIM(ch.ReferenceNumber)
	,ch.ClassKey
	,null -- no project
	,NULL  -- No Contact
	,ch.CheckDate
	,ch.CheckDate
	,ch.PostingDate
	,ch.CheckAmount * -1
	-- Need to include all applications regardless of invoice or sales account to deal with items directly applied to sales on a mixed payment
	,ISNULL((
		Select SUM(ca.Amount) * -1
		from tCheckAppl ca (nolock)
		Where ca.CheckKey = ch.CheckKey
		And   ca.InvoiceKey IS NULL  -- This will create discrepancy with spRptStatementRunningBalance
		),0)
	-- Issue 175324: Because of step Invoice 2, I think that we have to differentiate between payments and prepayments
	+ ISNULL((
	    Select SUM(ca.Amount) * -1
		from tCheckAppl ca (nolock)
		inner join tInvoice inv (nolock) on inv.InvoiceKey = ca.InvoiceKey
		Where ca.CheckKey = ch.CheckKey
		And   inv.Posted >= @PostStatus
		And   isnull(ca.Prepay, 0) = 0 -- Added for 175324
		--And   inv.PostingDate <= @AsOfDate  Removed this date because we always add back receipt amts applied after the window
		),0)
	-- Added for 175324
	+ ISNULL((
	    Select SUM(ca.Amount) * -1
		from tCheckAppl ca (nolock)
		inner join tInvoice inv (nolock) on inv.InvoiceKey = ca.InvoiceKey
		Where ca.CheckKey = ch.CheckKey
		And   inv.Posted >= @PostStatus
		And   isnull(ca.Prepay, 0) =1
		And   inv.PostingDate <= @AsOfDate 
		),0)		
	,null -- OfficeKey
	,''
	,null -- null InvoiceKey because we could have several invoices applied to the check
From
	tCheck ch (nolock)
	Inner Join tCompany c (nolock) On ch.ClientKey = c.CompanyKey
	-- join with a possible voided check, make sure that CheckKey <> VoidCheckKey on the void
	left Join tCheck void_ch (nolock) on ch.CheckKey = void_ch.VoidCheckKey and void_ch.CheckKey <> void_ch.VoidCheckKey 
Where
	c.OwnerCompanyKey = @CompanyKey 
And	ch.PostingDate <= @AsOfDate 
And	(isnull(ch.VoidCheckKey, 0) = 0
	Or
	void_ch.PostingDate > @AsOfDate
	)
--And	(@GLCompanyKey IS NULL OR ISNULL(ch.GLCompanyKey, 0) = @GLCompanyKey)
AND (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(ch.GLCompanyKey, 0)) ) 
And	(@ClientKey IS NULL OR ch.ClientKey = @ClientKey)  -- Reduce # of records upfront
And (@ParentClientKey IS NULL or (ch.ClientKey = @ParentClientKey or ch.ClientKey in (select CompanyKey from tCompany (nolock) where ParentCompanyKey = @ParentClientKey))) 
And	(@ClassKey IS NULL OR ch.ClassKey = @ClassKey)  -- Reduce # of records upfront
And (@AccountManager IS NULL OR c.AccountManagerKey = @AccountManager)
And ch.Posted >= @PostStatus	
AND (@MultiCurrency = 0
		OR isnull(ch.CurrencyID, '') = isnull(@CurrencyID, '') )


	
END
	
-- If the user selected ALL Companies and we restrict
-- we need to look up into tUserGLCompanyAccess
IF @GLCompanyKey =-1 AND @RestrictToGLCompany = 1
begin
	update #ARAging set GLCompanyKey = isnull(GLCompanyKey, 0)

	-- this does not delete null GLCompanyKey
	delete #ARAging
	where  GLCompanyKey not in (select GLCompanyKey from tUserGLCompanyAccess where UserKey = @UserKey) 
end

-- Only keep open amounts
DELETE #ARAging 
WHERE  #ARAging.BilledAmount - #ARAging.AppliedAmount = 0


-- Multiply by -1 or 1
-- For client statements where you want to show what the client owes us
-- Advance Bill should show as negative
-- Real invoices should show as positive
-- Otherwise they would both show as postive doubling in effect what the client owes

-- For AR Aging
-- Advance Bill should show as positive

UPDATE #ARAging
SET    BilledAmount = cast(@AdvBillMultiplier as money) * BilledAmount
		,AppliedAmount = cast(@AdvBillMultiplier as money) *  AppliedAmount
WHERE  Type = 'Open AB'		


IF @RollUpMatching > 0 
BEGIN
	Insert Into #ARAging
	(InvoiceKey, Type, Posted, ClientKey, LoggedCompanyKey, InvoiceNumber, InvoiceDate, DueDate, PostingDate, BilledAmount, AppliedAmount, Action)
	Select
	MAX(InvoiceKey), Type, MAX(Posted), ClientKey, LoggedCompanyKey, InvoiceNumber, MAX(InvoiceDate), MAX(DueDate), MAX(PostingDate), SUM(BilledAmount), SUM(AppliedAmount), 1
	
	From #ARAging
	Group By
	Type, ClientKey, LoggedCompanyKey, InvoiceNumber

	Delete #ARAging Where Action is null

END

-- If the report is grouped by project, make sure that there is no difference between NULL and 0 
update #ARAging  set ProjectKey = NULL where ProjectKey = 0


IF @SummaryOnly = 1
BEGIN
	
	IF @AgingDateOption = 1		-- Using InvoiceDate
	BEGIN
		IF @OlderThan > 0 --Remove records that are not older than @OlderThan
			DELETE	#ARAging
			WHERE	DATEDIFF(d, InvoiceDate, @AsOfDate) <= @OlderThan

		SELECT #ARAging.ClientKey
				,RTRIM(ISNULL(cl.CustomerID, '')) + RTRIM(ISNULL(' - ' + cl.CompanyName, 'NO NAME')) as ClientFullName 
				,SUM(BilledAmount - AppliedAmount) as NetAmount
				,SUM(CASE WHEN DATEDIFF(d, InvoiceDate, @AsOfDate) <= @Days1 
					THEN BilledAmount - AppliedAmount ELSE 0 END) as Period0
				,SUM(CASE WHEN DATEDIFF(d, InvoiceDate, @AsOfDate) > @Days1 and DATEDIFF(d, InvoiceDate, @AsOfDate) <= @Days2 
					THEN BilledAmount - AppliedAmount ELSE 0 END) as Period1
				,SUM(CASE WHEN DATEDIFF(d, InvoiceDate, @AsOfDate) > @Days2 and DATEDIFF(d, InvoiceDate, @AsOfDate) <= @Days3 
					THEN BilledAmount - AppliedAmount ELSE 0 END) as Period2
				,SUM(CASE WHEN DATEDIFF(d, InvoiceDate, @AsOfDate) > @Days3 
					THEN BilledAmount - AppliedAmount ELSE 0 END) as Period3
		FROM	#ARAging 
		inner join tCompany cl (nolock) on #ARAging.ClientKey = cl.CompanyKey
		GROUP BY  #ARAging.ClientKey, RTRIM(ISNULL(cl.CustomerID, '')) + RTRIM(ISNULL(' - ' + cl.CompanyName, 'NO NAME'))
		ORDER BY  RTRIM(ISNULL(cl.CustomerID, '')) + RTRIM(ISNULL(' - ' + cl.CompanyName, 'NO NAME'))

	END
	ELSE IF @AgingDateOption = 2		-- Using PostingDate
	BEGIN
		IF @OlderThan > 0 --Remove records that are not older than @OlderThan
			DELETE	#ARAging
			WHERE	DATEDIFF(d, PostingDate, @AsOfDate) <= @OlderThan
	
		SELECT #ARAging.ClientKey
				,RTRIM(ISNULL(cl.CustomerID, '')) + RTRIM(ISNULL(' - ' + cl.CompanyName, 'NO NAME')) as ClientFullName 
				,SUM(BilledAmount - AppliedAmount) as NetAmount
				,SUM(CASE WHEN DATEDIFF(d, PostingDate, @AsOfDate) <= @Days1 
					THEN BilledAmount - AppliedAmount ELSE 0 END) as Period0
				,SUM(CASE WHEN DATEDIFF(d, PostingDate, @AsOfDate) > @Days1 and DATEDIFF(d, PostingDate, @AsOfDate) <= @Days2 
					THEN BilledAmount - AppliedAmount ELSE 0 END) as Period1
				,SUM(CASE WHEN DATEDIFF(d, PostingDate, @AsOfDate) > @Days2 and DATEDIFF(d, PostingDate, @AsOfDate) <= @Days3 
					THEN BilledAmount - AppliedAmount ELSE 0 END) as Period2
				,SUM(CASE WHEN DATEDIFF(d, PostingDate, @AsOfDate) > @Days3 
					THEN BilledAmount - AppliedAmount ELSE 0 END) as Period3
		FROM	#ARAging 
		inner join tCompany cl (nolock) on #ARAging.ClientKey = cl.CompanyKey
		GROUP BY  #ARAging.ClientKey, RTRIM(ISNULL(cl.CustomerID, '')) + RTRIM(ISNULL(' - ' + cl.CompanyName, 'NO NAME'))
		ORDER BY  RTRIM(ISNULL(cl.CustomerID, '')) + RTRIM(ISNULL(' - ' + cl.CompanyName, 'NO NAME'))

	END
	ELSE		-- Using Due Date
	BEGIN
		IF @OlderThan > 0 --Remove records that are not older than @OlderThan
			DELETE	#ARAging
			WHERE	DATEDIFF(d, DueDate, @AsOfDate) <= @OlderThan

		SELECT #ARAging.ClientKey
				,RTRIM(ISNULL(cl.CustomerID, '')) + RTRIM(ISNULL(' - ' + cl.CompanyName, 'NO NAME')) as ClientFullName 
				,SUM(BilledAmount - AppliedAmount) as NetAmount
				,SUM(CASE WHEN DATEDIFF(d, DueDate, @AsOfDate) <= @Days1 
					THEN BilledAmount - AppliedAmount ELSE 0 END) as Period0
				,SUM(CASE WHEN DATEDIFF(d, DueDate, @AsOfDate) > @Days1 and DATEDIFF(d, DueDate, @AsOfDate) <= @Days2 
					THEN BilledAmount - AppliedAmount ELSE 0 END) as Period1
				,SUM(CASE WHEN DATEDIFF(d, DueDate, @AsOfDate) > @Days2 and DATEDIFF(d, DueDate, @AsOfDate) <= @Days3 
					THEN BilledAmount - AppliedAmount ELSE 0 END) as Period2
				,SUM(CASE WHEN DATEDIFF(d, DueDate, @AsOfDate) > @Days3 
					THEN BilledAmount - AppliedAmount ELSE 0 END) as Period3
		FROM	#ARAging 
		inner join tCompany cl (nolock) on #ARAging.ClientKey = cl.CompanyKey
		GROUP BY  #ARAging.ClientKey, RTRIM(ISNULL(cl.CustomerID, '')) + RTRIM(ISNULL(' - ' + cl.CompanyName, 'NO NAME'))
		ORDER BY  RTRIM(ISNULL(cl.CustomerID, '')) + RTRIM(ISNULL(' - ' + cl.CompanyName, 'NO NAME'))
	END	
END
ELSE
BEGIN
	IF @AgingDateOption = 1		-- Using InvoiceDate
	BEGIN
		IF @OlderThan > 0 --Remove records that are not older than @OlderThan
			DELETE	#ARAging
			WHERE	DATEDIFF(d, InvoiceDate, @AsOfDate) <= @OlderThan

		Select #ARAging.*
		,RTRIM(ISNULL(cl.CustomerID, 'NO ID')) as ClientID
		,RTRIM(ISNULL(cl.CompanyName, 'NO NAME')) as ClientName
		,RTRIM(ISNULL(cl.CustomerID, '')) + RTRIM(ISNULL(' - ' + cl.CompanyName, 'NO NAME')) as ClientFullName 
		,BilledAmount - AppliedAmount as NetAmount
		,CASE WHEN DATEDIFF(d, InvoiceDate, @AsOfDate) <= @Days1 
			THEN BilledAmount - AppliedAmount ELSE 0 END as Period0
		,CASE WHEN DATEDIFF(d, InvoiceDate, @AsOfDate) > @Days1 and DATEDIFF(d, InvoiceDate, @AsOfDate) <= @Days2 
			THEN BilledAmount - AppliedAmount ELSE 0 END as Period1
		,CASE WHEN DATEDIFF(d, InvoiceDate, @AsOfDate) > @Days2 and DATEDIFF(d, InvoiceDate, @AsOfDate) <= @Days3 
			THEN BilledAmount - AppliedAmount ELSE 0 END as Period2
		,CASE WHEN DATEDIFF(d, InvoiceDate, @AsOfDate) > @Days3 
			THEN BilledAmount - AppliedAmount ELSE 0 END as Period3
		,DATEDIFF(d, InvoiceDate, @AsOfDate) AS Days
		,BilledAmount - AppliedAmount as OpenAmount
		,c.CompanyName
		,ad.Address1
		,ad.Address2
		,ad.Address3
		,ad.City
		,ad.State
		,ad.PostalCode
		,ad.Country
		,cl.CompanyName as BCompanyName
		,case when cl.BillingAddressKey IS NOT NULL then bad.Address1
		else cad.Address1 end as BAddress1,	
		case when cl.BillingAddressKey IS NOT NULL then bad.Address2
		else cad.Address2 end as BAddress2,	
		case when cl.BillingAddressKey IS NOT NULL then bad.Address3
		else cad.Address3 end as BAddress3,
		case when cl.BillingAddressKey IS NOT NULL then bad.City
		else cad.City end as BCity,
		case when cl.BillingAddressKey IS NOT NULL then bad.State
		else cad.State end as BState,	
		case when cl.BillingAddressKey IS NOT NULL then bad.PostalCode
		else cad.PostalCode end as BPostalCode,
		case when cl.BillingAddressKey IS NOT NULL then bad.Country
		else cad.Country end as BCountry

		,ISNULL(o.OfficeName, 'NO OFFICE') AS OfficeName
		,ISNULL(am.FirstName + ' ' + am.LastName, 'NO ACCOUNT MANAGER') AS AccountManagerName 
		,p.ProjectNumber
		,cp.ProductName
		,cd.DivisionName
		
		from #ARAging 
		inner join tCompany cl (nolock) on #ARAging.ClientKey = cl.CompanyKey
		inner join tCompany c (nolock) on #ARAging.LoggedCompanyKey = c.CompanyKey
		left outer join tAddress ad (nolock) on c.DefaultAddressKey = ad.AddressKey
		left outer join tAddress cad (nolock) on cl.DefaultAddressKey = cad.AddressKey
		left outer join tAddress bad (nolock) on cl.BillingAddressKey = bad.AddressKey
		left outer join tOffice o (NOLOCK) on #ARAging.OfficeKey = o.OfficeKey 
		left outer join tUser am (NOLOCK) on #ARAging.AccountManager = am.UserKey
		left outer join tProject p (nolock) on #ARAging.ProjectKey = p.ProjectKey
		LEFT JOIN tClientProduct cp (nolock) ON p.ClientProductKey = cp.ClientProductKey
		LEFT JOIN tClientDivision cd (nolock) ON p.ClientDivisionKey = cd.ClientDivisionKey
		Order By
			ISNULL(cl.CustomerID, 'NO ID'), #ARAging.DueDate, #ARAging.InvoiceNumber 
	END
	ELSE IF @AgingDateOption = 2		-- Using PostingDate
	BEGIN
		IF @OlderThan > 0 --Remove records that are not older than @OlderThan
			DELETE	#ARAging
			WHERE	DATEDIFF(d, PostingDate, @AsOfDate) <= @OlderThan

		Select #ARAging.*
		,RTRIM(ISNULL(cl.CustomerID, 'NO ID')) as ClientID
		,RTRIM(ISNULL(cl.CompanyName, 'NO NAME')) as ClientName
		,RTRIM(ISNULL(cl.CustomerID, '')) + RTRIM(ISNULL(' - ' + cl.CompanyName, 'NO NAME')) as ClientFullName 
		,BilledAmount - AppliedAmount as NetAmount
		,CASE WHEN DATEDIFF(d, PostingDate, @AsOfDate) <= @Days1 
			THEN BilledAmount - AppliedAmount ELSE 0 END as Period0
		,CASE WHEN DATEDIFF(d, PostingDate, @AsOfDate) > @Days1 and DATEDIFF(d, PostingDate, @AsOfDate) <= @Days2 
			THEN BilledAmount - AppliedAmount ELSE 0 END as Period1
		,CASE WHEN DATEDIFF(d, PostingDate, @AsOfDate) > @Days2 and DATEDIFF(d, PostingDate, @AsOfDate) <= @Days3 
			THEN BilledAmount - AppliedAmount ELSE 0 END as Period2
		,CASE WHEN DATEDIFF(d, PostingDate, @AsOfDate) > @Days3 
			THEN BilledAmount - AppliedAmount ELSE 0 END as Period3
		,DATEDIFF(d, PostingDate, @AsOfDate) AS Days
		,BilledAmount - AppliedAmount as OpenAmount
		,c.CompanyName
		,ad.Address1
		,ad.Address2
		,ad.Address3
		,ad.City
		,ad.State
		,ad.PostalCode
		,ad.Country
		,cl.CompanyName as BCompanyName
		,case when cl.BillingAddressKey IS NOT NULL then bad.Address1
		else cad.Address1 end as BAddress1,	
		case when cl.BillingAddressKey IS NOT NULL then bad.Address2
		else cad.Address2 end as BAddress2,	
		case when cl.BillingAddressKey IS NOT NULL then bad.Address3
		else cad.Address3 end as BAddress3,
		case when cl.BillingAddressKey IS NOT NULL then bad.City
		else cad.City end as BCity,
		case when cl.BillingAddressKey IS NOT NULL then bad.State
		else cad.State end as BState,	
		case when cl.BillingAddressKey IS NOT NULL then bad.PostalCode
		else cad.PostalCode end as BPostalCode,
		case when cl.BillingAddressKey IS NOT NULL then bad.Country
		else cad.Country end as BCountry

		,ISNULL(o.OfficeName, 'NO OFFICE') AS OfficeName
		,ISNULL(am.FirstName + ' ' + am.LastName, 'NO ACCOUNT MANAGER') AS AccountManagerName 
		,p.ProjectNumber
		,cp.ProductName
		,cd.DivisionName

		from #ARAging 
		inner join tCompany cl (nolock) on #ARAging.ClientKey = cl.CompanyKey
		inner join tCompany c (nolock) on #ARAging.LoggedCompanyKey = c.CompanyKey
		left outer join tAddress ad (nolock) on c.DefaultAddressKey = ad.AddressKey
		left outer join tAddress cad (nolock) on cl.DefaultAddressKey = cad.AddressKey
		left outer join tAddress bad (nolock) on cl.BillingAddressKey = bad.AddressKey
		left outer join tOffice o (nolock) on #ARAging.OfficeKey = o.OfficeKey
		left outer join tUser am (NOLOCK) on #ARAging.AccountManager = am.UserKey
		left outer join tProject p (nolock) on #ARAging.ProjectKey = p.ProjectKey
		LEFT JOIN tClientProduct cp (nolock) ON p.ClientProductKey = cp.ClientProductKey
		LEFT JOIN tClientDivision cd (nolock) ON p.ClientDivisionKey = cd.ClientDivisionKey
		Order By
			ISNULL(cl.CustomerID, 'NO ID'), #ARAging.DueDate, #ARAging.InvoiceNumber
	END
	ELSE		-- Using Due Date
	BEGIN
		IF @OlderThan > 0 --Remove records that are not older than @OlderThan
			DELETE	#ARAging
			WHERE	DATEDIFF(d, DueDate, @AsOfDate) <= @OlderThan

		Select #ARAging.*
		,RTRIM(ISNULL(cl.CustomerID, 'NO ID')) as ClientID
		,RTRIM(ISNULL(cl.CompanyName, 'NO NAME')) as ClientName
		,RTRIM(ISNULL(cl.CustomerID, '')) + RTRIM(ISNULL(' - ' + cl.CompanyName, 'NO NAME')) as ClientFullName 
			,BilledAmount - AppliedAmount as NetAmount
		,CASE WHEN DATEDIFF(d, DueDate, @AsOfDate) <= @Days1 
			THEN BilledAmount - AppliedAmount ELSE 0 END as Period0
		,CASE WHEN DATEDIFF(d, DueDate, @AsOfDate) > @Days1 and DATEDIFF(d, DueDate, @AsOfDate) <= @Days2 
			THEN BilledAmount - AppliedAmount ELSE 0 END as Period1
		,CASE WHEN DATEDIFF(d, DueDate, @AsOfDate) > @Days2 and DATEDIFF(d, DueDate, @AsOfDate) <= @Days3 
			THEN BilledAmount - AppliedAmount ELSE 0 END as Period2
		,CASE WHEN DATEDIFF(d, DueDate, @AsOfDate) > @Days3 
			THEN BilledAmount - AppliedAmount ELSE 0 END as Period3
		,DATEDIFF(d, DueDate, @AsOfDate) AS Days
		,BilledAmount - AppliedAmount as OpenAmount
		,c.CompanyName
		,ad.Address1
		,ad.Address2
		,ad.Address3
		,ad.City
		,ad.State
		,ad.PostalCode
		,ad.Country
		,cl.CompanyName as BCompanyName
		,case when cl.BillingAddressKey IS NOT NULL then bad.Address1
		else cad.Address1 end as BAddress1,	
		case when cl.BillingAddressKey IS NOT NULL then bad.Address2
		else cad.Address2 end as BAddress2,	
		case when cl.BillingAddressKey IS NOT NULL then bad.Address3
		else cad.Address3 end as BAddress3,
		case when cl.BillingAddressKey IS NOT NULL then bad.City
		else cad.City end as BCity,
		case when cl.BillingAddressKey IS NOT NULL then bad.State
		else cad.State end as BState,	
		case when cl.BillingAddressKey IS NOT NULL then bad.PostalCode
		else cad.PostalCode end as BPostalCode,
		case when cl.BillingAddressKey IS NOT NULL then bad.Country
		else cad.Country end as BCountry

		,ISNULL(o.OfficeName, 'NO OFFICE') AS OfficeName
		,ISNULL(am.FirstName + ' ' + am.LastName, 'NO ACCOUNT MANAGER') AS AccountManagerName 
		,p.ProjectNumber
		,cp.ProductName
		,cd.DivisionName

		from #ARAging 
		inner join tCompany cl (nolock) on #ARAging.ClientKey = cl.CompanyKey
		inner join tCompany c (nolock) on #ARAging.LoggedCompanyKey = c.CompanyKey
		left outer join tAddress ad (nolock) on c.DefaultAddressKey = ad.AddressKey
		left outer join tAddress cad (nolock) on cl.DefaultAddressKey = cad.AddressKey
		left outer join tAddress bad (nolock) on cl.BillingAddressKey = bad.AddressKey
		left outer join tOffice o (nolock) on #ARAging.OfficeKey = o.OfficeKey
		left outer join tUser am (NOLOCK) on #ARAging.AccountManager = am.UserKey
		left outer join tProject p (nolock) on #ARAging.ProjectKey = p.ProjectKey
		LEFT JOIN tClientProduct cp (nolock) ON p.ClientProductKey = cp.ClientProductKey
		LEFT JOIN tClientDivision cd (nolock) ON p.ClientDivisionKey = cd.ClientDivisionKey
		Order By
			ISNULL(cl.CustomerID, 'NO ID'), #ARAging.DueDate, #ARAging.InvoiceNumber
	END

END
GO
