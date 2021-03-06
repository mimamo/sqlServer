USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailGetBucketSummary]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sptPurchaseOrderDetailGetBucketSummary]
	@PurchaseOrderKey int,
	@LineNumber int,
	@UseBucketNumber tinyint = 0
AS

/*
|| When      Who Rel      What
|| 1/16/14   CRG 10.5.7.6 Created
|| 2/28/14   CRG 10.5.7.7 Added @UseBucketNumber
*/

	CREATE TABLE #Buckets
		(PurchaseOrderDetailKey int NULL,
		MonthNum int NULL,
		Quantity decimal(24,4) NULL,
		UnitCost money NULL,
		UnitRate money NULL,
		BillableCost money NULL,
		GrossAmount money NULL,
		TotalCost money NULL,
		Commission decimal(24, 4) NULL,
		Billed tinyint NULL,
		StartDate smalldatetime NULL,
		EndDate smalldatetime NULL)

	INSERT	#Buckets
			(PurchaseOrderDetailKey,
			MonthNum,
			Quantity,
			BillableCost,
			GrossAmount,
			TotalCost,
			StartDate,
			EndDate)
	SELECT	CASE @UseBucketNumber
				WHEN 1 THEN MIN(PurchaseOrderDetailKey)
				ELSE NULL
			END,
			CASE @UseBucketNumber
				WHEN 1 THEN Bucket
				ELSE MONTH(UserDate1)
			END,
			SUM(Quantity) AS Quantity,
			SUM(BillableCost) AS BillableCost,
			SUM(GrossAmount) AS GrossAmount,
			SUM(TotalCost) AS TotalCost,
			MIN(UserDate1),
			MIN(UserDate2)
	FROM	tPurchaseOrderDetail (nolock)
	WHERE	PurchaseOrderKey = @PurchaseOrderKey
	AND		LineNumber = @LineNumber
	GROUP BY MONTH(UserDate1), Bucket

	UPDATE	#Buckets
	SET		UnitRate =
				CASE
					WHEN ISNULL(Quantity, 0) = 0 THEN 0
					ELSE GrossAmount / Quantity
				END,
			UnitCost =
				CASE
					WHEN ISNULL(Quantity, 0) = 0 THEN 0
					ELSE TotalCost / Quantity
				END,
			Billed = 1 --Init to billed, then set to 0 if there exists an unbilled bucket (or revision) for that month
	
	IF @UseBucketNumber = 1
	BEGIN
		UPDATE	#Buckets
		SET		Commission = tPurchaseOrderDetail.Commission,
				Billed = 
					CASE 
						WHEN tPurchaseOrderDetail.InvoiceLineKey IS NOT NULL THEN 1
						ELSE 0
					END
		FROM	tPurchaseOrderDetail
		WHERE	tPurchaseOrderDetail.PurchaseOrderDetailKey = #Buckets.PurchaseOrderDetailKey
	END
	ELSE
	BEGIN
		UPDATE	#Buckets
		SET		Commission = tPurchaseOrderDetail.Commission
		FROM	tPurchaseOrderDetail
		WHERE	tPurchaseOrderDetail.PurchaseOrderKey = @PurchaseOrderKey
		AND		tPurchaseOrderDetail.LineNumber = @LineNumber
		AND		MONTH(tPurchaseOrderDetail.UserDate1) = #Buckets.MonthNum
		
		DECLARE	@MonthNum int
		SELECT	@MonthNum = 0

		DECLARE	@PurchaseOrderDetailKey int

		WHILE (1=1)
		BEGIN
			SELECT	@MonthNum = MIN(MonthNum)
			FROM	#Buckets
			WHERE	MonthNum > @MonthNum
			
			IF @MonthNum IS NULL
				BREAK
				
			SELECT	@PurchaseOrderDetailKey = MAX(PurchaseOrderDetailKey)
			FROM	tPurchaseOrderDetail (nolock)
			WHERE	PurchaseOrderKey = @PurchaseOrderKey
			AND		LineNumber = @LineNumber
			AND		MONTH(UserDate1) = @MonthNum
			AND		InvoiceLineKey IS NULL
			
			IF ISNULL(@PurchaseOrderDetailKey, 0) <> 0
				UPDATE	#Buckets
				SET		PurchaseOrderDetailKey = @PurchaseOrderDetailKey,
						Billed = 0
				WHERE	MonthNum = @MonthNum
		END
	END
	
	SELECT	#Buckets.*, #Buckets.MonthNum AS Bucket, pod.PurchaseOrderKey, @LineNumber AS LineNumber
	FROM	#Buckets
	LEFT JOIN tPurchaseOrderDetail pod (nolock) ON #Buckets.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
	ORDER BY MonthNum
GO
