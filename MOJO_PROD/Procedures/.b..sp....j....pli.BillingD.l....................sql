USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectSplitBillingDelete]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectSplitBillingDelete]
	@ProjectSplitBillingKey int
	
AS --Encrypt

/*
|| When      Who Rel     What
|| 10/22/07  CRG 8.5     (13583) Created for Enhancement
*/

	DELETE	tProjectSplitBilling
	WHERE	ProjectSplitBillingKey = @ProjectSplitBillingKey
	
	RETURN 1
GO
