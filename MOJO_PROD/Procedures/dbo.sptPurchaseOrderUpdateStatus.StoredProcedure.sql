USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderUpdateStatus]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptPurchaseOrderUpdateStatus]

	(
		@PurchaseOrderKey int,
		@Status smallint,
		@ApprovedByKey int,
		@ApprovalComments varchar(300) = NULL
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 02/20/07 GHL 8.4   Added project rollup section.
  || 04/17/07 BSH 8.4.5 DateUpdated needed to be updated.  
  || 05/21/14 GHL 10.580 Changed the way revision # are incremented for the new Media screen
  ||                     It is now increased after fields are changed after printing, not on approval             
  */

Declare @CurStatus smallint, @Closed smallint, @CurRev int, @CompanyKey int, @POKind int, @MediaWorksheetKey int

Select @CurStatus = Status
		,@Closed = Closed
		,@CurRev = ISNULL(Revision, 0)
		,@CompanyKey = CompanyKey
		,@POKind = POKind 
		,@MediaWorksheetKey = MediaWorksheetKey
from tPurchaseOrder (NOLOCK) Where PurchaseOrderKey = @PurchaseOrderKey

Declare @AllowChangesAfterClientInvoice int
Select @AllowChangesAfterClientInvoice = 
		CASE WHEN @POKind = 0 THEN 0
			 WHEN @POKind = 1 THEN ISNULL(IOAllowChangesAfterClientInvoice, 0)
			 WHEN @POKind = 2 THEN ISNULL(BCAllowChangesAfterClientInvoice, 0)
		END
From tPreference (NOLOCK)
Where CompanyKey = @CompanyKey
	
if @CurStatus = 4 and @Status < 4
BEGIN
	IF @AllowChangesAfterClientInvoice = 0
	BEGIN
		If exists(Select 1 from tPurchaseOrderDetail (nolock) 
			Where PurchaseOrderKey = @PurchaseOrderKey 
				and InvoiceLineKey > 0)
			return -1
			
		if exists(Select 1 from tVoucherDetail vd (nolock) 
			inner join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
			Where pod.PurchaseOrderKey = @PurchaseOrderKey)
			return -2
	END
		
	UPDATE 
		tPurchaseOrder
	SET
		Status = @Status,
		ApprovedDate = NULL,
        DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime),
		-- increase revision only if there is no media worksheet
		Revision = case when isnull(@MediaWorksheetKey, 0) = 0 then @CurRev + 1 else @CurRev end
	WHERE
		PurchaseOrderKey = @PurchaseOrderKey
END
else
	if @Status = 4
		UPDATE 
			tPurchaseOrder
		SET
			Status = @Status,
			ApprovedDate = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime),
			DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)
		WHERE
			PurchaseOrderKey = @PurchaseOrderKey
	else
		UPDATE 
			tPurchaseOrder
		SET
			Status = @Status,
			ApprovedDate = NULL,
			DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)
		WHERE
			PurchaseOrderKey = @PurchaseOrderKey

If @ApprovalComments is not null
	Update tPurchaseOrder Set ApprovalComments = @ApprovalComments Where PurchaseOrderKey = @PurchaseOrderKey
if @ApprovedByKey is not null
	Update tPurchaseOrder Set ApprovedByKey = @ApprovedByKey Where PurchaseOrderKey = @PurchaseOrderKey
	
 DECLARE @ProjectKey INT
 SELECT @ProjectKey = -1
 WHILE (1=1)
 BEGIN
	SELECT @ProjectKey = MIN(ProjectKey)
	FROM   tPurchaseOrderDetail (NOLOCK)
	WHERE  PurchaseOrderKey = @PurchaseOrderKey
	AND    ProjectKey > @ProjectKey
	
	IF @ProjectKey IS NULL
		BREAK
		
	-- Rollup project, TranType = Purchase Order or 5, approved rollup only
	EXEC sptProjectRollupUpdate @ProjectKey, 5, 0, 1, 0, 0
 END
GO
