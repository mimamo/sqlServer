USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemDelete]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptItemDelete]
	@ItemKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 07/31/07 GHL 8.5     Added check of expense receipt
|| 5/5/11   CRG 10.5.4.4 (110628) Now deleting from tLayoutBilling when the item is deleted
*/

if exists(Select 1 from tEstimateTaskExpense (nolock) Where ItemKey = @ItemKey)
	return -1
if exists(Select 1 from tMiscCost (nolock) Where ItemKey = @ItemKey)
	return -2
if exists(Select 1 from tPurchaseOrderDetail (nolock) Where ItemKey = @ItemKey)
	return -3
if exists(Select 1 from tVoucherDetail (nolock) Where ItemKey = @ItemKey)
	return -4
if exists(Select 1 from tQuoteDetail (nolock) Where ItemKey = @ItemKey)
	return -5
if exists(Select 1 from tExpenseReceipt (nolock) Where ItemKey = @ItemKey)
	return -6
	
	DELETE
	FROM tItemRateSheetDetail
	WHERE
		ItemKey = @ItemKey 

	DELETE	tLayoutBilling
	WHERE	Entity = 'tItem'
	AND		EntityKey = @ItemKey
		
	DELETE
	FROM tItem
	WHERE
		ItemKey = @ItemKey 

	RETURN 1
GO
