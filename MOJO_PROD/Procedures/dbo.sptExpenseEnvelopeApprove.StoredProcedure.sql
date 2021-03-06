USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptExpenseEnvelopeApprove]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptExpenseEnvelopeApprove]

	(
		@ExpenseEnvelopeKey int,
		@ApprovalComments varchar(300) = NULL
	)

AS --Encrypt

  /*
  || When     Who Rel     What
  || 02/15/07 GHL 8.4     Added project rollup section   
  || 2/6/08   CRG 1.0.0.0 Fixed bug where it was not saving the ApprovalComments     
  || 10/25/11 GWG 10.549 Changed the submit to auto figure out the start and end dates
  || 10/26/11 CRG 10.5.4.9 Changed EndDate to Max(ExpenseDate)      
  */

	DECLARE	@StartDate smalldatetime,
			@EndDate smalldatetime
			
	SELECT	@StartDate = Min(ExpenseDate),
			@EndDate = Max(ExpenseDate)
	FROM	tExpenseReceipt (nolock)
	WHERE	ExpenseEnvelopeKey = @ExpenseEnvelopeKey
			
	Update tExpenseEnvelope
	Set Status = 4,
		StartDate = @StartDate,
		EndDate = @EndDate,
		ApprovalComments = @ApprovalComments,
		DateApproved = GETDATE()
	Where ExpenseEnvelopeKey = @ExpenseEnvelopeKey

 DECLARE @ProjectKey INT
 SELECT @ProjectKey = -1
 WHILE (1=1)
 BEGIN
	SELECT @ProjectKey = MIN(ProjectKey)
	FROM   tExpenseReceipt (NOLOCK)
	WHERE  ExpenseEnvelopeKey = @ExpenseEnvelopeKey
	AND    ProjectKey > @ProjectKey
	
	IF @ProjectKey IS NULL
		BREAK
		
	-- Rollup project, TranType = ExpenseReceipt or 3, approved rollup	
	EXEC sptProjectRollupUpdate @ProjectKey, 3, 0, 1, 0, 0
 END
	
 
	
	RETURN 1
GO
