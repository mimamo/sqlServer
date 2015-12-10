USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQBGLAcctInsert]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQBGLAcctInsert]
(	
	@CompanyKey int,
	@AccountNumber varchar(100),
	@AccountName varchar(200),
	@ParentAccountKey int,
	@AccountType smallint,
	@Rollup tinyint,
	@Description varchar(500),
	@BankAccountNumber varchar(50),
	@CurrentBalance money, 
	@NextCheckNumber bigint,
	@StatementDate datetime,
	@StatementBalance money,
	@Active tinyint,
	@LinkID varchar(100)
)

	
AS --Encrypt

/*
|| When     Who Rel			What
|| 11/2/06  CRG 8.35		Converted NextCheckNumber to bigint
|| 02/21/11 QMD 10.5.4.1	Updated parms for sptGLAccountInsert
*/

declare @RetVal integer
declare @GLAccountKey int

	select @GLAccountKey = GLAccountKey
	  from tGLAccount (nolock)
	 where LinkID = @LinkID
	   and CompanyKey = @CompanyKey
	 
if @GLAccountKey is null
  begin
	exec @RetVal = sptGLAccountInsert
	     @CompanyKey,
	     @AccountNumber,
	     @AccountName,
	     @ParentAccountKey,
	     @AccountType,
	     @AccountType,
	     null,
	     null,
	     null,
	     @Rollup,
	     @Description,
	     @BankAccountNumber,
	     @NextCheckNumber,
	     @Active,
	     @GLAccountKey output
			
	if @RetVal < 0 
		return -1
		
	update tGLAccount
	   set CurrentBalance = @CurrentBalance, 
		   StatementDate = @StatementDate,
		   StatementBalance = @StatementBalance,
		   LinkID = @LinkID
     where GLAccountKey = @GLAccountKey
  end
else
	update tGLAccount
	   set AccountNumber = @AccountNumber,
	       AccountName = @AccountName,
	       ParentAccountKey = @ParentAccountKey,
	       AccountType = @AccountType,
	       [Rollup] = @Rollup,
	       Description = @Description,
	       BankAccountNumber = @BankAccountNumber,
	       NextCheckNumber = @NextCheckNumber
	 where GLAccountKey = @GLAccountKey

 
	return @GLAccountKey
GO
