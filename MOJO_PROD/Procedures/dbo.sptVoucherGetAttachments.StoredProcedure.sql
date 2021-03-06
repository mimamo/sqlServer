USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherGetAttachments]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherGetAttachments]
	(
	@VoucherKey int
	)
AS --Encrypt

/*
|| When     Who Rel      What
|| 05/01/12 GHL 10.555   Creation to get attachments associated to voucher details (new requirement)
|| 05/02/12 GHL 10.555   Added LineType to get attachments for ERs, Lines, POs, etc...
|| 08/28/12 GHL 10.559   Added attachment for the header
*/

	SET NOCOUNT ON 

	SELECT	a.*
	       ,'HEADER' as LineType
	FROM	tAttachment a (nolock)
	INNER JOIN tVoucher v (nolock) ON a.EntityKey = v.VoucherKey 
	WHERE v.VoucherKey =  @VoucherKey
	AND   a.AssociatedEntity = 'tVoucher' 
	
	UNION 

	SELECT	a.*
	       ,
		   case when pod.PurchaseOrderDetailKey is null
				then
				case when vd.SourceDate is not null then 'ER'
				else 
					case when vd.ShortDescription = '**Labor Line**'
						then 'LABOR'
						else 'LINE'
					end
				end  
				else
				case when po.POKind = 0 then 'PO'
				when po.POKind = 1 then 'IO'
				else 'BO'
				end
		end as LineType
	FROM	tAttachment a (nolock)
	INNER JOIN tVoucherDetail vd (nolock) ON a.EntityKey = vd.VoucherDetailKey 
	LEFT OUTER JOIN tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
	LEFT OUTER JOIN tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
	WHERE vd.VoucherKey =  @VoucherKey
	AND   a.AssociatedEntity = 'tVoucherDetail' 
	
	RETURN 1
GO
