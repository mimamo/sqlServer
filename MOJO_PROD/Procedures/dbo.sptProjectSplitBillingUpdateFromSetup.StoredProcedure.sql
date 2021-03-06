USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectSplitBillingUpdateFromSetup]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectSplitBillingUpdateFromSetup]
	@ProjectKey int
AS --Encrypt

/*
|| When      Who Rel     What
|| 4/17/08   CRG 1.0.0.0 Created to update the Billing Schedule from the WMJ screen
*/

	/* Assume done in VB...
	CREATE TABLE #tSetupSplitBilling
		(ProjectSplitBillingKey int NULL
		ProjectKey int NULL
		ClientKey int NULL
		PercentageSplit decimal(24, 4) NULL)
	*/
	
	DELETE	tProjectSplitBilling
	WHERE	ProjectKey = @ProjectKey
	AND		ProjectSplitBillingKey NOT IN (SELECT DISTINCT ProjectSplitBillingKey FROM #tSetupSplitBilling)
	
	UPDATE	tProjectSplitBilling
	SET		ClientKey = tmp.ClientKey,
			PercentageSplit = tmp.PercentageSplit
	FROM	#tSetupSplitBilling tmp
	WHERE	tProjectSplitBilling.ProjectSplitBillingKey = tmp.ProjectSplitBillingKey
	
	INSERT	tProjectSplitBilling
			(ProjectKey,
			ClientKey,
			PercentageSplit)
	SELECT	ProjectKey,
			ClientKey,
			PercentageSplit
	FROM	#tSetupSplitBilling
	WHERE	ISNULL(ProjectSplitBillingKey, 0) = 0
GO
