USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptClassDelete]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptClassDelete]
	@ClassKey int

AS --Encrypt

if exists(select 1 from tTransaction (nolock) Where ClassKey = @ClassKey)
	return -1
if exists(select 1 from tInvoiceLine (nolock) Where ClassKey = @ClassKey)
	return -1
if exists(select 1 from tVoucherDetail (nolock) Where ClassKey = @ClassKey)
	return -1
if exists(select 1 from tPaymentDetail (nolock) Where ClassKey = @ClassKey)
	return -1
if exists(select 1 from tJournalEntryDetail (nolock) Where ClassKey = @ClassKey)
	return -1
if exists(select 1 from tPurchaseOrderDetail (nolock) Where ClassKey = @ClassKey)
	return -1
if exists(select 1 from tQuoteDetail (nolock) Where ClassKey = @ClassKey)
	return -1

	DELETE
	FROM tClass
	WHERE
		ClassKey = @ClassKey 

	RETURN 1
GO
