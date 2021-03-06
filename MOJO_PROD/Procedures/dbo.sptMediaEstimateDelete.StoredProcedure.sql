USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaEstimateDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaEstimateDelete]
	@MediaEstimateKey int

AS --Encrypt

	If exists(Select 1 from tPurchaseOrder (nolock) Where MediaEstimateKey = @MediaEstimateKey)
		Return -1

	DELETE
	FROM tMediaEstimate
	WHERE
		MediaEstimateKey = @MediaEstimateKey 

	RETURN 1
GO
