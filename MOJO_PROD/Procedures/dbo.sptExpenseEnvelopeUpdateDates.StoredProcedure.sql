USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptExpenseEnvelopeUpdateDates]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptExpenseEnvelopeUpdateDates]
	@ExpenseEnvelopeKey int
AS --Encrypt

/*
|| When      Who Rel     What
|| 8/20/07   CRG 8.5     (9833) Created to update the Start and End Date to the first and last date of the associated Expense Receipts
*/

	DECLARE	@StartDate smalldatetime,
			@EndDate smalldatetime
			
	SELECT	@StartDate = MIN(ExpenseDate), @EndDate = MAX(ExpenseDate)
	FROM	tExpenseReceipt (nolock)
	WHERE	ExpenseEnvelopeKey = @ExpenseEnvelopeKey
	
	UPDATE	tExpenseEnvelope
	SET		StartDate = ISNULL(@StartDate, DateCreated),
			EndDate = ISNULL(@EndDate, DateCreated)
	WHERE	ExpenseEnvelopeKey = @ExpenseEnvelopeKey
GO
