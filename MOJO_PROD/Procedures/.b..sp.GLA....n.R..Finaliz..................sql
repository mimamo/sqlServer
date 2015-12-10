USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountRecFinalize]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountRecFinalize]

	(
		@GLAccountRecKey int
	)

AS

if exists(Select 1 from tGLAccountRec (nolock) Where GLAccountRecKey = @GLAccountRecKey and Completed = 1)
	return -1
	
Update tTransaction
	Set Cleared = 1
	from tGLAccountRecDetail ard (nolock)
	Where 
		tTransaction.TransactionKey = ard.TransactionKey and
		ard.GLAccountRecKey = @GLAccountRecKey
		

Update tDeposit
	Set Cleared = 1
	From tGLAccountRecDetail ard (nolock), tTransaction t (nolock) 
	Where
		ard.TransactionKey = t.TransactionKey and
		t.DepositKey = tDeposit.DepositKey and
		ard.GLAccountRecKey = @GLAccountRecKey
		
Declare @CurKey int
Select @CurKey = -1

While 1=1
BEGIN

	Select @CurKey = Min(DepositKey)
		From tGLAccountRecDetail ard (nolock), tTransaction t (nolock) 
		Where
			ard.TransactionKey = t.TransactionKey and
			ard.GLAccountRecKey = @GLAccountRecKey and
			t.DepositKey > @CurKey
			
	if @CurKey is null
		break
		
	Update tCheck 
		Set DepositKey = NULL
		Where
			DepositKey = @CurKey and
			Posted = 0

END

Update tGLAccountRec
	Set Completed = 1
	Where GLAccountRecKey = @GLAccountRecKey
GO
