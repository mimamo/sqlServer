USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLValidatePostTemp]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGLValidatePostTemp]
(
	@CompanyKey int,
	@Entity varchar(50),
	@EntityKey int,
	@BalanceErrRet int,
	@PostedErrRet int,
	@GLCompanyErrRet int	= -200,
	@OfficeErrRet int		= -201,
	@DepartmentErrRet int	= -202,
	@ClassErrRet int		= -203	
)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 06/18/07 GHL 8.5   Creation for new gl posting
  || 07/05/07 GHL 8.5   Validate Offices and Departments on lines only 	
  || 10/08/07 GHL 8.5   Do not department key for payment, voucher, journal
  || 10/09/07 GHL 8.5   Added validation of the PostSide against amounts 
  || 02/27/09 GHL 10.019 (47594) Do not require departments on receipt line linked to invoices
  || 06/10/09 GHL 10.026 (54340) Do not require offices on receipt/payment line linked to invoices
  || 10/13/11 GHL 10.459 Added new entity CREDITCARD
  || 06/26/12 GHL 10.557 (146376) Added logic for tGLAccount.VisibleGLCompanyKey, now we add -10000 to errors
  ||                     to separate from other gl account errors
  || 07/25/12 GHL 10.558 (149836) Do not validate classes for ICT records 
  || 08/15/12 GHL 10.559 Validate GL accounts based on tGLAccount.RestrictToGLCompany
  || 10/03/12 GHL 10.560 Validate GL closing dates based on tPreference.MultiCompanyClosingDate
  || 06/24/13 GHL 10.569 (182080) Using now #tTransaction.GPFlag (general purpose flag) to flag missing offices and depts
  || 07/17/14 GHL 10.582 (222243) When checking the class required, do not consider multi currency or ICT records 
  */ 
  
	DECLARE @kSectionHeader int						SELECT @kSectionHeader = 1
	DECLARE @kSectionLine int						SELECT @kSectionLine = 2
	DECLARE @kSectionPrepayments int				SELECT @kSectionPrepayments = 3
	DECLARE @kSectionPrebillAccruals int			SELECT @kSectionPrebillAccruals = 4
	DECLARE @kSectionSalesTax int					SELECT @kSectionSalesTax = 5
	DECLARE @kSectionWIP int						SELECT @kSectionWIP = 6
	DECLARE @kSectionVoucherCC int					SELECT @kSectionVoucherCC = 7
	DECLARE @kSectionICT int						SELECT @kSectionICT = 8
	DECLARE @kSectionMCRounding int					SELECT @kSectionMCRounding = 9
	DECLARE @kSectionMCGain int						SELECT @kSectionMCGain = 10

	DECLARE @kInvalidAccountRollup int				SELECT @kInvalidAccountRollup = -204
	DECLARE @kInvalidClosingDate int				SELECT @kInvalidClosingDate = -205
	DECLARE @kInvalidGLCompanyBase int				SELECT @kInvalidGLCompanyBase = -10000 -- if the gl company is incorrect, use this base

	Declare @GLAccountErrRet INT
			,@TotalDebit money
			,@TotalCredit money
			,@RequireGLCompany INT
			,@RequireOffice INT
			,@RequireDepartment INT
			,@RequireClasses INT
					
	-- Validate GL Accounts	
	UPDATE #tTransaction
	SET	   #tTransaction.GLValid = 1 -- Valid
	FROM   tGLAccount gl (NOLOCK)
	WHERE  #tTransaction.GLAccountKey = gl.GLAccountKey
	AND	   #tTransaction.Entity = @Entity 
	AND    #tTransaction.EntityKey = @EntityKey
	AND	   gl.CompanyKey = @CompanyKey 

	-- also cleanup GPFlag, I am using it now for flagging bad offices and departments
	UPDATE #tTransaction
	SET	   #tTransaction.GPFlag = 0
	WHERE  #tTransaction.Entity = @Entity 
	AND    #tTransaction.EntityKey = @EntityKey
	
	IF EXISTS (SELECT 1 FROM #tTransaction WHERE GLValid = 0 AND Entity = @Entity AND EntityKey = @EntityKey)
	BEGIN
		SELECT @GLAccountErrRet = GLAccountErrRet
		FROM #tTransaction WHERE GLValid = 0 AND Entity = @Entity AND EntityKey = @EntityKey

		RETURN @GLAccountErrRet
	END
		
	-- At this point, all gl accounts are valid
	-- we must now check if some gl accounts are only valid/visible to a certain gl company
	 
	DECLARE @RestrictToGLCompany INT	
	DECLARE @MultiCompanyClosingDate INT
	Declare @MultiCurrency INT

	SELECT @RestrictToGLCompany = RestrictToGLCompany 
	      ,@MultiCompanyClosingDate = MultiCompanyClosingDate
		  ,@MultiCurrency = MultiCurrency
	from tPreference (nolock) where CompanyKey = @CompanyKey 
	
	if isnull(@RestrictToGLCompany, 0) = 1
	begin
		UPDATE #tTransaction
		SET	   #tTransaction.GLValid = 0 -- Invalid again
		FROM   tGLAccount gl (NOLOCK)
		WHERE  #tTransaction.GLAccountKey = gl.GLAccountKey
		AND	   #tTransaction.Entity = @Entity 
		AND    #tTransaction.EntityKey = @EntityKey
		AND	   gl.CompanyKey = @CompanyKey
		AND    isnull(gl.RestrictToGLCompany, 0) = 1 -- if 0, means that the GL account in available to all gl companies 
	    AND    isnull(#tTransaction.GLCompanyKey, 0) not in (
			select glca.GLCompanyKey from tGLCompanyAccess glca (nolock) 
			where glca.Entity = 'tGLAccount'
			and   glca.EntityKey =  #tTransaction.GLAccountKey 
		) 
	
		IF EXISTS (SELECT 1 FROM #tTransaction WHERE GLValid = 0 AND Entity = @Entity AND EntityKey = @EntityKey)
		BEGIN
			SELECT @GLAccountErrRet = GLAccountErrRet
			FROM #tTransaction WHERE GLValid = 0 AND Entity = @Entity AND EntityKey = @EntityKey

			RETURN @GLAccountErrRet + @kInvalidGLCompanyBase

		END
	end	 	

	if isnull(@MultiCompanyClosingDate, 0) = 1
	begin
		UPDATE #tTransaction
		SET	   #tTransaction.GLValid = 0 -- Invalid again
		FROM   tGLCompany glc (NOLOCK)
		WHERE  #tTransaction.GLCompanyKey = glc.GLCompanyKey
		AND	   #tTransaction.Entity = @Entity 
		AND    #tTransaction.EntityKey = @EntityKey
		AND	   glc.CompanyKey = @CompanyKey
		AND    glc.GLCloseDate is not null
		AND    glc.GLCloseDate > #tTransaction.TransactionDate

		IF EXISTS (SELECT 1 FROM #tTransaction WHERE GLValid = 0 AND Entity = @Entity AND EntityKey = @EntityKey)
		BEGIN
			RETURN @kInvalidClosingDate 
		END
	end	 	


	-- Validate Debits = Credits 
	declare @CurrencyCount int
	if isnull(@MultiCurrency, 0) = 0
		Select @TotalDebit = ISNULL(Sum(Debit), 0)
			, @TotalCredit = ISNULL(Sum(Credit), 0)
		from #tTransaction 
		Where Entity = @Entity and EntityKey = @EntityKey
	else
	begin
		-- careful, a null currency is Home Currency but is not picked up by Select Distinct, convert to ''
		select @CurrencyCount = count(distinct isnull(CurrencyID, ''))
		from #tTransaction 
		Where Entity = @Entity and EntityKey = @EntityKey

		if @CurrencyCount > 1
			-- several currencies are involved, balance the debit/credit in HC only
			-- that could be a transfer from a EUR bank to a CAD bank for example
			Select @TotalDebit = ISNULL(Sum(HDebit), 0)
			, @TotalCredit = ISNULL(Sum(HCredit), 0)
			from #tTransaction 
			Where Entity = @Entity and EntityKey = @EntityKey
		else
			Select @TotalDebit = ISNULL(Sum(Debit), 0)
			, @TotalCredit = ISNULL(Sum(Credit), 0)
			from #tTransaction 
			Where Entity = @Entity and EntityKey = @EntityKey
	end

	If @TotalDebit <> @TotalCredit
		return @BalanceErrRet 

	IF EXISTS (SELECT 1 FROM #tTransaction (NOLOCK) Where Entity = @Entity and EntityKey = @EntityKey
			   AND PostSide = 'D' AND ISNULL(Debit, 0) = 0 AND ISNULL(Credit, 0) <> 0)
		return @BalanceErrRet 
			   
	IF EXISTS (SELECT 1 FROM #tTransaction (NOLOCK) Where Entity = @Entity and EntityKey = @EntityKey
			   AND PostSide = 'C' AND ISNULL(Debit, 0) <> 0 AND ISNULL(Credit, 0) = 0)
		return @BalanceErrRet 
	
	-- Protect against double postings
	IF EXISTS (SELECT 1 FROM tTransaction (NOLOCK) WHERE Entity = @Entity AND EntityKey = @EntityKey)
		RETURN @PostedErrRet 
	
	IF @Entity = 'GENJRNL' AND 
		EXISTS (SELECT 1 FROM tJournalEntry (NOLOCK) WHERE JournalEntryKey = @EntityKey AND Posted = 1)
			RETURN @PostedErrRet
	IF @Entity = 'INVOICE' AND 
		EXISTS (SELECT 1 FROM tInvoice (NOLOCK) WHERE InvoiceKey = @EntityKey AND Posted = 1)
			RETURN @PostedErrRet
	IF @Entity IN ('VOUCHER', 'CREDITCARD') AND 
		EXISTS (SELECT 1 FROM tVoucher (NOLOCK) WHERE VoucherKey = @EntityKey AND Posted = 1)
			RETURN @PostedErrRet		
	IF @Entity = 'PAYMENT' AND 
		EXISTS (SELECT 1 FROM tPayment (NOLOCK) WHERE PaymentKey = @EntityKey AND Posted = 1)
			RETURN @PostedErrRet		
	IF @Entity = 'RECEIPT' AND 
		EXISTS (SELECT 1 FROM tCheck (NOLOCK) WHERE CheckKey = @EntityKey AND Posted = 1)
			RETURN @PostedErrRet		
		
	IF EXISTS(SELECT 1 FROM tGLAccount (NOLOCK) INNER JOIN #tTransaction ON tGLAccount.GLAccountKey = #tTransaction.GLAccountKey Where tGLAccount.Rollup = 1)
		RETURN @kInvalidAccountRollup

	-- Check for missing company, office, department and class	
	SELECT	@RequireGLCompany	= ISNULL(RequireGLCompany, 0)
			,@RequireOffice		= ISNULL(RequireOffice, 0)
			,@RequireDepartment	= ISNULL(RequireDepartment, 0)
			,@RequireClasses	= ISNULL(RequireClasses, 0)
	FROM    tPreference (NOLOCK)
	WHERE   CompanyKey = @CompanyKey
	
	-- for these, do not check departments
	IF @Entity IN ('GENJRNL', 'VOUCHER', 'CREDITCARD', 'PAYMENT')
		SELECT @RequireDepartment = 0
			
	IF EXISTS (SELECT 1 FROM #tTransaction WHERE @RequireGLCompany = 1 
		AND Entity = @Entity AND EntityKey = @EntityKey	AND GLCompanyKey IS NULL)
		RETURN @GLCompanyErrRet

	-- Validate class except for ICT, MC Gain, MC Rounding errors
	IF EXISTS (SELECT 1 FROM #tTransaction WHERE @RequireClasses = 1 
		AND Entity = @Entity AND EntityKey = @EntityKey	AND Section < @kSectionICT AND ClassKey IS NULL )
		RETURN @ClassErrRet

	IF @RequireDepartment = 1
	BEGIN
		IF @Entity = 'RECEIPT'
		BEGIN
			-- Flag missing depts
			UPDATE #tTransaction
			SET    #tTransaction.GPFlag = 1
			FROM   tCheckAppl ca (NOLOCK)
			WHERE  #tTransaction.DetailLineKey = ca.CheckApplKey
			AND    #tTransaction.Entity = @Entity 
			AND    #tTransaction.EntityKey = @EntityKey	
			AND    #tTransaction.DepartmentKey IS NULL 
			AND    #tTransaction.Section = @kSectionLine
			AND    ca.InvoiceKey IS NULL -- only if we apply to Sales, there is no dept on the UI when applying to invoice

			/*
			IF EXISTS (SELECT 1 FROM #tTransaction t
						INNER JOIN tCheckAppl ca (NOLOCK) ON t.DetailLineKey = ca.CheckApplKey
				WHERE t.Entity = @Entity 
				AND   t.EntityKey = @EntityKey	
				AND   t.DepartmentKey IS NULL 
				AND   t.Section = @kSectionLine
				AND   ca.InvoiceKey IS NULL -- only if we apply to Sales, there is no dept on the UI when applying to invoice
			)
			*/

			IF EXISTS (SELECT 1 FROM #tTransaction t
				WHERE t.Entity = @Entity 
				AND   t.EntityKey = @EntityKey	
				AND   t.GPFlag = 1
			)
			RETURN @DepartmentErrRet
		END
		
		ELSE
		BEGIN
			UPDATE #tTransaction
			SET    #tTransaction.GPFlag = 1
			WHERE  #tTransaction.Entity = @Entity 
			AND    #tTransaction.EntityKey = @EntityKey	
			AND    #tTransaction.DepartmentKey IS NULL 
			AND    #tTransaction.Section = @kSectionLine
			
			/*
			IF EXISTS (SELECT 1 FROM #tTransaction 
			WHERE Entity = @Entity AND EntityKey = @EntityKey	
			AND DepartmentKey IS NULL AND Section = @kSectionLine)
			*/
			IF EXISTS (SELECT 1 FROM #tTransaction t
				WHERE t.Entity = @Entity 
				AND   t.EntityKey = @EntityKey	
				AND   t.GPFlag = 1
			)
			RETURN @DepartmentErrRet
		END
		
	END
				
	IF @RequireOffice = 1
	BEGIN
		IF @Entity = 'RECEIPT'
		BEGIN
			-- Flag missing offices
			UPDATE #tTransaction
			SET    #tTransaction.GPFlag = 1
			FROM   tCheckAppl ca (NOLOCK)
			WHERE  #tTransaction.DetailLineKey = ca.CheckApplKey
			AND    #tTransaction.Entity = @Entity 
			AND    #tTransaction.EntityKey = @EntityKey	
			AND    #tTransaction.OfficeKey IS NULL 
			AND    #tTransaction.Section = @kSectionLine
			AND    ca.InvoiceKey IS NULL -- only if we apply to Sales, there is no dept on the UI when applying to invoice

			/*
			IF EXISTS (SELECT 1 FROM #tTransaction t
						INNER JOIN tCheckAppl ca (NOLOCK) ON t.DetailLineKey = ca.CheckApplKey
				WHERE t.Entity = @Entity 
				AND   t.EntityKey = @EntityKey	
				AND   t.OfficeKey IS NULL 
				AND   t.Section = @kSectionLine
				AND   ca.InvoiceKey IS NULL -- only if we apply to Sales, there is no office on the UI when applying to invoice
			)*/
			IF EXISTS (SELECT 1 FROM #tTransaction t
				WHERE t.Entity = @Entity 
				AND   t.EntityKey = @EntityKey	
				AND   t.GPFlag = 1
			)
			RETURN @OfficeErrRet
		END
		
		ELSE IF @Entity = 'PAYMENT'
		BEGIN
			UPDATE #tTransaction
			SET    #tTransaction.GPFlag = 1
			FROM   tPaymentDetail pd (NOLOCK)
			WHERE  #tTransaction.DetailLineKey = pd.PaymentDetailKey
			AND    #tTransaction.Entity = @Entity 
			AND    #tTransaction.EntityKey = @EntityKey	
			AND    #tTransaction.OfficeKey IS NULL 
			AND    #tTransaction.Section = @kSectionLine
			AND    pd.VoucherKey IS NULL -- only if we apply to Sales, there is no dept on the UI when applying to invoice

			/*
			IF EXISTS (SELECT 1 FROM #tTransaction t
						INNER JOIN tPaymentDetail pd (NOLOCK) ON t.DetailLineKey = pd.PaymentDetailKey
				WHERE t.Entity = @Entity 
				AND   t.EntityKey = @EntityKey	
				AND   t.OfficeKey IS NULL 
				AND   t.Section = @kSectionLine
				AND   pd.VoucherKey IS NULL -- only if we apply to Expenses, there is no office on the UI when applying to invoice
			)
			*/
			IF EXISTS (SELECT 1 FROM #tTransaction t
				WHERE t.Entity = @Entity 
				AND   t.EntityKey = @EntityKey	
				AND   t.GPFlag = 1
			)	
			RETURN @OfficeErrRet
		END
		
		ELSE
		BEGIN
			UPDATE #tTransaction
			SET    #tTransaction.GPFlag = 1
			WHERE  #tTransaction.Entity = @Entity 
			AND    #tTransaction.EntityKey = @EntityKey	
			AND    #tTransaction.OfficeKey IS NULL 
			AND    #tTransaction.Section = @kSectionLine
			
			/*
			IF EXISTS (SELECT 1 FROM #tTransaction 
			WHERE Entity = @Entity AND EntityKey = @EntityKey
			AND OfficeKey IS NULL AND Section = @kSectionLine)
			*/
			IF EXISTS (SELECT 1 FROM #tTransaction t
				WHERE t.Entity = @Entity 
				AND   t.EntityKey = @EntityKey	
				AND   t.GPFlag = 1
			)
			RETURN @OfficeErrRet
		END 
	END	
		
		
	RETURN 1
GO
