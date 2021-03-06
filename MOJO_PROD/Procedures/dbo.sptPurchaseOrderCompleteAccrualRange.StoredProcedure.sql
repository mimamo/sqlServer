USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderCompleteAccrualRange]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderCompleteAccrualRange]
	(
	@CompanyKey int
	,@StartDate smalldatetime			
	,@EndDate smalldatetime
	,@PostingDate smalldatetime
	,@UserKey int = NULL	
	)
AS --Encrypt

DECLARE @PurchaseOrderKey int
DECLARE @VoucherKey int

	SELECT @PurchaseOrderKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @PurchaseOrderKey = MIN(PurchaseOrderKey)
		FROM   tPurchaseOrder (NOLOCK)
		WHERE  CompanyKey = @CompanyKey   
		AND    PurchaseOrderKey > @PurchaseOrderKey
		AND    PODate >= @StartDate AND PODate <= @EndDate
		
		IF @PurchaseOrderKey IS NULL
			BREAK
	
		EXEC sptPurchaseOrderCompleteAccrual @PurchaseOrderKey, NULL, @UserKey, @PostingDate, @VoucherKey OUTPUT
	
	END
GO
