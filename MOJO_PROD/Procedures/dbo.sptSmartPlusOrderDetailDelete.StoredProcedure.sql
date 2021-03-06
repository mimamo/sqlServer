USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSmartPlusOrderDetailDelete]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSmartPlusOrderDetailDelete]

	@PurchaseOrderDetailKey int,
	@UserKey int,
	@CMP tinyint = 0	-- syncing from CMP?  WMJ = 0 / CMP = 1

AS --Encrypt

/*
|| When     Who Rel      What
|| 11/11/09 MAS 10.5.1.3 (47035)
*/


DECLARE @PurchaseOrderKey int
declare @LineNumber int
Declare @ExpenseAccountKey int, @ProjectKey int, @TaskKey int, @RetVal int

	SELECT @PurchaseOrderKey = pod.PurchaseOrderKey 
		  ,@ProjectKey = pod.ProjectKey
		  ,@TaskKey = pod.TaskKey
	      ,@LineNumber = pod.LineNumber
	FROM tPurchaseOrderDetail pod (NOLOCK)
	JOIN tPurchaseOrder po (NOLOCK) on po.PurchaseOrderKey = pod.PurchaseOrderKey 
	WHERE pod.PurchaseOrderDetailKey = @PurchaseOrderDetailKey
	
	-- If using Projects/Tasks - Check to see if the associated Task is completed
	if ISNULL(@CMP,0) = 0 and ISNULL(@TaskKey,0) > 0
		BEGIN
			exec @RetVal = spTaskValidatePercCompDelete 'tPurchaseOrderDetail', @PurchaseOrderDetailKey, NULL, @UserKey
			If @RetVal < 0
				Return -9
		END
	
	UPDATE tEstimateTaskExpense
	SET    PurchaseOrderDetailKey = NULL
	WHERE  PurchaseOrderDetailKey = @PurchaseOrderDetailKey 
	DELETE
	FROM tPurchaseOrderDetail
	WHERE PurchaseOrderDetailKey = @PurchaseOrderDetailKey
		
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
	
	exec sptPurchaseOrderDetailUpdateApprover @PurchaseOrderKey
	
	RETURN 1
GO
