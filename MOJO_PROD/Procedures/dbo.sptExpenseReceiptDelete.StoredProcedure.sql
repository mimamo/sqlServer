USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptExpenseReceiptDelete]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptExpenseReceiptDelete]
	@ExpenseReceiptKey int
	,@DoProjectRollup int = 1

AS --Encrypt

  /*
  || When     Who Rel   What
  || 02/15/07 GHL 8.4   Added project rollup section     
  || 11/8/11  GHL 10550 (125072) Added DoProjectRollup param so that we can choose to rollup or not                        
  */

	DECLARE @ProjectKey INT
	
	if @DoProjectRollup = 1
		SELECT @ProjectKey = ProjectKey
		FROM   tExpenseReceipt (NOLOCK)
		WHERE  ExpenseReceiptKey = @ExpenseReceiptKey
  
	DELETE
	FROM tExpenseReceipt
	WHERE
		ExpenseReceiptKey = @ExpenseReceiptKey 

	if @DoProjectRollup = 0
		return 1

	DECLARE	@TranType INT,@BaseRollup INT,@Approved INT,@Unbilled INT,@WriteOff INT
	SELECT	@TranType = 3,@BaseRollup = 1,@Approved = 1,@Unbilled = 1,@WriteOff = 1
	EXEC sptProjectRollupUpdate @ProjectKey, @TranType, @BaseRollup,@Approved,@Unbilled,@WriteOff

	RETURN 1
GO
