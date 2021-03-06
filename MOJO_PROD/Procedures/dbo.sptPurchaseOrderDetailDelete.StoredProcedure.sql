USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailDelete]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDetailDelete]

	@PurchaseOrderDetailKey int
	,@UserKey int = null


AS --Encrypt

 /*
  || When     Who Rel      What
  || 02/20/07 GHL 8.4      Added project rollup section
  || 07/30/07 BSH 8.4.3.3  (10744)Fix PurchaseOrderTotal on POs, was not calculated on deletion.
  || 03/04/09 RTC 10.0.2.0 (48281) Changed validation for applied invoice to check specific POD line
  ||                               having a vendor invoice applied not any POD on the same order
  || 07/06/11 GHL 8.546    (111482) Added deletion of tax records tPurchaseOrderDetailTax 
  || 06/11/14 GHL 10.581   Added UserKey parameter for media print revision log
  */
  
DECLARE @CurrentStatus int
DECLARE @Revision int
DECLARE @PurchaseOrderKey int
declare @LineNumber int
declare @AdjustmentNumber int
declare @POKind smallint
declare @ProjectKey int
declare @CompanyKey int
declare @MediaWorksheetKey int
declare @MediaPremiumKey int
declare @Status int
declare @PremiumID varchar(50)

	SELECT @PurchaseOrderKey = PurchaseOrderKey 
	      ,@LineNumber = LineNumber
	      ,@AdjustmentNumber = isnull(AdjustmentNumber, 0) -- new field, protect from nulls
		  ,@ProjectKey = ProjectKey
		  ,@MediaPremiumKey = MediaPremiumKey
		  ,@PremiumID = substring(ShortDescription, 1, 50) -- manual Premium
	FROM tPurchaseOrderDetail (NOLOCK)
	WHERE PurchaseOrderDetailKey = @PurchaseOrderDetailKey
	
	select @POKind = POKind
	      ,@CompanyKey = CompanyKey
	      ,@MediaWorksheetKey = MediaWorksheetKey
		  ,@Status = Status
		  ,@Revision = isnull(Revision, 0)
	  from tPurchaseOrder (nolock)
	 where PurchaseOrderKey = @PurchaseOrderKey	
	

	IF EXISTS (SELECT 1
			FROM   tVoucherDetail vd (NOLOCK)
			WHERE  PurchaseOrderDetailKey = @PurchaseOrderDetailKey)
		RETURN -1

	
	IF EXISTS (SELECT 1
	           FROM		tPurchaseOrder po (NOLOCK)
	           WHERE  po.PurchaseOrderKey = @PurchaseOrderKey
	           AND    (po.Closed = 1))
		RETURN -2

	-- we need to log the deletion of media premiums
	if @MediaWorksheetKey > 0 and @Status = 4 and @LineNumber > 1 and @POKind = 1
	begin
		if @MediaPremiumKey > 0
				select @PremiumID = PremiumID from tMediaPremium (nolock) where MediaPremiumKey = @MediaPremiumKey  

		declare @Action varchar(200) 
		       ,@Comments varchar(200)

		select @Action = 'Premium'
		      ,@Comments = 'Deleted ' + @PremiumID 

		INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action,UserKey,FieldName,FieldType,Comments,Revision,MediaPremiumKey,POKind
			,OldString,OldDecimal,OldInt,OldMoney,OldDate,NewString,NewDecimal,NewInt,NewMoney,NewDate
			,LineNumber, PremiumID)
		VALUES (@CompanyKey,'tPurchaseOrder',@PurchaseOrderKey,@Action,@UserKey,null,1 ,@Comments,@Revision,@MediaPremiumKey,@POKind
			,null,null,null,null,null,null,null,null,null,null
			,@LineNumber, @PremiumID)

	end

	if @POKind = 2
		UPDATE tEstimateTaskExpense
		SET    PurchaseOrderDetailKey = NULL
		WHERE  PurchaseOrderDetailKey in (select PurchaseOrderDetailKey
		                                    from tPurchaseOrderDetail (nolock)
		                                   where PurchaseOrderKey = @PurchaseOrderKey 
		                                     and LineNumber = @LineNumber
		                                     and isnull(AdjustmentNumber, 0) = @AdjustmentNumber)
	else
		UPDATE tEstimateTaskExpense
		SET    PurchaseOrderDetailKey = NULL
		WHERE  PurchaseOrderDetailKey = @PurchaseOrderDetailKey 
	
    if @POKind = 2
    BEGIN
		DELETE
		FROM tPurchaseOrderDetail
		WHERE
			PurchaseOrderKey = @PurchaseOrderKey 
		AND 
			LineNumber = @LineNumber
		AND 
			isnull(AdjustmentNumber, 0) = @AdjustmentNumber

		-- We can only move everything up if there are none with same line number
		IF NOT EXISTS (SELECT 1 FROM	tPurchaseOrderDetail (NOLOCK)
								WHERE  	PurchaseOrderKey = @PurchaseOrderKey 
								AND		LineNumber = @LineNumber)

			UPDATE tPurchaseOrderDetail
			SET    LineNumber = LineNumber - 1
			WHERE
				PurchaseOrderKey = @PurchaseOrderKey 
			AND 
				LineNumber > @LineNumber
	END
	else
	BEGIN
		DELETE
		FROM tPurchaseOrderDetailTax
		WHERE
			PurchaseOrderDetailKey = @PurchaseOrderDetailKey
	
		DELETE
		FROM tPurchaseOrderDetail
		WHERE
			PurchaseOrderDetailKey = @PurchaseOrderDetailKey
	
		if @POKind = 1  -- if it is an insertion order
			begin
				-- We can only move everything up if there are none with same line number
				IF NOT EXISTS (SELECT 1 FROM	tPurchaseOrderDetail (NOLOCK)
								WHERE  	PurchaseOrderKey = @PurchaseOrderKey 
								AND		LineNumber = @LineNumber)

					UPDATE tPurchaseOrderDetail
					SET    LineNumber = LineNumber - 1
					WHERE
						PurchaseOrderKey = @PurchaseOrderKey 
					AND 
						LineNumber > @LineNumber			
			end
		else
			UPDATE tPurchaseOrderDetail
			SET    LineNumber = LineNumber - 1
			WHERE
				PurchaseOrderKey = @PurchaseOrderKey 
			AND 
				LineNumber > @LineNumber
		
	END
	
	exec sptPurchaseOrderRollupAmounts @PurchaseOrderKey

	UPDATE tPurchaseOrder
	SET   DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)
	WHERE  PurchaseOrderKey = @PurchaseOrderKey
		
	exec sptPurchaseOrderDetailUpdateApprover @PurchaseOrderKey
	
	EXEC sptProjectRollupUpdate @ProjectKey, 5, 1, 1, 1, 1 

	RETURN 1
GO
