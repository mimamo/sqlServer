USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailGetByLineType]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sptPurchaseOrderDetailGetByLineType]
	@PurchaseOrderKey int,
	@LineType varchar(50),
	@LineNumber int = NULL
AS

/*
|| When      Who Rel      What
|| 1/2/14    CRG 10.5.7.6 Created to get buckets for the new media screens based on the line type
*/

	IF @LineNumber IS NULL
	BEGIN
		SELECT	LineNumber
		INTO	#LineNumbers
		FROM	tPurchaseOrderDetail (nolock)
		WHERE	PurchaseOrderKey = @PurchaseOrderKey
		AND		LineType = @LineType
		
		SELECT	*, UserDate1 AS StartDate, UserDate2 AS EndDate 
		FROM	tPurchaseOrderDetail (nolock) 
		WHERE	PurchaseOrderKey = @PurchaseOrderKey
		AND		LineNumber IN (SELECT LineNumber FROM #LineNumbers)
		ORDER BY UserDate1
	END
	ELSE
	BEGIN
		SELECT	*, UserDate1 AS StartDate, UserDate2 AS EndDate 
		FROM	tPurchaseOrderDetail (nolock) 
		WHERE	PurchaseOrderKey = @PurchaseOrderKey
		AND		LineNumber = @LineNumber
		ORDER BY UserDate1
	END
GO
