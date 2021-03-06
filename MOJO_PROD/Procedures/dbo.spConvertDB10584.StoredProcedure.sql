USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10584]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10584]
AS
	SET NOCOUNT ON

	-- closed POD lines should be marked as billed (issue 228260)
	update tPurchaseOrderDetail
	set    InvoiceLineKey = 0
		  ,AmountBilled = BillableCost
		  ,DateBilled = isnull(DateBilled, CONVERT(SMALLDATETIME, (CONVERT(VARCHAR(10), GETDATE(), 101)), 101))
	where Closed = 1
	and   InvoiceLineKey is null

	-- CollapseSchedule was moved to tSession table (223597)
	ALTER TABLE dbo.tPreference DROP COLUMN CollapseSchedule


	-- No client in GL for labor lines of vendor invoices (230068)
	update tTransaction
	set    tTransaction.ClientKey = null
	from   tVoucherDetail vd (nolock)
	where  tTransaction.Entity = 'VOUCHER'
	and    tTransaction.Section = 2
	and    tTransaction.DetailLineKey = vd.VoucherDetailKey
	and    vd.ShortDescription =  '**Labor Line**'
    
	return
GO
