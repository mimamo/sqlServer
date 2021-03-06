USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaWorksheetDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaWorksheetDelete]
	@MediaWorksheetKey int
AS

/*
|| When      Who Rel      What
|| 6/27/13   CRG 10.5.6.9 Created
|| 5/08/14   GHL 10.5.7.9 According to Susan Moore, cancelled buylines can be deleted even if approved
|| 7/22/14   GHL 10.5.8.2 Cancelled buylines can only be deleted if printed or emailed
|| 11/18/14  GHL 10.5.8.6 Revisited the delete validation sequence from SM's last requirement
*/

declare @kErrBilled int				select @kErrBilled = -1
declare @kErrApplied int			select @kErrApplied = -2
declare @kErrNotCancelled int		select @kErrNotCancelled = -3
declare @kErrCancelledNotSent int	select @kErrCancelledNotSent = -4
declare @kErrWS int					select @kErrWS = -5
declare @kErrPODeleteOffset int		select @kErrPODeleteOffset = -100

	if exists (select 1 
		from tPurchaseOrder po (nolock)
		where po.MediaWorksheetKey = @MediaWorksheetKey
		and   po.MediaOrderKey > 0 -- this indicates that it was printed at some time 
		)
		begin
			if exists (select 1
				from tPurchaseOrder po (nolock)
				where po.MediaWorksheetKey = @MediaWorksheetKey
				and   po.MediaOrderKey > 0 -- this indicates that it was printed at some time 
				and   isnull(po.Cancelled, 0) = 0 -- not cancelled
				) 
				return @kErrNotCancelled
			else
				if exists (select 1
				from tPurchaseOrder po (nolock)
				where po.MediaWorksheetKey = @MediaWorksheetKey
				and   po.MediaOrderKey > 0 -- this indicates that it was printed at some time 
				and   isnull(po.Cancelled, 0) = 1 -- cancelled
				and   isnull(Printed, 0) = 0  -- not printed/sent
				and   isnull(Emailed, 0) = 0  -- not emailed/sent
				) 
				return @kErrCancelledNotSent
		end

	if exists (select 1
		from  tPurchaseOrder po (nolock)
			inner join tPurchaseOrderDetail pod (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey 
		where po.MediaWorksheetKey = @MediaWorksheetKey
		and   pod.InvoiceLineKey > 0
		)
		return @kErrBilled

	if exists (select 1
		from  tPurchaseOrder po (nolock)
			inner join tPurchaseOrderDetail pod (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey 
			inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey 
		where po.MediaWorksheetKey = @MediaWorksheetKey
		)
		return @kErrApplied


	SELECT	PurchaseOrderKey
	INTO	#POKeys
	FROM	tPurchaseOrder (nolock)
	WHERE	MediaWorksheetKey = @MediaWorksheetKey

	DECLARE	@PurchaseOrderKey int,
			@RetVal int
	
	SELECT	@PurchaseOrderKey = -1

	BEGIN TRAN

	WHILE(1=1)
	BEGIN
		SELECT	@PurchaseOrderKey = MIN(PurchaseOrderKey)
		FROM	#POKeys
		WHERE	PurchaseOrderKey > @PurchaseOrderKey

		IF @PurchaseOrderKey IS NULL
			BREAK

		EXEC @RetVal = sptPurchaseOrderDelete @PurchaseOrderKey

		IF @RetVal < 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrPODeleteOffset + @RetVal
		END
	END

	DELETE	tMediaWorksheet
	WHERE	MediaWorksheetKey = @MediaWorksheetKey

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN @kErrWS
	END

	COMMIT TRAN
	RETURN 1
GO
