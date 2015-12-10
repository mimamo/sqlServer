USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingScheduleUpdateFromSetup]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingScheduleUpdateFromSetup]
	@ProjectKey int
AS --Encrypt

/*
|| When      Who Rel     What
|| 4/17/08   CRG 1.0.0.0 Created to update the Billing Schedule from the WMJ screen
*/

	/* Assume done in VB...
	CREATE TABLE #tSetupBillingSchedule
		(BillingScheduleKey int NULL
		ProjectKey int NULL
		NextBillDate smalldatetime NULL
		TaskKey int NULL
		Comments varchar(4000) NULL)
	*/
	
	DELETE	tBillingSchedule
	WHERE	ProjectKey = @ProjectKey
	AND		BillingScheduleKey NOT IN (SELECT DISTINCT BillingScheduleKey FROM #tSetupBillingSchedule)
	
	UPDATE	tBillingSchedule
	SET		NextBillDate = tmp.NextBillDate,
			TaskKey = tmp.TaskKey,
			Comments = tmp.Comments
	FROM	#tSetupBillingSchedule tmp
	WHERE	tBillingSchedule.BillingScheduleKey = tmp.BillingScheduleKey
	
	INSERT	tBillingSchedule
			(ProjectKey,
			NextBillDate,
			Comments,
			TaskKey)
	SELECT	ProjectKey,
			NextBillDate,
			Comments,
			TaskKey
	FROM	#tSetupBillingSchedule
	WHERE	ISNULL(BillingScheduleKey, 0) = 0
GO
