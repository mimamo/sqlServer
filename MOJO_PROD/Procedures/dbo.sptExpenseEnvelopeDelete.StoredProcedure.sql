USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptExpenseEnvelopeDelete]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptExpenseEnvelopeDelete]
 @ExpenseEnvelopeKey int
AS --Encrypt

  /*
  || When     Who Rel   What
  || 02/15/07 GHL 8.4   Added project rollup section   
  || 08/03/08 GWG 10.006 Removed the checked for sent for approval.               
  */

declare @Status int
 select @Status = Status
   from tExpenseEnvelope (nolock)
  where ExpenseEnvelopeKey = @ExpenseEnvelopeKey
  
  
 if @Status = 4 --approved
  return -4 
 
 CREATE TABLE #ProjectRollup (ProjectKey INT NULL)
 
 INSERT #ProjectRollup (ProjectKey)
 SELECT DISTINCT ProjectKey
 FROM   tExpenseReceipt (NOLOCK)
 WHERE  ExpenseEnvelopeKey = @ExpenseEnvelopeKey
 AND    ProjectKey IS NOT NULL
 
 delete tExpenseReceipt
  where ExpenseEnvelopeKey = @ExpenseEnvelopeKey
  
 DELETE
 FROM tExpenseEnvelope
 WHERE
  ExpenseEnvelopeKey = @ExpenseEnvelopeKey 

 DECLARE @ProjectKey INT
 SELECT @ProjectKey = -1
 WHILE (1=1)
 BEGIN
	SELECT @ProjectKey = MIN(ProjectKey)
	FROM   #ProjectRollup
	WHERE  ProjectKey > @ProjectKey
	
	IF @ProjectKey IS NULL
		BREAK
		
	-- Rollup project, TranType = ExpenseReceipt or 3, Base + approved rollup	
	EXEC sptProjectRollupUpdate @ProjectKey, 3, 1, 1, 1, 1
 END

 RETURN 1
GO
