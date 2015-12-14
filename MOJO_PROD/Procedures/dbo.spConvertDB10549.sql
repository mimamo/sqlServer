USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10549]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10549]

AS
	SET NOCOUNT ON

	-- this is used now when we apply posted vouchers to credit card charges
	update tCashTransactionLine set ReceiptAmount = Debit where Entity='VOUCHER' 


	Update tPreference Set ProductVersion = 'WMJ'


	Update tProject Set
		ClientBHours = 1,
		ClientBLabor = 1,
		ClientBExpenses = 1,
		ClientBCO = 1,
		ClientAHours = 1,
		ClientALabor = 1,
		ClientAPO = 1,
		ClientAExpenses = 1

Delete tTaskUser Where UserKey is null and ServiceKey is null
GO
