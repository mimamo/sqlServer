USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaRevisionReasonDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaRevisionReasonDelete]
	@MediaRevisionReasonKey int

AS -- Encrypt

	DECLARE @CompanyKey INt
	
	SELECT @CompanyKey = CompanyKey
	FROM tMediaRevisionReason (NOLOCK)
	WHERE
		MediaRevisionReasonKey = @MediaRevisionReasonKey 

	IF EXISTS (SELECT 1
				FROM  tPurchaseOrderDetail pod (NOLOCK)
				INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
				WHERE po.CompanyKey = @CompanyKey
				AND   pod.MediaRevisionReasonKey = @MediaRevisionReasonKey
				)
			RETURN -1
	
	DELETE
	FROM tMediaRevisionReason
	WHERE
		MediaRevisionReasonKey = @MediaRevisionReasonKey 

	RETURN 1
GO
