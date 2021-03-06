USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportGLAccount]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportGLAccount]

	(
		@CompanyKey int,
		@AccountNumber varchar(100),
		@AccountName varchar(200),
		@AccountType smallint,
		@Rollup tinyint,
		@ParentAccountNumber varchar(100),
		@Description varchar(500)
	)

AS --Encrypt

Declare @PAKey int
Declare @PARollup tinyint
Declare @ParentAccountType smallint

Select @PAKey = GLAccountKey, @PARollup = Rollup 
from tGLAccount gl (nolock)
Where	gl.CompanyKey = @CompanyKey
and		gl.AccountNumber = @ParentAccountNumber

if not @PAKey is null
	if @PARollup <> 1
		Return -4
		
if @PAKey is null and @ParentAccountNumber is not null
	return -5
	
IF EXISTS(SELECT 1 FROM tGLAccount (nolock) WHERE AccountNumber = @AccountNumber AND CompanyKey = @CompanyKey)
	RETURN -1

IF @AccountType = 32
	IF EXISTS(SELECT 1 FROM tGLAccount (nolock) WHERE AccountType = 32 AND CompanyKey = @CompanyKey)
		RETURN -2
			
if not @AccountType is null
	if not @AccountType in (0,10,11,12,13,14,20,21,22,30,31,32,40,41,50,51,52)
		Return -3
		
IF not @PAKey is null
BEGIN
	select @ParentAccountType = AccountType from tGLAccount (nolock) Where GLAccountKey = @PAKey
	if @ParentAccountType <> @AccountType
		return -12
END

	INSERT tGLAccount
		(
		CompanyKey,
		AccountNumber,
		AccountName,
		ParentAccountKey,
		AccountType,
		Rollup,
		Description,
		BankAccountNumber,
		NextCheckNumber,
		Active
		)

	VALUES
		(
		@CompanyKey,
		@AccountNumber,
		@AccountName,
		@PAKey,
		@AccountType,
		@Rollup,
		@Description,
		NULL,
		0,
		1
		)

exec sptGLAccountOrder @CompanyKey, 0, 0, -1
GO
