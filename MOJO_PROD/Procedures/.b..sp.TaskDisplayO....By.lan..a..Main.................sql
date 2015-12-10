USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskDisplayOrderByPlanStartMain]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTaskDisplayOrderByPlanStartMain]
(
	@ProjectKey int
)

AS --Encrypt

CREATE TABLE #tTask (TaskKey INT NULL, TaskLevel INT NULL, 
					 SummaryTaskKey INT NULL, PlanStart DATETIME NULL, MyID INT NULL)
					 
DECLARE @MyID INT
SELECT  @MyID = 0

-- PlanStart is not reliable to sort, let us use our own ID
INSERT  #tTask (TaskKey, TaskLevel, SummaryTaskKey, PlanStart)
SELECT  TaskKey, TaskLevel, SummaryTaskKey, PlanStart
FROM    tTask (NOLOCK) 
WHERE   ProjectKey = @ProjectKey
ORDER By TaskLevel, PlanStart, TaskKey

UPDATE  #tTask SET MyID = @MyID, @MyID = @MyID + 1

Exec sptTaskDisplayOrderByPlanStartLoop @ProjectKey, 0

DROP TABLE #tTask

Return 1
GO
