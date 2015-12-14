USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10579]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10579]

AS
	SET NOCOUNT ON

	-- GrossAmount was set regardless of Billable Flag, fix it now
	update tVoucherDetail set GrossAmount = 0 where  Billable = 0 and BillableCost = 0 and GrossAmount <> 0 
	and PurchaseOrderDetailKey is null

	update tVoucherDetail set GrossAmount = isnull(GrossAmount, 0)

	--Default the URL for Amazon WebDAV servers because we're not using a constant anymore
	UPDATE	tWebDavServer
	SET		URL = 's3.amazonaws.com'
	WHERE	Type = 4
	
	--Default tItem UseDescription to 1 this is for expense reports
	Update tItem
	set UseDescription = 1


	update tPurchaseOrder
	set    tPurchaseOrder.ShowAdjustmentsAsSingleLine =
			case tPurchaseOrder.POKind when 1 then pref.IOShowAdjustmentsAsSingleLine
									   when 2 then pref.BCShowAdjustmentsAsSingleLine
									   else 1
			end 
	from   tPreference pref (nolock)
	where  tPurchaseOrder.CompanyKey = pref.CompanyKey

	RETURN
GO
