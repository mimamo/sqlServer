USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptJournalEntryCalcRoundingDiff]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptJournalEntryCalcRoundingDiff]
	(
	@CompanyKey int,
	@JournalEntryKey int
	)
AS --Encrypt

	SET NOCOUNT ON

/*
|| When     Who Rel    What
|| 01/27/15 GHL 10.588 (243736) When there is some foreign currency on the header or details
||                      calculate a rounding error in a way similar to posting, we will display 
||                      this rounding error on the UI for the user to be aware of this error
*/

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

	declare @kSectionMCRounding int					
		   ,@Prepost int
		   ,@CreateTemp int	
		   ,@MultiCurrency int

	select @MultiCurrency = MultiCurrency from tPreference (nolock) where CompanyKey = @CompanyKey

	select @Prepost = 1
	      ,@CreateTemp = 0
		  ,@kSectionMCRounding = 9

	-- call the GL posting routine in Prepost mode, no need to create the temp table
	if isnull(@MultiCurrency, 0) = 1
		exec spGLPostJournalEntry @CompanyKey, @JournalEntryKey, @Prepost, @CreateTemp

	-- and pickup any rounding error
	select top 1 * 
			,isnull(HDebit,0) + isnull(HCredit,0) as MCRoundingError
			,case when isnull(HDebit, 0) <> 0 then '(Debit)' else '(Credit)' end as MCRoundingType
	from #tTransaction 
	where Section = @kSectionMCRounding

	RETURN 1
GO
