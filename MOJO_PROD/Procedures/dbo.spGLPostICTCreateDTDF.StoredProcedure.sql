USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostICTCreateDTDF]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostICTCreateDTDF]
	(
	@CompanyKey int	
	,@Entity varchar(20)
	,@EntityKey int
	,@IsAccrual int
	,@SourceGLCompanyKey int         -- source/main GL Company for the payment, etc.. 	
	,@TransactionDate smalldatetime	
	,@Memo varchar(500)
	,@Reference varchar(100)
	)
AS --Encrypt

	SET NOCOUNT ON

  /*
  || When     Who Rel     What
  || 03/23/12 GHL 10.554  Creation to create Due To/Due From transactions (ICT)
  || 03/30/12 GHL 10.554  Added JE Posting 
  || 04/03/12 GHL 10.554  Added Section Voucher CC when processing AP
  || 07/03/12 GHL 10.557  Added logic for ICTGLCompanyKey
  || 07/06/12 GHL 10.557  Changed DueTo/DueFrom for the AR case (after WIP posting changes)
  || 08/05/13 GHL 10.571  Added Multi Currency stuff
  */

-- we can only do it if we have 2 different GL companies
-- also SourceGLCompanyKey = null, TargetGLCompanyKey > 0 not acceptable  
if isnull(@SourceGLCompanyKey,0) = 0
	return

DECLARE @kSectionHeader int						SELECT @kSectionHeader = 1
DECLARE @kSectionLine int						SELECT @kSectionLine = 2
DECLARE @kSectionPrepayments int				SELECT @kSectionPrepayments = 3
DECLARE @kSectionPrebillAccruals int			SELECT @kSectionPrebillAccruals = 4
DECLARE @kSectionSalesTax int					SELECT @kSectionSalesTax = 5
DECLARE @kSectionWIP int						SELECT @kSectionWIP = 6
DECLARE @kSectionVoucherCC int					SELECT @kSectionVoucherCC = 7
DECLARE @kSectionICT int						SELECT @kSectionICT = 8

DECLARE @kErrAcctAPDT INT						SELECT @kErrAcctAPDT = -300
DECLARE @kErrAcctAPDF INT						SELECT @kErrAcctAPDF = -301
DECLARE @kErrAcctARDT INT						SELECT @kErrAcctARDT = -302
DECLARE @kErrAcctARDF INT						SELECT @kErrAcctARDF = -303
DECLARE @kErrAcctJEDT INT						SELECT @kErrAcctJEDT = -304
DECLARE @kErrAcctJEDF INT						SELECT @kErrAcctJEDF = -305
DECLARE @kErrAcctCSDT INT						SELECT @kErrAcctCSDT = -306
DECLARE @kErrAcctCSDF INT						SELECT @kErrAcctCSDF = -307

DECLARE @kICTSourceAP INT						SELECT @kICTSourceAP = 1
DECLARE @kICTSourceAR INT						SELECT @kICTSourceAR = 2
DECLARE @kICTSourceJE INT						SELECT @kICTSourceJE = 3
DECLARE @kICTSourceCS INT						SELECT @kICTSourceCS = 4

DECLARE @IsAR int
DECLARE @IsAP int
DECLARE @IsJE int
DECLARE @IntercompanyAccountSource int
DECLARE @ErrAcctJEDT int
DECLARE @ErrAcctJEDF int

select @IsAR = 0
select @IsAP = 0
select @IsJE = 0

if @Entity in ('PAYMENT', 'VOUCHER', 'CREDITCARD')
	select @IsAP = 1
if @Entity in ('RECEIPT', 'INVOICE')
	select @IsAR = 1
-- GENJRNL, WIP
if @Entity in ('GENJRNL')
	select @IsJE = 1

if  @IsAP = 1
begin
	If @IsAccrual = 1
	begin
		-- start with a Due To, flip post side
		-- there will be 1 one line per target company (we need to group)
		 
		INSERT #tTransaction(
			CompanyKey
			,TransactionDate
			,Entity
			,EntityKey
			,Reference
			,GLAccountKey
			,Debit
			,Credit
			,ClassKey
			,Memo
			,ClientKey
			,ProjectKey
			,SourceCompanyKey
			,DepositKey
			,PostSide
			,GLCompanyKey
			,OfficeKey
			,DepartmentKey
			,DetailLineKey
			,Section
			,GLAccountErrRet
			,ICTGLCompanyKey
			,CurrencyID
			,ExchangeRate
			,HDebit
			,HCredit
			)
		select 
			@CompanyKey
			,@TransactionDate
			,@Entity
			,@EntityKey
			,@Reference
			,glcm.APDueToAccountKey
			,0           -- Debit
			,SUM(t.Debit)  --Credit -- must flip the debits
			,NULL --ClassKey
			,@Memo
			,NULL -- ClientKey
			,NULL -- ProjectKey
			,NULL ---SourceCompanyKey
			,NULL --DepositKey
			,'C' --PostSide
			,t.GLCompanyKey
			,NULL --OfficeKey
			,NULL --DepartmentKey
			,NULL --DetailLineKey
			,@kSectionICT --Section
			,@kErrAcctAPDT --GLAccountErrRet
			,@SourceGLCompanyKey
			,t.CurrencyID
			,isnull(t.ExchangeRate, 1)
			,0           -- HDebit
			,SUM(t.HDebit)  --HCredit -- must flip the debits
		from  #tTransaction t
			left outer join tGLCompanyMap glcm (nolock) on glcm.SourceGLCompanyKey = @SourceGLCompanyKey 
						and  glcm.TargetGLCompanyKey = t.GLCompanyKey 
		where t.Entity = @Entity
		and   t.EntityKey = @EntityKey 
		and   isnull(t.GLCompanyKey,0) <> @SourceGLCompanyKey
		and   t.Section in (@kSectionLine, @kSectionSalesTax, @kSectionVoucherCC)

		group by t.GLCompanyKey, glcm.APDueToAccountKey, t.CurrencyID, isnull(t.ExchangeRate, 1)

		-- then Due From 
		-- there will be 1 one line per target company (no need to group here)
		
		INSERT #tTransaction(
			CompanyKey
			,TransactionDate
			,Entity
			,EntityKey
			,Reference
			,GLAccountKey
			,Debit
			,Credit
			,ClassKey
			,Memo
			,ClientKey
			,ProjectKey
			,SourceCompanyKey
			,DepositKey
			,PostSide
			,GLCompanyKey
			,OfficeKey
			,DepartmentKey
			,DetailLineKey
			,Section
			,GLAccountErrRet
			,ICTGLCompanyKey
			,CurrencyID
			,ExchangeRate
			,HDebit
			,HCredit
			)
		select 
			@CompanyKey
			,@TransactionDate
			,@Entity
			,@EntityKey
			,@Reference
			,glcm.APDueFromAccountKey
			,t.Credit      --Debit -- must flip the Credits -- no grouping
			,0             --Credit 
			,NULL --ClassKey
			,@Memo
			,NULL -- ClientKey
			,NULL -- ProjectKey
			,NULL ---SourceCompanyKey
			,NULL --DepositKey
			,'D' --PostSide
			,@SourceGLCompanyKey
			,NULL --OfficeKey
			,NULL --DepartmentKey
			,NULL --DetailLineKey
			,@kSectionICT --Section
			,@kErrAcctAPDF --GLAccountErrRet
			,t.GLCompanyKey
			,t.CurrencyID
			,isnull(t.ExchangeRate, 1)
			,t.HCredit      --Debit -- must flip the Credits -- no grouping
			,0             --Credit 
		from  #tTransaction t
			left outer join tGLCompanyMap glcm (nolock) on glcm.SourceGLCompanyKey = @SourceGLCompanyKey 
						and  glcm.TargetGLCompanyKey = t.GLCompanyKey 
		where t.Entity = @Entity
		and   t.EntityKey = @EntityKey 
		and   isnull(t.GLCompanyKey,0) <> @SourceGLCompanyKey
		and   t.Section = @kSectionICT

	end -- IsAccrual

	else

	begin
		-- Cash Basis

		-- start with a Due To, flip post side
		-- there will be 1 one line per target company (we need to group)
		 
		INSERT #tCashTransaction(
			CompanyKey
			,TransactionDate
			,Entity
			,EntityKey
			,Reference
			,GLAccountKey
			,Debit
			,Credit
			,ClassKey
			,Memo
			,ClientKey
			,ProjectKey
			,SourceCompanyKey
			,DepositKey
			,PostSide
			,GLCompanyKey
			,OfficeKey
			,DepartmentKey
			,DetailLineKey
			,Section
			,GLAccountErrRet
			,ICTGLCompanyKey
			,CurrencyID
			,ExchangeRate
			,HDebit
			,HCredit
			)
		select 
			@CompanyKey
			,@TransactionDate
			,@Entity
			,@EntityKey
			,@Reference
			,glcm.APDueToAccountKey
			,0           -- Debit
			,SUM(t.Debit)  --Credit -- must flip the debits
			,NULL --ClassKey
			,@Memo
			,NULL -- ClientKey
			,NULL -- ProjectKey
			,NULL ---SourceCompanyKey
			,NULL --DepositKey
			,'C' --PostSide
			,t.GLCompanyKey
			,NULL --OfficeKey
			,NULL --DepartmentKey
			,NULL --DetailLineKey
			,@kSectionICT --Section
			,@kErrAcctAPDT --GLAccountErrRet
			,@SourceGLCompanyKey
			,t.CurrencyID
			,isnull(t.ExchangeRate, 1)
			,0           -- Debit
			,SUM(t.HDebit)  --Credit -- must flip the debits
			
		from  #tCashTransaction t
			left outer join tGLCompanyMap glcm (nolock) on glcm.SourceGLCompanyKey = @SourceGLCompanyKey 
						and  glcm.TargetGLCompanyKey = t.GLCompanyKey 
		where t.Entity = @Entity
		and   t.EntityKey = @EntityKey 
		and   isnull(t.GLCompanyKey,0) <> @SourceGLCompanyKey
		and   t.Section in (@kSectionLine, @kSectionSalesTax, @kSectionVoucherCC)

		group by t.GLCompanyKey, glcm.APDueToAccountKey, t.CurrencyID, isnull(t.ExchangeRate, 1)

		-- then Due From 
		-- there will be 1 one line per target company (no need to group here)
		
		INSERT #tCashTransaction(
			CompanyKey
			,TransactionDate
			,Entity
			,EntityKey
			,Reference
			,GLAccountKey
			,Debit
			,Credit
			,ClassKey
			,Memo
			,ClientKey
			,ProjectKey
			,SourceCompanyKey
			,DepositKey
			,PostSide
			,GLCompanyKey
			,OfficeKey
			,DepartmentKey
			,DetailLineKey
			,Section
			,GLAccountErrRet
			,ICTGLCompanyKey
			,CurrencyID
			,ExchangeRate
			,HDebit
			,HCredit
			)
		select 
			@CompanyKey
			,@TransactionDate
			,@Entity
			,@EntityKey
			,@Reference
			,glcm.APDueFromAccountKey
			,t.Credit      --Debit -- must flip the Credits -- no grouping
			,0             --Credit 
			,NULL --ClassKey
			,@Memo
			,NULL -- ClientKey
			,NULL -- ProjectKey
			,NULL ---SourceCompanyKey
			,NULL --DepositKey
			,'D' --PostSide
			,@SourceGLCompanyKey
			,NULL --OfficeKey
			,NULL --DepartmentKey
			,NULL --DetailLineKey
			,@kSectionICT --Section
			,@kErrAcctAPDF --GLAccountErrRet
			,t.GLCompanyKey
			,t.CurrencyID
			,isnull(t.ExchangeRate, 1)
			,t.HCredit      --Debit -- must flip the Credits -- no grouping
			,0             --Credit 
		from  #tCashTransaction t
			left outer join tGLCompanyMap glcm (nolock) on glcm.SourceGLCompanyKey = @SourceGLCompanyKey 
						and  glcm.TargetGLCompanyKey = t.GLCompanyKey 
		where t.Entity = @Entity
		and   t.EntityKey = @EntityKey 
		and   isnull(t.GLCompanyKey,0) <> @SourceGLCompanyKey
		and   t.Section = @kSectionICT

	end -- Cash Basis


end -- AP


if  @IsAR = 1
begin
	If @IsAccrual = 1
	begin
		-- start with a Due To, flip post side
		-- there will be 1 one line per target company (we need to group)
		 
		INSERT #tTransaction(
			CompanyKey
			,TransactionDate
			,Entity
			,EntityKey
			,Reference
			,GLAccountKey
			,Debit
			,Credit
			,ClassKey
			,Memo
			,ClientKey
			,ProjectKey
			,SourceCompanyKey
			,DepositKey
			,PostSide
			,GLCompanyKey
			,OfficeKey
			,DepartmentKey
			,DetailLineKey
			,Section
			,GLAccountErrRet
			,ICTGLCompanyKey
			,CurrencyID
			,ExchangeRate
			,HDebit
			,HCredit
			)
		select 
			@CompanyKey
			,@TransactionDate
			,@Entity
			,@EntityKey
			,@Reference
			,glcm.ARDueFromAccountKey
			,SUM(t.Credit) -- Debit -- must flip the debits
			,0             -- Credit 
			,NULL --ClassKey
			,@Memo
			,NULL -- ClientKey
			,NULL -- ProjectKey
			,NULL ---SourceCompanyKey
			,NULL --DepositKey
			,'D' --PostSide
			,t.GLCompanyKey
			,NULL --OfficeKey
			,NULL --DepartmentKey
			,NULL --DetailLineKey
			,@kSectionICT --Section
			,@kErrAcctARDF --GLAccountErrRet
			,@SourceGLCompanyKey
			,t.CurrencyID
			,isnull(t.ExchangeRate, 1)
			,SUM(t.HCredit) -- Debit -- must flip the debits
			,0             -- Credit 
		from  #tTransaction t
			left outer join tGLCompanyMap glcm (nolock) on glcm.SourceGLCompanyKey = @SourceGLCompanyKey 
						and  glcm.TargetGLCompanyKey = t.GLCompanyKey 
		where t.Entity = @Entity
		and   t.EntityKey = @EntityKey 
		and   isnull(t.GLCompanyKey,0) <> @SourceGLCompanyKey
		and   t.Section in (@kSectionLine, @kSectionSalesTax)

		group by t.GLCompanyKey, glcm.ARDueFromAccountKey, t.CurrencyID, isnull(t.ExchangeRate, 1)

		-- then Due From 
		-- there will be 1 one line per target company (no need to group here)
		
		INSERT #tTransaction(
			CompanyKey
			,TransactionDate
			,Entity
			,EntityKey
			,Reference
			,GLAccountKey
			,Debit
			,Credit
			,ClassKey
			,Memo
			,ClientKey
			,ProjectKey
			,SourceCompanyKey
			,DepositKey
			,PostSide
			,GLCompanyKey
			,OfficeKey
			,DepartmentKey
			,DetailLineKey
			,Section
			,GLAccountErrRet
			,ICTGLCompanyKey
			,CurrencyID
			,ExchangeRate
			,HDebit
			,HCredit
			)
		select 
			@CompanyKey
			,@TransactionDate
			,@Entity
			,@EntityKey
			,@Reference
			,glcm.ARDueToAccountKey
			,0            --Debit 
			,t.Debit      --Credit -- must flip the Debits -- no grouping
			,NULL --ClassKey
			,@Memo
			,NULL -- ClientKey
			,NULL -- ProjectKey
			,NULL ---SourceCompanyKey
			,NULL --DepositKey
			,'C' --PostSide
			,@SourceGLCompanyKey
			,NULL --OfficeKey
			,NULL --DepartmentKey
			,NULL --DetailLineKey
			,@kSectionICT --Section
			,@kErrAcctARDT --GLAccountErrRet
			,t.GLCompanyKey
			,t.CurrencyID
			,isnull(t.ExchangeRate, 1)
			,0            --Debit 
			,t.HDebit      --Credit -- must flip the Debits -- no grouping
		from  #tTransaction t
			left outer join tGLCompanyMap glcm (nolock) on glcm.SourceGLCompanyKey = @SourceGLCompanyKey 
						and  glcm.TargetGLCompanyKey = t.GLCompanyKey 
		where t.Entity = @Entity
		and   t.EntityKey = @EntityKey 
		and   isnull(t.GLCompanyKey,0) <> @SourceGLCompanyKey
		and   t.Section = @kSectionICT

	end -- IsAccrual

	else

	begin
		-- Cash Basis

		-- start with a Due To, flip post side
		-- there will be 1 one line per target company (we need to group)
		 
		INSERT #tCashTransaction(
			CompanyKey
			,TransactionDate
			,Entity
			,EntityKey
			,Reference
			,GLAccountKey
			,Debit
			,Credit
			,ClassKey
			,Memo
			,ClientKey
			,ProjectKey
			,SourceCompanyKey
			,DepositKey
			,PostSide
			,GLCompanyKey
			,OfficeKey
			,DepartmentKey
			,DetailLineKey
			,Section
			,GLAccountErrRet
			,ICTGLCompanyKey
			,CurrencyID
			,ExchangeRate
			,HDebit
			,HCredit
			)
		select 
			@CompanyKey
			,@TransactionDate
			,@Entity
			,@EntityKey
			,@Reference
			,glcm.ARDueFromAccountKey
			,SUM(t.Credit) -- Debit -- must flip the debits
			,0             -- Credit 
			,NULL --ClassKey
			,@Memo
			,NULL -- ClientKey
			,NULL -- ProjectKey
			,NULL ---SourceCompanyKey
			,NULL --DepositKey
			,'D' --PostSide
			,t.GLCompanyKey
			,NULL --OfficeKey
			,NULL --DepartmentKey
			,NULL --DetailLineKey
			,@kSectionICT --Section
			,@kErrAcctARDF --GLAccountErrRet
			,@SourceGLCompanyKey
			,t.CurrencyID
			,isnull(t.ExchangeRate, 1)
			,SUM(t.HCredit) -- Debit -- must flip the debits
			,0             -- Credit 
		from  #tCashTransaction t
			left outer join tGLCompanyMap glcm (nolock) on glcm.SourceGLCompanyKey = @SourceGLCompanyKey 
						and  glcm.TargetGLCompanyKey = t.GLCompanyKey 
		where t.Entity = @Entity
		and   t.EntityKey = @EntityKey 
		and   isnull(t.GLCompanyKey,0) <> @SourceGLCompanyKey
		and   t.Section in (@kSectionLine, @kSectionSalesTax)

		group by t.GLCompanyKey, glcm.ARDueFromAccountKey, t.CurrencyID, isnull(t.ExchangeRate, 1)

		-- then Due From 
		-- there will be 1 one line per target company (no need to group here)
		
		INSERT #tCashTransaction(
			CompanyKey
			,TransactionDate
			,Entity
			,EntityKey
			,Reference
			,GLAccountKey
			,Debit
			,Credit
			,ClassKey
			,Memo
			,ClientKey
			,ProjectKey
			,SourceCompanyKey
			,DepositKey
			,PostSide
			,GLCompanyKey
			,OfficeKey
			,DepartmentKey
			,DetailLineKey
			,Section
			,GLAccountErrRet
			,ICTGLCompanyKey
			,CurrencyID
			,ExchangeRate
			,HDebit
			,HCredit
			)
		select 
			@CompanyKey
			,@TransactionDate
			,@Entity
			,@EntityKey
			,@Reference
			,glcm.ARDueToAccountKey
			,0            --Debit 
			,t.Debit      --Credit -- must flip the Debits -- no grouping
			,NULL --ClassKey
			,@Memo
			,NULL -- ClientKey
			,NULL -- ProjectKey
			,NULL ---SourceCompanyKey
			,NULL --DepositKey
			,'C' --PostSide
			,@SourceGLCompanyKey
			,NULL --OfficeKey
			,NULL --DepartmentKey
			,NULL --DetailLineKey
			,@kSectionICT --Section
			,@kErrAcctARDT --GLAccountErrRet
			,t.GLCompanyKey
			,t.CurrencyID
			,isnull(t.ExchangeRate, 1)
			,0            --Debit 
			,t.HDebit      --Credit -- must flip the Debits -- no grouping
		from  #tCashTransaction t
			left outer join tGLCompanyMap glcm (nolock) on glcm.SourceGLCompanyKey = @SourceGLCompanyKey 
						and  glcm.TargetGLCompanyKey = t.GLCompanyKey 
		where t.Entity = @Entity
		and   t.EntityKey = @EntityKey 
		and   isnull(t.GLCompanyKey,0) <> @SourceGLCompanyKey
		and   t.Section = @kSectionICT

	end -- Cash Basis


end -- AR


if  @IsJE = 1
begin
	select @IntercompanyAccountSource = isnull(IntercompanyAccountSource, @kICTSourceJE)
	from   tJournalEntry (nolock)
	where  JournalEntryKey = @EntityKey 

	select @IntercompanyAccountSource = isnull(@IntercompanyAccountSource, @kICTSourceJE)
	
	select @ErrAcctJEDT =
	case when @IntercompanyAccountSource = @kICTSourceAP then @kErrAcctAPDT
		when @IntercompanyAccountSource = @kICTSourceAR then @kErrAcctARDT
		when @IntercompanyAccountSource = @kICTSourceJE then @kErrAcctJEDT
		when @IntercompanyAccountSource = @kICTSourceCS then @kErrAcctCSDT
		else @kErrAcctJEDT
	end

	select @ErrAcctJEDF =
	case when @IntercompanyAccountSource = @kICTSourceAP then @kErrAcctAPDF
		when @IntercompanyAccountSource = @kICTSourceAR then @kErrAcctARDF
		when @IntercompanyAccountSource = @kICTSourceJE then @kErrAcctJEDF
		when @IntercompanyAccountSource = @kICTSourceCS then @kErrAcctCSDF
		else @kErrAcctJEDF
	end

	If @IsAccrual = 1
	begin
		-- start with a Due To, flip post side
		-- there will be 1 one line per target company (we need to group)
		 
		INSERT #tTransaction(
			CompanyKey
			,TransactionDate
			,Entity
			,EntityKey
			,Reference
			,GLAccountKey
			,Debit
			,Credit
			,ClassKey
			,Memo
			,ClientKey
			,ProjectKey
			,SourceCompanyKey
			,DepositKey
			,PostSide
			,GLCompanyKey
			,OfficeKey
			,DepartmentKey
			,DetailLineKey
			,Section
			,GLAccountErrRet
			,ICTGLCompanyKey
			,CurrencyID
			,ExchangeRate
			,HDebit
			,HCredit
			)
		select 
			@CompanyKey
			,@TransactionDate
			,@Entity
			,@EntityKey
			,@Reference
			,case when @IntercompanyAccountSource = @kICTSourceAP then glcm.APDueToAccountKey
			      when @IntercompanyAccountSource = @kICTSourceAR then glcm.ARDueToAccountKey
				  when @IntercompanyAccountSource = @kICTSourceJE then glcm.JEDueToAccountKey
				  when @IntercompanyAccountSource = @kICTSourceCS then glcm.CSDueToAccountKey
			end
			,0           -- Debit
			,SUM(t.Debit)  --Credit -- must flip the debits
			,NULL --ClassKey
			,@Memo
			,NULL -- ClientKey
			,NULL -- ProjectKey
			,NULL ---SourceCompanyKey
			,NULL --DepositKey
			,'C' --PostSide
			,t.GLCompanyKey
			,NULL --OfficeKey
			,NULL --DepartmentKey
			,NULL --DetailLineKey
			,@kSectionICT --Section
			,@ErrAcctJEDT --GLAccountErrRet
			,@SourceGLCompanyKey
			,t.CurrencyID
			,isnull(t.ExchangeRate, 1)
			,0           -- Debit
			,SUM(t.HDebit)  --Credit -- must flip the debits
		from  #tTransaction t
			left outer join tGLCompanyMap glcm (nolock) on glcm.SourceGLCompanyKey = @SourceGLCompanyKey 
						and  glcm.TargetGLCompanyKey = t.GLCompanyKey 
		where t.Entity = @Entity
		and   t.EntityKey = @EntityKey 
		and   isnull(t.GLCompanyKey,0) <> @SourceGLCompanyKey
		and   t.Section in (@kSectionLine)
		and   t.PostSide = 'D'

		group by t.GLCompanyKey
		,case when @IntercompanyAccountSource = @kICTSourceAP then glcm.APDueToAccountKey
			      when @IntercompanyAccountSource = @kICTSourceAR then glcm.ARDueToAccountKey
				  when @IntercompanyAccountSource = @kICTSourceJE then glcm.JEDueToAccountKey
				  when @IntercompanyAccountSource = @kICTSourceCS then glcm.CSDueToAccountKey
			end
		, t.CurrencyID, isnull(t.ExchangeRate, 1)

		INSERT #tTransaction(
			CompanyKey
			,TransactionDate
			,Entity
			,EntityKey
			,Reference
			,GLAccountKey
			,Debit
			,Credit
			,ClassKey
			,Memo
			,ClientKey
			,ProjectKey
			,SourceCompanyKey
			,DepositKey
			,PostSide
			,GLCompanyKey
			,OfficeKey
			,DepartmentKey
			,DetailLineKey
			,Section
			,GLAccountErrRet
			,ICTGLCompanyKey
			,CurrencyID
			,ExchangeRate
			,HDebit
			,HCredit
			)
		select 
			@CompanyKey
			,@TransactionDate
			,@Entity
			,@EntityKey
			,@Reference
			,case when @IntercompanyAccountSource = @kICTSourceAP then glcm.APDueToAccountKey
			      when @IntercompanyAccountSource = @kICTSourceAR then glcm.ARDueToAccountKey
				  when @IntercompanyAccountSource = @kICTSourceJE then glcm.JEDueToAccountKey
				  when @IntercompanyAccountSource = @kICTSourceCS then glcm.CSDueToAccountKey
			end
			,SUM(t.Credit) -- Debit
  			,0             -- Credit
			,NULL --ClassKey
			,@Memo
			,NULL -- ClientKey
			,NULL -- ProjectKey
			,NULL ---SourceCompanyKey
			,NULL --DepositKey
			,'D' --PostSide
			,t.GLCompanyKey
			,NULL --OfficeKey
			,NULL --DepartmentKey
			,NULL --DetailLineKey
			,@kSectionICT --Section
			,@ErrAcctJEDT --GLAccountErrRet
			,@SourceGLCompanyKey
			,t.CurrencyID
			,isnull(t.ExchangeRate, 1)
			,SUM(t.HCredit) -- Debit
  			,0             -- Credit
		from  #tTransaction t
			left outer join tGLCompanyMap glcm (nolock) on glcm.SourceGLCompanyKey = @SourceGLCompanyKey 
						and  glcm.TargetGLCompanyKey = t.GLCompanyKey 
		where t.Entity = @Entity
		and   t.EntityKey = @EntityKey 
		and   isnull(t.GLCompanyKey,0) <> @SourceGLCompanyKey
		and   t.Section in (@kSectionLine)
		and   t.PostSide = 'C'

		group by t.GLCompanyKey
				,case when @IntercompanyAccountSource = @kICTSourceAP then glcm.APDueToAccountKey
			      when @IntercompanyAccountSource = @kICTSourceAR then glcm.ARDueToAccountKey
				  when @IntercompanyAccountSource = @kICTSourceJE then glcm.JEDueToAccountKey
				  when @IntercompanyAccountSource = @kICTSourceCS then glcm.CSDueToAccountKey
			end
			, t.CurrencyID, isnull(t.ExchangeRate, 1)

		-- then Due From 
		-- there will be 1 one line per target company (no need to group here)
		
		INSERT #tTransaction(
			CompanyKey
			,TransactionDate
			,Entity
			,EntityKey
			,Reference
			,GLAccountKey
			,Debit
			,Credit
			,ClassKey
			,Memo
			,ClientKey
			,ProjectKey
			,SourceCompanyKey
			,DepositKey
			,PostSide
			,GLCompanyKey
			,OfficeKey
			,DepartmentKey
			,DetailLineKey
			,Section
			,GLAccountErrRet
			,ICTGLCompanyKey
			,CurrencyID
			,ExchangeRate
			,HDebit
			,HCredit
			)
		select 
			@CompanyKey
			,@TransactionDate
			,@Entity
			,@EntityKey
			,@Reference
			,case when @IntercompanyAccountSource = @kICTSourceAP then glcm.APDueFromAccountKey
			      when @IntercompanyAccountSource = @kICTSourceAR then glcm.ARDueFromAccountKey
				  when @IntercompanyAccountSource = @kICTSourceJE then glcm.JEDueFromAccountKey
				  when @IntercompanyAccountSource = @kICTSourceCS then glcm.CSDueFromAccountKey
			end
			,t.Credit      --Debit -- must flip the Credits -- no grouping
			,t.Debit       --Credit 
			,NULL --ClassKey
			,@Memo
			,NULL -- ClientKey
			,NULL -- ProjectKey
			,NULL ---SourceCompanyKey
			,NULL --DepositKey
			,case when t.PostSide = 'D' then 'C' else 'D' end --PostSide flipped
			,@SourceGLCompanyKey
			,NULL --OfficeKey
			,NULL --DepartmentKey
			,NULL --DetailLineKey
			,@kSectionICT --Section
			,@ErrAcctJEDF --GLAccountErrRet
			,t.GLCompanyKey
			,t.CurrencyID
			,isnull(t.ExchangeRate, 1)
			,t.HCredit      --Debit -- must flip the Credits -- no grouping
			,t.HDebit       --Credit 
		from  #tTransaction t
			left outer join tGLCompanyMap glcm (nolock) on glcm.SourceGLCompanyKey = @SourceGLCompanyKey 
						and  glcm.TargetGLCompanyKey = t.GLCompanyKey 
		where t.Entity = @Entity
		and   t.EntityKey = @EntityKey 
		and   isnull(t.GLCompanyKey,0) <> @SourceGLCompanyKey
		and   t.Section = @kSectionICT

	end -- IsAccrual

	else

	begin
		-- Cash Basis

		-- start with a Due To, flip post side
		-- there will be 1 one line per target company (we need to group)
		 
		INSERT #tCashTransaction(
			CompanyKey
			,TransactionDate
			,Entity
			,EntityKey
			,Reference
			,GLAccountKey
			,Debit
			,Credit
			,ClassKey
			,Memo
			,ClientKey
			,ProjectKey
			,SourceCompanyKey
			,DepositKey
			,PostSide
			,GLCompanyKey
			,OfficeKey
			,DepartmentKey
			,DetailLineKey
			,Section
			,GLAccountErrRet
			,ICTGLCompanyKey
			,CurrencyID
			,ExchangeRate
			,HDebit
			,HCredit
			)
		select 
			@CompanyKey
			,@TransactionDate
			,@Entity
			,@EntityKey
			,@Reference
			,case when @IntercompanyAccountSource = @kICTSourceAP then glcm.APDueToAccountKey
			      when @IntercompanyAccountSource = @kICTSourceAR then glcm.ARDueToAccountKey
				  when @IntercompanyAccountSource = @kICTSourceJE then glcm.JEDueToAccountKey
				  when @IntercompanyAccountSource = @kICTSourceCS then glcm.CSDueToAccountKey
			end
			,0           -- Debit
			,SUM(t.Debit)  --Credit -- must flip the debits
			,NULL --ClassKey
			,@Memo
			,NULL -- ClientKey
			,NULL -- ProjectKey
			,NULL ---SourceCompanyKey
			,NULL --DepositKey
			,'C' --PostSide
			,t.GLCompanyKey
			,NULL --OfficeKey
			,NULL --DepartmentKey
			,NULL --DetailLineKey
			,@kSectionICT --Section
			,@ErrAcctJEDT --GLAccountErrRet
			,@SourceGLCompanyKey
			,t.CurrencyID
			,isnull(t.ExchangeRate, 1)
			,0           -- Debit
			,SUM(t.HDebit)  --Credit -- must flip the debits
		from  #tCashTransaction t
			left outer join tGLCompanyMap glcm (nolock) on glcm.SourceGLCompanyKey = @SourceGLCompanyKey 
						and  glcm.TargetGLCompanyKey = t.GLCompanyKey 
		where t.Entity = @Entity
		and   t.EntityKey = @EntityKey 
		and   isnull(t.GLCompanyKey,0) <> @SourceGLCompanyKey
		and   t.Section in (@kSectionLine)
		and   t.PostSide = 'D'

		group by t.GLCompanyKey
		,case when @IntercompanyAccountSource = @kICTSourceAP then glcm.APDueToAccountKey
			      when @IntercompanyAccountSource = @kICTSourceAR then glcm.ARDueToAccountKey
				  when @IntercompanyAccountSource = @kICTSourceJE then glcm.JEDueToAccountKey
				  when @IntercompanyAccountSource = @kICTSourceCS then glcm.CSDueToAccountKey
			end
		, t.CurrencyID, isnull(t.ExchangeRate, 1)

		INSERT #tCashTransaction(
			CompanyKey
			,TransactionDate
			,Entity
			,EntityKey
			,Reference
			,GLAccountKey
			,Debit
			,Credit
			,ClassKey
			,Memo
			,ClientKey
			,ProjectKey
			,SourceCompanyKey
			,DepositKey
			,PostSide
			,GLCompanyKey
			,OfficeKey
			,DepartmentKey
			,DetailLineKey
			,Section
			,GLAccountErrRet
			,ICTGLCompanyKey
			,CurrencyID
			,ExchangeRate
			,HDebit
			,HCredit
			)
		select 
			@CompanyKey
			,@TransactionDate
			,@Entity
			,@EntityKey
			,@Reference
			,case when @IntercompanyAccountSource = @kICTSourceAP then glcm.APDueToAccountKey
			      when @IntercompanyAccountSource = @kICTSourceAR then glcm.ARDueToAccountKey
				  when @IntercompanyAccountSource = @kICTSourceJE then glcm.JEDueToAccountKey
				  when @IntercompanyAccountSource = @kICTSourceCS then glcm.CSDueToAccountKey
			end
			,SUM(t.Credit) -- Debit
  			,0             -- Credit
			,NULL --ClassKey
			,@Memo
			,NULL -- ClientKey
			,NULL -- ProjectKey
			,NULL ---SourceCompanyKey
			,NULL --DepositKey
			,'D' --PostSide
			,t.GLCompanyKey
			,NULL --OfficeKey
			,NULL --DepartmentKey
			,NULL --DetailLineKey
			,@kSectionICT --Section
			,@ErrAcctJEDT --GLAccountErrRet
			,@SourceGLCompanyKey
			,t.CurrencyID
			,isnull(t.ExchangeRate, 1)
			,SUM(t.HCredit) -- Debit
  			,0             -- Credit
		from  #tCashTransaction t
			left outer join tGLCompanyMap glcm (nolock) on glcm.SourceGLCompanyKey = @SourceGLCompanyKey 
						and  glcm.TargetGLCompanyKey = t.GLCompanyKey 
		where t.Entity = @Entity
		and   t.EntityKey = @EntityKey 
		and   isnull(t.GLCompanyKey,0) <> @SourceGLCompanyKey
		and   t.Section in (@kSectionLine)
		and   t.PostSide = 'C'

		group by t.GLCompanyKey
				,case when @IntercompanyAccountSource = @kICTSourceAP then glcm.APDueToAccountKey
			      when @IntercompanyAccountSource = @kICTSourceAR then glcm.ARDueToAccountKey
				  when @IntercompanyAccountSource = @kICTSourceJE then glcm.JEDueToAccountKey
				  when @IntercompanyAccountSource = @kICTSourceCS then glcm.CSDueToAccountKey
			end
		, t.CurrencyID, isnull(t.ExchangeRate, 1)


		-- then Due From 
		-- there will be 1 one line per target company (no need to group here)
		
		INSERT #tCashTransaction(
			CompanyKey
			,TransactionDate
			,Entity
			,EntityKey
			,Reference
			,GLAccountKey
			,Debit
			,Credit
			,ClassKey
			,Memo
			,ClientKey
			,ProjectKey
			,SourceCompanyKey
			,DepositKey
			,PostSide
			,GLCompanyKey
			,OfficeKey
			,DepartmentKey
			,DetailLineKey
			,Section
			,GLAccountErrRet
			,ICTGLCompanyKey
			,CurrencyID
			,ExchangeRate
			,HDebit
			,HCredit
			)
		select 
			@CompanyKey
			,@TransactionDate
			,@Entity
			,@EntityKey
			,@Reference
			,case when @IntercompanyAccountSource = @kICTSourceAP then glcm.APDueFromAccountKey
			      when @IntercompanyAccountSource = @kICTSourceAR then glcm.ARDueFromAccountKey
				  when @IntercompanyAccountSource = @kICTSourceJE then glcm.JEDueFromAccountKey
				  when @IntercompanyAccountSource = @kICTSourceCS then glcm.CSDueFromAccountKey
			end
			,t.Credit      --Debit -- must flip the Credits -- no grouping
			,t.Debit       --Credit 
			,NULL --ClassKey
			,@Memo
			,NULL -- ClientKey
			,NULL -- ProjectKey
			,NULL ---SourceCompanyKey
			,NULL --DepositKey
			,case when t.PostSide = 'D' then 'C' else 'D' end --PostSide flipped
			,@SourceGLCompanyKey
			,NULL --OfficeKey
			,NULL --DepartmentKey
			,NULL --DetailLineKey
			,@kSectionICT --Section
			,@ErrAcctJEDF --GLAccountErrRet
			,t.GLCompanyKey
			,t.CurrencyID
			,isnull(t.ExchangeRate, 1)
			,t.HCredit      --Debit -- must flip the Credits -- no grouping
			,t.HDebit       --Credit 
		from  #tCashTransaction t
			left outer join tGLCompanyMap glcm (nolock) on glcm.SourceGLCompanyKey = @SourceGLCompanyKey 
						and  glcm.TargetGLCompanyKey = t.GLCompanyKey 
		where t.Entity = @Entity
		and   t.EntityKey = @EntityKey 
		and   isnull(t.GLCompanyKey,0) <> @SourceGLCompanyKey
		and   t.Section = @kSectionICT

	end -- Cash basis


end -- JE




	RETURN 1
GO
