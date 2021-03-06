USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostWIPConvertExpenseAcct]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostWIPConvertExpenseAcct]
	(
	@CompanyKey INT
	)
AS --Encrypt

-- GHL 11/13/07 for 85 conversion

 	IF NOT EXISTS
		(SELECT NULL
		FROM	sysobjects
		WHERE	name = 'tTransactionBackup'
		AND		type = 'U')
	BEGIN
		SELECT	* INTO tTransactionBackup
		FROM	tTransaction (nolock)
	END
	
	SET NOCOUNT ON

	-- My Constants
DECLARE @kLaborIn				VARCHAR(50)	SELECT	@kLaborIn			= 'WIP LABOR IN'
DECLARE @kLaborBill				VARCHAR(50)	SELECT	@kLaborBill			= 'WIP LABOR BILL'
DECLARE @kLaborMB				VARCHAR(50)	SELECT	@kLaborMB			= 'WIP LABOR MB'
DECLARE @kLaborWO				VARCHAR(50)	SELECT	@kLaborWO			= 'WIP LABOR WO'
DECLARE @kLaborInWO				VARCHAR(50)	SELECT	@kLaborInWO			= 'WIP LABOR IN/WO' -- difference for grouping
DECLARE @kExpReceiptIn			VARCHAR(50)	SELECT	@kExpReceiptIn		= 'WIP EXPENSE REPORT IN'
DECLARE @kExpReceiptBill		VARCHAR(50)	SELECT	@kExpReceiptBill	= 'WIP EXPENSE REPORT BILL'
DECLARE @kExpReceiptMB			VARCHAR(50)	SELECT	@kExpReceiptMB		= 'WIP EXPENSE REPORT MB'
DECLARE @kExpReceiptWO			VARCHAR(50)	SELECT	@kExpReceiptWO		= 'WIP EXPENSE REPORT WO'
DECLARE @kExpReceiptInWO		VARCHAR(50)	SELECT	@kExpReceiptInWO	= 'WIP EXPENSE REPORT IN/WO' 
DECLARE @kMiscCostIn			VARCHAR(50)	SELECT	@kMiscCostIn		= 'WIP MISC COST IN'
DECLARE @kMiscCostBill			VARCHAR(50)	SELECT	@kMiscCostBill		= 'WIP MISC COST BILL'
DECLARE @kMiscCostMB			VARCHAR(50)	SELECT	@kMiscCostMB		= 'WIP MISC COST MB'
DECLARE @kMiscCostWO			VARCHAR(50)	SELECT	@kMiscCostWO		= 'WIP MISC COST WO'
DECLARE @kMiscCostInWO			VARCHAR(50)	SELECT	@kMiscCostInWO		= 'WIP MISC COST IN/WO'
DECLARE @kVendorInvoiceIn		VARCHAR(50)	SELECT	@kVendorInvoiceIn	= 'WIP VENDOR INVOICE IN'
DECLARE @kVendorInvoiceBill		VARCHAR(50)	SELECT	@kVendorInvoiceBill	= 'WIP VENDOR INVOICE BILL'
DECLARE @kVendorInvoiceMB		VARCHAR(50)	SELECT	@kVendorInvoiceMB	= 'WIP VENDOR INVOICE MB'
DECLARE @kVendorInvoiceWO		VARCHAR(50)	SELECT	@kVendorInvoiceWO	= 'WIP VENDOR INVOICE WO'
DECLARE @kVendorInvoiceInWO		VARCHAR(50)	SELECT	@kVendorInvoiceInWO	= 'WIP VENDOR INVOICE IN/WO'
DECLARE @kMediaInvoiceIn		VARCHAR(50)	SELECT	@kMediaInvoiceIn	= 'WIP MEDIA INVOICE IN'
DECLARE @kMediaInvoiceBill		VARCHAR(50)	SELECT	@kMediaInvoiceBill	= 'WIP MEDIA INVOICE BILL'
DECLARE @kMediaInvoiceMB		VARCHAR(50)	SELECT	@kMediaInvoiceMB	= 'WIP MEDIA INVOICE MB'
DECLARE @kMediaInvoiceWO		VARCHAR(50)	SELECT	@kMediaInvoiceWO	= 'WIP MEDIA INVOICE WO'
DECLARE @kMediaInvoiceInWO		VARCHAR(50)	SELECT	@kMediaInvoiceInWO	= 'WIP MEDIA INVOICE IN/WO'

-- Can only change the expense accounts not the voucher accts because they are also on tVoucherDetail

--'WIP Production Invoice WO'
--'WIP Production Invoice BILL1'

Declare @WIPExpenseAssetAccountKey int
Declare @WIPExpenseIncomeAccountKey int
Declare @WIPExpenseWOAccountKey int

Declare @WIPVoucherAssetAccountKey int
Declare @WIPVoucherWOAccountKey int

-- Get the Preference Settings
Select	
	-- Misc Costs and ERs accounts
	@WIPExpenseAssetAccountKey = ISNULL(WIPExpenseAssetAccountKey, 0),
	@WIPExpenseIncomeAccountKey = ISNULL(WIPExpenseIncomeAccountKey, 0),
	@WIPExpenseWOAccountKey = ISNULL(WIPExpenseWOAccountKey, 0),
	
	-- Production Voucher accounts
	@WIPVoucherAssetAccountKey = ISNULL(WIPVoucherAssetAccountKey, 0),
	@WIPVoucherWOAccountKey = ISNULL(WIPVoucherWOAccountKey, 0)
		
from tPreference  (nolock)
Where CompanyKey = @CompanyKey

-- Debit asset acct, credit income acct
UPDATE tTransaction
SET    GLAccountKey = @WIPExpenseAssetAccountKey
WHERE  CompanyKey = @CompanyKey
AND    Entity = 'WIP'
AND    UPPER(Reference) IN ('WIP MISC COST IN', 'WIP EXPENSE REPORT IN') 
AND    PostSide = 'D'

UPDATE tTransaction
SET    GLAccountKey = @WIPExpenseIncomeAccountKey
WHERE  CompanyKey = @CompanyKey
AND    Entity = 'WIP'
AND    UPPER(Reference) IN ('WIP MISC COST IN', 'WIP EXPENSE REPORT IN') 
AND    PostSide = 'C'

-- Exp Receipts + Misc Cost To Bill Debit income + Credit asset
UPDATE tTransaction
SET    GLAccountKey = @WIPExpenseIncomeAccountKey
WHERE  CompanyKey = @CompanyKey
AND    Entity = 'WIP'
AND    UPPER(Reference) IN ('WIP MISC COST BILL', 'WIP EXPENSE REPORT BILL', 'WIP MISC COST MB', 'WIP EXPENSE REPORT MB') 
AND    PostSide = 'D'

UPDATE tTransaction
SET    GLAccountKey = @WIPExpenseAssetAccountKey
WHERE  CompanyKey = @CompanyKey
AND    Entity = 'WIP'
AND    UPPER(Reference) IN ('WIP MISC COST BILL', 'WIP EXPENSE REPORT BILL', 'WIP MISC COST MB', 'WIP EXPENSE REPORT MB') 
AND    PostSide = 'C'

-- Exp Receipts + Misc Cost WO =  Debit WO + Credit Asset
UPDATE tTransaction
SET    GLAccountKey = @WIPExpenseWOAccountKey
WHERE  CompanyKey = @CompanyKey
AND    Entity = 'WIP'
AND    UPPER(Reference) IN ('WIP MISC COST WO', 'WIP EXPENSE REPORT WO') 
AND    PostSide = 'D'

UPDATE tTransaction
SET    GLAccountKey = @WIPExpenseAssetAccountKey
WHERE  CompanyKey = @CompanyKey
AND    Entity = 'WIP'
AND    UPPER(Reference) IN ('WIP MISC COST WO', 'WIP EXPENSE REPORT WO') 
AND    PostSide = 'C'

-- Misc Cost or ER - In + To WO: Debit @WIPExpenseWOAccountKey + Credit @WIPExpenseIncomeAccountKey
UPDATE tTransaction
SET    GLAccountKey = @WIPExpenseWOAccountKey
WHERE  CompanyKey = @CompanyKey
AND    Entity = 'WIP'
AND    UPPER(Reference) IN ('WIP MISC COST IN/WO', 'WIP EXPENSE REPORT IN/WO') 
AND    PostSide = 'D'

UPDATE tTransaction
SET    GLAccountKey = @WIPExpenseIncomeAccountKey
WHERE  CompanyKey = @CompanyKey
AND    Entity = 'WIP'
AND    UPPER(Reference) IN ('WIP MISC COST IN/WO', 'WIP EXPENSE REPORT IN/WO') 
AND    PostSide = 'C'

	
	RETURN 1
GO
