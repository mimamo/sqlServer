USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectSplitBillingUpdate]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectSplitBillingUpdate]
	@ProjectSplitBillingKey int,
	@ClientKey int,
	@PercentageSplit decimal(24,4)

AS --Encrypt

/*
|| When      Who Rel     What
|| 10/22/07  CRG 8.5     (13583) Created for Enhancement
*/

	UPDATE	tProjectSplitBilling
	SET		ClientKey = @ClientKey,
			PercentageSplit = @PercentageSplit
	WHERE	ProjectSplitBillingKey = @ProjectSplitBillingKey
	
	RETURN 1
GO
