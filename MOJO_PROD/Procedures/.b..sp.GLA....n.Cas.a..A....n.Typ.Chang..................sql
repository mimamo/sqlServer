USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountCascadeAccountTypeChange]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountCascadeAccountTypeChange]
	@GLAccountKey int,
	@AccountType smallint
AS --Encrypt

/*
|| When      Who Rel      What
|| 06/18/12  RLB 10.5.5.7 Change for HMI Allow Retained Earnings under Equity Does not Close Account type but do not changes it account type
*/
	DECLARE	@LoopKey int
	
	IF ISNULL(@AccountType,0) = 0
		RETURN
	
	--Update all of the account types for its children

	IF @AccountType = 30
	BEGIN
		UPDATE	tGLAccount
		SET		AccountType = @AccountType
		WHERE	ParentAccountKey = @GLAccountKey
		AND     AccountType <> 32
	END
	ELSE
	BEGIN
		UPDATE	tGLAccount
		SET		AccountType = @AccountType
		WHERE	ParentAccountKey = @GLAccountKey
	END

	
	
	--Check to see if any of the child accounts have children of their own
	--If so, recurrsively call the SP
	SELECT	@LoopKey = 0
	
	WHILE (1=1)
		BEGIN
			IF @LoopKey IS NULL
				RETURN

			--Get the next GLAccountKey	from the children			
			SELECT	@LoopKey = MIN(GLAccountKey)	
			FROM	tGLAccount (NOLOCK)
			WHERE	ParentAccountKey = @GLAccountKey
			AND		GLAccountKey > @LoopKey
			
			--Check to see if any accounts use this account as a parent
			IF EXISTS
					(SELECT 1
					FROM	tGLAccount (NOLOCK)
					WHERE	ParentAccountKey = @LoopKey)
				BEGIN
					--If so, call the SP again for this account
					EXEC sptGLAccountCascadeAccountTypeChange @LoopKey, @AccountType
				END
		END
	
	RETURN 1
GO
