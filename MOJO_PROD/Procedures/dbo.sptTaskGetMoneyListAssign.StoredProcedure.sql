USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetMoneyListAssign]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskGetMoneyListAssign]
	(
		@ProjectKey int
	)
AS --Encrypt

  /*
  || When     Who Rel   What
  || 12/14/06 GHL 8.4   Modified to use tasks instead of assignments 
  ||                    
  */
  
Select * 
      ,TaskType AS BudgetTaskType
From   tTask (NOLOCK)
Where  ProjectKey = @ProjectKey 
and	   (MoneyTask = 1
		OR 
		ISNULL(BudgetTaskKey, 0) > 0
		)
Order By ProjectOrder
GO
