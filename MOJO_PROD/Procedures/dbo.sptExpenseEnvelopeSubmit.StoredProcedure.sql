USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptExpenseEnvelopeSubmit]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptExpenseEnvelopeSubmit]
 @ExpenseEnvelopeKey int
AS --Encrypt

  /*
  || When     Who Rel   What
  || 02/15/07 GHL 8.4   Added project rollup section   
  || 03/27/08 GHL 8.507 (23645) Error out if no expense receipt             
  || 10/25/11 GWG 10.549 Changed the submit to auto figure out the start and end dates  
  || 10/26/11 CRG 10.5.4.9 Changed EndDate to Max(ExpenseDate)   
  */

	DECLARE	@StartDate smalldatetime,
			@EndDate smalldatetime,
			@UserKey int,
			@Approver int
						
	SELECT	@UserKey = UserKey
	FROM	tExpenseEnvelope (nolock)
	WHERE	ExpenseEnvelopeKey = @ExpenseEnvelopeKey

	SELECT	@StartDate = Min(ExpenseDate),
			@EndDate = Max(ExpenseDate)
	FROM	tExpenseReceipt (nolock)
	WHERE	ExpenseEnvelopeKey = @ExpenseEnvelopeKey
   
	IF NOT EXISTS (SELECT 1
					FROM   tExpenseReceipt (NOLOCK)
					WHERE  ExpenseEnvelopeKey = @ExpenseEnvelopeKey
				   )
		RETURN -2
   
	update tExpenseEnvelope
		set Status = 2
		,StartDate = @StartDate
		,EndDate = @EndDate
		,ApprovalComments = null
		,DateSubmitted = getdate()
	where ExpenseEnvelopeKey = @ExpenseEnvelopeKey 

	Select @Approver = ExpenseApprover from tUser (nolock) Where UserKey = @UserKey
	if @Approver = @UserKey
	BEGIN
		Declare @DateApproved smalldatetime
		Select @DateApproved = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)
		Update tExpenseEnvelope Set Status = 4, DateApproved = @DateApproved Where ExpenseEnvelopeKey = @ExpenseEnvelopeKey 
	END
	
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
	
	return 1
GO
