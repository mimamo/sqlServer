USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptExpenseEnvelopeReject]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptExpenseEnvelopeReject]

	(
		@ExpenseEnvelopeKey int,
		@ApprovalComments varchar(300) = NULL		
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 8/27/07  CRG 8.5   (9833) Created to mark an ExpenseEnvelope as Rejected.
  */

	if exists (select 1 from tExpenseReceipt (nolock) Where ExpenseEnvelopeKey = @ExpenseEnvelopeKey and (InvoiceLineKey is not null OR WIPPostingInKey > 0 OR WIPPostingOutKey > 0))
		return -1
		
if @ApprovalComments is null
	Update tExpenseEnvelope
	Set Status = 3
	Where ExpenseEnvelopeKey = @ExpenseEnvelopeKey
else
	Update tExpenseEnvelope
	Set Status = 3,
		ApprovalComments = @ApprovalComments
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
GO
