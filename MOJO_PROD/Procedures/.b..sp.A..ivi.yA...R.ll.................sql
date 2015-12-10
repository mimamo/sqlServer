USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityAutoRoll]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityAutoRoll]
	@RollDate smalldatetime
AS

/*
|| When      Who Rel      What
|| 5/29/09   CRG 10.5.0.0 Created for the task manager to auto roll activities.
*/

	UPDATE	tActivity
	SET		ActivityDate = @RollDate
	FROM	tActivity a
	INNER JOIN tActivityType type ON a.ActivityTypeKey = type.ActivityTypeKey
	WHERE	type.AutoRollDate = 1
	AND		ISNULL(a.Completed, 0) = 0
	AND		a.ActivityDate < @RollDate
GO
