USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptExpenseEnvelopeSetPaid]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptExpenseEnvelopeSetPaid]
	@ExpenseEnvelopeKey int,
	@EnvelopeNumber varchar(200),
	@CompanyKey int,
	@UserKey int

	
AS  --Encrypt
 /*
  || When     Who Rel   What
  || 02/07/13 RLB 10565 Added logging
  */

	DECLARE @Date smalldatetime
  
	SELECT @Date = GETUTCDATE()	

		EXEC sptActionLogInsert 'Expense Report',@ExpenseEnvelopeKey, @CompanyKey, 0, 'Paid', @Date, NULL, 'Expense Report was marked paid', @EnvelopeNumber, NULL, @UserKey 

	UPDATE	tExpenseEnvelope
	SET		Paid = 1
	WHERE	ExpenseEnvelopeKey = @ExpenseEnvelopeKey
GO
