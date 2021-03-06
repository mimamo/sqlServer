USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptGLPrePost]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptGLPrePost]

	(
		@CompanyKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@VendorInvoices tinyint,
		@Payments tinyint,
		@ClientInvoices tinyint,
		@Receipts tinyint,
		@JournalEntries tinyint,
		@CreditCardCharges tinyint,
		@GLCompanyKey int = -1,
		@UserKey int = null
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 06/21/07 GHL 8.5    Modifications for new gl posting routines
|| 07/05/07 GHL 8.5    Validate office and department on lines only
|| 09/17/07 GHL 8.5    Added overhead
|| 09/20/07 GHL 8.437 (13198) Added AccountFullName to eliminate grouping errors on report rptGLPreposting    
|| 02/26/09 GHL 10.019 Modified temp table for cash basis 
|| 03/11/10 RLB 10.520 (39446) removed required check number when pulling in payments
|| 06/03/10 RLB 10.530 adding GLCompanyKey to filter on this report   
|| 06/29/10 RLB 10.532 (70244)Added Project Full name, Project number, Client ID and Clent Name to the report 
|| 10/13/11 GHL 10.549 Added credit cards
|| 04/27/12 GHL 10.555 Added UserKey for tUserGLCompanyAccess       
|| 07/03/12 GHL 10.557  Added tTransaction.ICTGLCompanyKey 
|| 08/21/12 RLB 10.559  (152045) Fix for missing Vendor Name when voucher had multiple gl companies  
|| 06/24/13 GHL 10.569 (182080) Using now #tTransaction.GPFlag (general purpose flag) to flag missing offices and depts 
|| 07/15/13 WDF 10.570  (176497) Added VoucherID
|| 08/05/13 GHL 10.571 Added Multi Currency stuff
*/

Declare @CurKey int, @PrePost int, @CreateTemp int

If @StartDate is null
	Select @StartDate = DATEADD(yyyy, -10, GETDATE())
	
If @EndDate is null
	Select @EndDate = DATEADD(yyyy, 10, GETDATE())

Select @PrePost = 1		-- Do not really post
	  ,@CreateTemp = 0	-- Do not create temp tables in GL post routines

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

CREATE TABLE #tTransaction (
			-- Copied from tTransaction
			CompanyKey int NULL ,
			DateCreated smalldatetime NULL ,
			TransactionDate smalldatetime NULL ,
			Entity varchar (50) NULL ,
			EntityKey int NULL ,
			Reference varchar (100) NULL ,
			GLAccountKey int NULL ,
			Debit money NULL ,
			Credit money NULL ,
			ClassKey int NULL ,
			Memo varchar (500) NULL ,
			PostMonth int NULL,
			PostYear int NULL,
			PostSide char (1) NULL ,
			ClientKey int NULL ,
			ProjectKey int NULL ,
			SourceCompanyKey int NULL ,
			DepositKey int NULL ,
			GLCompanyKey int NULL ,
			OfficeKey int NULL ,
			DepartmentKey int NULL ,
			DetailLineKey int NULL ,
			Section int NULL,
			Overhead tinyint NULL,
			ICTGLCompanyKey int null,
			
			CurrencyID varchar(10) null,	-- 4 lines added for multicurrency
			ExchangeRate decimal(24,7) null,
			HDebit money null,
			HCredit money null

			-- our work space
			,GLValid int null
			,GLAccountErrRet int null
			,GPFlag int null -- General purpose flag
			
			,TempTranLineKey int IDENTITY(1,1) NOT NULL
			)	 
	
-- Vendor Invoices ***************************************************************************
if @VendorInvoices = 1
BEGIN
Select @CurKey = -1
While 1=1
	BEGIN
		Select @CurKey = Min(VoucherKey)
			from tVoucher (nolock) 
			Where CompanyKey = @CompanyKey and
				PostingDate >= @StartDate and
				PostingDate <= @EndDate and
				Status = 4 and Posted = 0 and isnull(CreditCard, 0) = 0 
				--and (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(GLCompanyKey, 0)) ) 
				
				AND (-- case when @GLCompanyKey = ALL
					(@GLCompanyKey = -1 AND 
						(
						@RestrictToGLCompany = 0 OR 
						(GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
						)
					)
					--case when @GLCompanyKey = X or Blank(0)
					 OR (@GLCompanyKey != -1 AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
				)

				and VoucherKey > @CurKey
		if @CurKey is null
			Break
			
		exec spGLPostVoucher @CompanyKey, @CurKey, @PrePost, @CreateTemp
	END
END

-- Credit Cards ***************************************************************************
if @CreditCardCharges = 1
BEGIN
Select @CurKey = -1
While 1=1
	BEGIN
		Select @CurKey = Min(VoucherKey)
			from tVoucher (nolock) 
			Where CompanyKey = @CompanyKey and
				PostingDate >= @StartDate and
				PostingDate <= @EndDate and
				Status = 4 and Posted = 0 and isnull(CreditCard, 0) = 1 
				--and (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(GLCompanyKey, 0)) ) 
				
				AND (-- case when @GLCompanyKey = ALL
					(@GLCompanyKey = -1 AND 
						(
						@RestrictToGLCompany = 0 OR 
						(GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
						)
					)
					--case when @GLCompanyKey = X or Blank(0)
					 OR (@GLCompanyKey != -1 AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
				)

				and VoucherKey > @CurKey
		if @CurKey is null
			Break
			
		exec spGLPostVoucher @CompanyKey, @CurKey, @PrePost, @CreateTemp
	END
END

-- Vendor Payments ***************************************************************************
if @Payments = 1
BEGIN
Select @CurKey = -1
While 1=1
	BEGIN
		Select @CurKey = Min(PaymentKey)
			from tPayment (nolock) 
			Where CompanyKey = @CompanyKey and
				PostingDate >= @StartDate and
				PostingDate <= @EndDate and
				Posted = 0 
				--and (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(GLCompanyKey, 0)) ) 

				AND (-- case when @GLCompanyKey = ALL
					(@GLCompanyKey = -1 AND 
						(
						@RestrictToGLCompany = 0 OR 
						(GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
						)
					)
					--case when @GLCompanyKey = X or Blank(0)
					 OR (@GLCompanyKey != -1 AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
				)

				and PaymentKey > @CurKey
		if @CurKey is null
			Break
		
		exec spGLPostPayment @CompanyKey, @CurKey, @PrePost, @CreateTemp
	END
END

-- Client Invoices ***************************************************************************
if @ClientInvoices = 1
BEGIN
Select @CurKey = -1
While 1=1
	BEGIN
		Select @CurKey = Min(InvoiceKey)
			from tInvoice (nolock) 
			Where CompanyKey = @CompanyKey and
				PostingDate >= @StartDate and
				PostingDate <= @EndDate and
				InvoiceStatus = 4 and Posted = 0
				--and (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(GLCompanyKey, 0)) ) 
				
				AND (-- case when @GLCompanyKey = ALL
					(@GLCompanyKey = -1 AND 
						(
						@RestrictToGLCompany = 0 OR 
						(GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
						)
					)
					--case when @GLCompanyKey = X or Blank(0)
					 OR (@GLCompanyKey != -1 AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
				)

				and InvoiceKey > @CurKey
		if @CurKey is null
			Break
			
		exec spGLPostInvoice @CompanyKey, @CurKey, @PrePost, @CreateTemp
	END
END

-- Client Receipts ***************************************************************************
if @Receipts = 1
BEGIN
Select @CurKey = -1
While 1=1
	BEGIN
		Select @CurKey = Min(CheckKey)
			from tCheck (nolock) 
			inner join tCompany (nolock) on tCheck.ClientKey = tCompany.CompanyKey
			Where OwnerCompanyKey = @CompanyKey and
				PostingDate >= @StartDate and
				PostingDate <= @EndDate and
				Posted = 0 
				--and (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(tCheck.GLCompanyKey, 0)) ) 
				
				AND (-- case when @GLCompanyKey = ALL
					(@GLCompanyKey = -1 AND 
						(
						@RestrictToGLCompany = 0 OR 
						(tCheck.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
						)
					)
					--case when @GLCompanyKey = X or Blank(0)
					 OR (@GLCompanyKey != -1 AND ISNULL(tCheck.GLCompanyKey, 0) = @GLCompanyKey)
				)

				and CheckKey > @CurKey
		if @CurKey is null
			Break
			
		exec spGLPostCheck @CompanyKey, @CurKey, @PrePost, @CreateTemp
	END
END

-- Journal Entries ***************************************************************************
if @JournalEntries = 1
BEGIN
Select @CurKey = -1
While 1=1
	BEGIN
		Select @CurKey = Min(JournalEntryKey)
			from tJournalEntry (nolock) 
			Where CompanyKey = @CompanyKey and
				PostingDate >= @StartDate and
				PostingDate <= @EndDate and
				Posted = 0 
				and (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(GLCompanyKey, 0)) ) 

				AND (-- case when @GLCompanyKey = ALL
					(@GLCompanyKey = -1 AND 
						(
						@RestrictToGLCompany = 0 OR 
						(GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
						)
					)
					--case when @GLCompanyKey = X or Blank(0)
					 OR (@GLCompanyKey != -1 AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
				)

				and JournalEntryKey > @CurKey
		if @CurKey is null
			Break
			
		exec spGLPostJournalEntry @CompanyKey, @CurKey, @PrePost, @CreateTemp
	END
END


-- added because of issue (152045)


update #tTransaction
SET #tTransaction.SourceCompanyKey = tmp.CompanyKey
FROM (Select tr.SourceCompanyKey as CompanyKey, tr.Entity, tr.EntityKey
		From #tTransaction tr (nolock)
		where tr.Section = 1
	 ) as tmp
WHERE #tTransaction.Section = 8
AND #tTransaction.Entity = tmp.Entity
AND #tTransaction.EntityKey = tmp.EntityKey

Declare @RequireGLCompany INT
		,@RequireOffice INT
		,@RequireDepartment INT
		,@RequireClasses INT
		
SELECT	@RequireGLCompany	= ISNULL(RequireGLCompany, 0)
		,@RequireOffice		= ISNULL(RequireOffice, 0)
		,@RequireDepartment	= ISNULL(RequireDepartment, 0)
		,@RequireClasses	= ISNULL(RequireClasses, 0)
FROM    tPreference (NOLOCK)
WHERE   CompanyKey = @CompanyKey			
			
Select pp.*,
        v.VoucherID,
		ISNULL(gl.AccountNumber, 'Missing GL Account') + ' - ' +
		ISNULL(gl.AccountName, 'WILL NOT POST') AS AccountFullName,
		gl.AccountNumber AS SortAccountNumber,  -- Nulls at the top, easy to spot
		ISNULL(gl.AccountNumber, 'Missing GL Account') AS AccountNumber,
		ISNULL(gl.AccountName, 'WILL NOT POST') AS AccountName,
		CASE WHEN ISNULL(pp.ClassKey, 0) = 0 THEN
			CASE WHEN @RequireClasses = 1 THEN 'WILL NOT POST'
				 ELSE cl.ClassID	
			END
			ELSE cl.ClassID		
		END AS ClassID,
		CASE WHEN ISNULL(pp.GLCompanyKey, 0) = 0 THEN
			CASE WHEN @RequireGLCompany = 1 THEN 'WILL NOT POST'
				 ELSE glc.GLCompanyName	
			END
			ELSE glc.GLCompanyName		
		END AS GLCompanyName,
		CASE WHEN ISNULL(pp.GLCompanyKey, 0) = 0 THEN
			CASE WHEN @RequireGLCompany = 1 THEN 'WILL NOT POST'
				 ELSE glc.GLCompanyID	
			END
			ELSE glc.GLCompanyID		
		END AS GLCompanyID,
		-- office and department validated on lines only (section =2) + check GPFlag
		CASE WHEN ISNULL(pp.OfficeKey, 0) = 0 AND pp.GPFlag = 1 AND pp.Section = 2 AND @RequireOffice = 1 
			THEN 'WILL NOT POST'
			ELSE o.OfficeName	
		END AS OfficeName,
		CASE WHEN ISNULL(pp.OfficeKey, 0) = 0 AND pp.GPFlag = 1 AND pp.Section = 2 AND @RequireOffice = 1 
			THEN 'WILL NOT POST'
			ELSE o.OfficeID	
		END AS OfficeID,
		CASE WHEN ISNULL(pp.DepartmentKey, 0) = 0  AND pp.GPFlag = 1 AND pp.Section = 2 AND @RequireDepartment = 1 
			THEN 'WILL NOT POST'
			ELSE d.DepartmentName		
		END AS DepartmentName,
		ISNULL(c.CompanyName, 'No Company') as CompanyName,
		CASE WHEN ISNULL(p.ProjectNumber, '') = '' OR ISNULL(p.ProjectName, '') = '' THEN 'No Project'
		ELSE p.ProjectNumber + ' - ' + p.ProjectName
		END as FullProjectName,
		ISNULL(ck.CompanyName, 'No Client') as ClientName,
		ISNULL(ck.CustomerID, 'No Client') as ClientID,
		p.ProjectNumber as ProjectNumber
From #tTransaction pp -- pp = prepost
	left outer join tGLAccount gl (nolock) on pp.GLAccountKey = gl.GLAccountKey
	left outer join tCompany c (nolock) on pp.SourceCompanyKey = c.CompanyKey
	left outer join tClass cl (nolock) on pp.ClassKey = cl.ClassKey
	left outer join tGLCompany glc (nolock) on pp.GLCompanyKey = glc.GLCompanyKey
	left outer join tOffice o (nolock) on pp.OfficeKey = o.OfficeKey
	left outer join tDepartment d (nolock) on pp.DepartmentKey = d.DepartmentKey
	left outer join tProject p (nolock) on pp.ProjectKey = p.ProjectKey
	left outer join tCompany ck(nolock) on pp.ClientKey = ck.CompanyKey 
    left join tVoucher v (nolock) on (pp.EntityKey = v.VoucherKey AND
                                      pp.Entity = 'Voucher')
	Where pp.CompanyKey = @CompanyKey
Order By
	SortAccountNumber, pp.TransactionDate, pp.Entity, pp.EntityKey
GO
