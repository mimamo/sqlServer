USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertMC]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertMC]
AS
	SET NOCOUNT ON 
	
	-- GHL: 8/29/13 Added tTime.HCostRate and tMiscCost.PTotalCost

	update tPreference set MultiCurrency = 0

	update tPurchaseOrder
	set    ExchangeRate = 1 -- Vendor Exchange Rate
	      ,PExchangeRate = 1 -- Project Exchange Rate
		 

	update tPurchaseOrderDetail
	set    PExchangeRate = 1 -- Project Exchange Rate
		  ,PTotalCost = TotalCost
		  ,PAppliedCost = AppliedCost

	update tVoucher
	set    ExchangeRate = 1 -- Vendor Exchange Rate
	      ,PExchangeRate = 1 -- Project Exchange Rate

	update tVoucherDetail
	set    PExchangeRate = 1 -- Project Exchange Rate
		  ,PTotalCost = TotalCost

	update tExpenseEnvelope
	set    ExchangeRate = 1 -- Vendor Exchange Rate

	update tExpenseReceipt
	set    PExchangeRate = 1 -- Project Exchange Rate
		  ,PTotalCost = ActualCost

	update tMiscCost
	Set    ExchangeRate = 1

	update tTime
	Set    ExchangeRate = 1
	      ,HCostRate = CostRate
		  	  
	update tInvoice
	Set    ExchangeRate = 1
		  
	update tTransaction
	Set    ExchangeRate = 1

	update tPayment
	Set    ExchangeRate = 1

	update tCheck
	Set    ExchangeRate = 1

	RETURN 1
GO
