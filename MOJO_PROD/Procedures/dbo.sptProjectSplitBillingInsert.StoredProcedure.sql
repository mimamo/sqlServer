USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectSplitBillingInsert]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectSplitBillingInsert]
	@ProjectKey int,
	@ClientKey int,
	@PercentageSplit decimal(24,4),
	@oIdentity int OUTPUT

AS --Encrypt

/*
|| When      Who Rel     What
|| 10/22/07  CRG 8.5     (13583) Created for Enhancement
*/

	INSERT	tProjectSplitBilling
			(ProjectKey,
			ClientKey,
			PercentageSplit)
	VALUES	(@ProjectKey,
			@ClientKey,
			@PercentageSplit)
			
	SELECT	@oIdentity = @@IDENTITY
	
	RETURN 1
GO
