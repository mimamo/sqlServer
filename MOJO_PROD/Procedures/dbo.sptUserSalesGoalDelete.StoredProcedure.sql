USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserSalesGoalDelete]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserSalesGoalDelete]

	@GoalKey int


AS --Encrypt
/*
|| When      Who Rel      What
|| 12/28/14  RLB 10.5.8.7 Created for New Sales Goals
*/

DELETE
FROM tGoal
WHERE
	GoalKey = @GoalKey 

RETURN 1
GO
