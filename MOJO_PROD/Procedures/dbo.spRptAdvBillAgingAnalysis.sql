USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptAdvBillAgingAnalysis]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRptAdvBillAgingAnalysis]
(
	@CompanyKey int,
	@AsOfDate smalldatetime,
	@ShowDetails tinyint = 0,
	@ClientKey int = null,
	@ClassKey int = null,
	@ProjectKey int = null, -- ProjectKey on header
	@PostStatus tinyint = 0,
	@GLCompanyKey int = NULL -- -1 All, 0 NULL, >0 valid GLCompany
	 -- ONLY Include Unapplied Advanced Billings
)
AS --Encrypt
SET NOCOUNT ON

-- This sp is used to help figure out adv bill aging issue. only really used by support at the moment
 
-- Create table rather than select into to reduce time locking tempdb, 17000 records my be read below
CREATE TABLE #ARAging
	(InvoiceKey INT NULL -- will hold InvoiceKey if Type = 'Invoice', 'Credit', 'Open AB' CheckKey if Type = 'Payment', 'Open Rec'
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
	,RealInvoiceKey INT NULL) -- to determine projects 


	-- Add in any unapplied advance billings
	Insert Into #ARAging
	(InvoiceKey, Type, Posted, ClientKey, LoggedCompanyKey, InvoiceNumber, ClassKey, ProjectKey, ContactName, InvoiceDate, DueDate, PostingDate
	,BilledAmount, AppliedAmount, OfficeKey, AccountManager, RealInvoiceKey)
	Select
		i.InvoiceKey
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
		,ISNULL(i.TotalNonTaxAmount, 0)
		,(Select ISNULL(Sum(Amount), 0)
			from tInvoiceAdvanceBill abi (nolock) 
			inner join tInvoice inv (nolock) on abi.InvoiceKey = inv.InvoiceKey
			Where abi.AdvBillInvoiceKey = i.InvoiceKey and inv.PostingDate <= @AsOfDate
			And inv.Posted >= @PostStatus
			) - 
			(Select ISNULL(Sum(Amount), 0)
			from tInvoiceAdvanceBillTax abi (nolock) 
			inner join tInvoice inv (nolock) on abi.InvoiceKey = inv.InvoiceKey
			Where abi.AdvBillInvoiceKey = i.InvoiceKey and inv.PostingDate <= @AsOfDate
			And inv.Posted >= @PostStatus)  as AmountPaid
		,i.OfficeKey
		,p.AccountManager
		,i.InvoiceKey
	From
		tInvoice i (nolock) 
		LEFT JOIN tProject p (nolock) ON i.ProjectKey = p.ProjectKey
	Where
		i.CompanyKey = @CompanyKey 
	And	i.PostingDate <= @AsOfDate 
	And	i.AdvanceBill = 1 
	--And	(@GLCompanyKey IS NULL OR ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey) 
	AND (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(i.GLCompanyKey, 0)) )
	And	(@ClientKey IS NULL OR i.ClientKey = @ClientKey)  -- Reduce # of records upfront
	And	(@ClassKey IS NULL OR i.ClassKey = @ClassKey)  -- Reduce # of records upfront
	And (@ProjectKey IS NULL OR i.ProjectKey = @ProjectKey) 
	And i.Posted >= @PostStatus	

	 -- also insert the real invoices where they have adv bills applied but after the date.
	 Insert Into #ARAging
	 (InvoiceKey, Type, Posted, ClientKey, LoggedCompanyKey, InvoiceNumber, ClassKey, ProjectKey, ContactName, InvoiceDate, DueDate, PostingDate
	 ,BilledAmount, AppliedAmount, OfficeKey, AccountManager, RealInvoiceKey)
	 
	 Select
	  i.InvoiceKey
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
	  ,abi.Amount - 
			(Select ISNULL(Sum(Amount), 0)
			from tInvoiceAdvanceBillTax abit (nolock) 
			Where abi.InvoiceKey = i.InvoiceKey and abi.AdvBillInvoiceKey = abit.AdvBillInvoiceKey)
	  ,i.OfficeKey
	  ,p.AccountManager
	  ,i.InvoiceKey
	 From tInvoice i (nolock) 
	  inner join tInvoiceAdvanceBill abi (nolock) on i.InvoiceKey = abi.InvoiceKey
	  inner join tInvoice ab (nolock) on ab.InvoiceKey = abi.AdvBillInvoiceKey
	  LEFT JOIN tProject p (nolock) ON i.ProjectKey = p.ProjectKey
	 Where i.CompanyKey = @CompanyKey 
	  and ab.PostingDate > @AsOfDate 
	  and i.PostingDate <= @AsOfDate
	  AND (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(i.GLCompanyKey, 0)) )
	  And (@ClientKey IS NULL OR i.ClientKey = @ClientKey)  -- Reduce # of records upfront
	  And (@ClassKey IS NULL OR i.ClassKey = @ClassKey)  -- Reduce # of records upfront
	  And (@ProjectKey IS NULL OR i.ProjectKey = @ProjectKey) 
	  And i.Posted >= @PostStatus

		
-- Only keep open amounts
--DELETE #ARAging 
--WHERE  #ARAging.BilledAmount - #ARAging.AppliedAmount = 0

		Declare @Aging money, @GL money

		Select @Aging = Sum(BilledAmount - AppliedAmount) from #ARAging
		select @GL = Sum(Credit - Debit) from tTransaction Where GLAccountKey = 23102 and TransactionDate <= @AsOfDate
		
		Select @Aging - @GL as Difference, @Aging as Aging, @GL as GL
		if @ShowDetails = 0
			return
		--Select Sum(BilledAmount - AppliedAmount) as OpenAmount, Sum(BilledAmount) as BilledAmount, Sum(AppliedAmount) as AppliedAmount
		--from #ARAging 

		Select InvoiceKey, Sum(BilledAmount - AppliedAmount) as OpenAmount, Sum(BilledAmount) as BilledAmount, Sum(AppliedAmount) as AppliedAmount
		from #ARAging Group By InvoiceKey
		
		--select Sum(Credit - Debit) from tTransaction Where GLAccountKey = 23102 and TransactionDate <= @AsOfDate
		select * from tTransaction Where GLAccountKey = 23102 and TransactionDate = @AsOfDate
		Select * from tInvoice Where PostingDate = @ASOfDate and CompanyKey = @CompanyKey
		Select il.* from tInvoice i inner join tInvoiceLine il on i.InvoiceKey = il.InvoiceKey Where PostingDate = @ASOfDate and CompanyKey = @CompanyKey
			Order By i.InvoiceKey
			
		Select ca.* from tCheckAppl ca inner join tCheck ch on ch.CheckKey = ca.CheckKey inner join tCompany c on c.CompanyKey = ch.ClientKey
		Where ch.PostingDate = @AsOfDate
GO
