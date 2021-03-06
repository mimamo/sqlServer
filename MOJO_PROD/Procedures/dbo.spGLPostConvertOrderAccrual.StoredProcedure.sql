USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostConvertOrderAccrual]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostConvertOrderAccrual]

AS
	SET NOCOUNT ON
	
	TRUNCATE TABLE tTransactionOrderAccrual 
	
	
CREATE TABLE [#temp](
	[PurchaseOrderDetailKey] [int] NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[VoucherDetailKey] [int] NULL,
	[AccrualAmount] [money] NULL CONSTRAINT [DF_tTransactionOrderAccrual_AccrualAmount]  DEFAULT ((0)),
	[UnaccrualAmount] [money] NULL CONSTRAINT [DF_tTransactionOrderAccrual_UnaccrualAmount]  DEFAULT ((0)),
	[TransactionKey] [int] NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[PostingDate] [smalldatetime] NULL,
	
	[ClientKey] [int] NOT NULL,
	[ClassKey] [int] NOT NULL,
	
	GPFlag int null
)

CREATE NONCLUSTERED INDEX [IX_temp_3] ON [#temp] 
(
	[Entity] ASC,
	[EntityKey] ASC
)

	INSERT #temp (PurchaseOrderDetailKey, CompanyKey, AccrualAmount, Entity, EntityKey, PostingDate, ClientKey, ClassKey, GPFlag)
	SELECT pod.PurchaseOrderDetailKey, po.CompanyKey, ROUND(ISNULL(pod.AccruedCost, 0), 2) 
		, 'INVOICE', il.InvoiceKey, i.PostingDate, ISNULL(i.ClientKey, 0), ISNULL(pod.ClassKey, 0),  0
	FROM   tPurchaseOrderDetail pod (nolock)
	INNER  JOIN tInvoiceLine il (nolock) ON pod.InvoiceLineKey = il.InvoiceLineKey
	INNER JOIN tInvoice i (nolock) ON il.InvoiceKey = i.InvoiceKey
	INNER  JOIN tPurchaseOrder po (nolock) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
	WHERE  po.BillAt in (0,1) -- we may miss a lot of them since in the past we would take them all
	AND    i.Posted = 1
	-- AND    isnull(v.OpeningTransaction, 0) = 0 Need to do everything
	
	INSERT #temp (PurchaseOrderDetailKey, VoucherDetailKey, CompanyKey, UnaccrualAmount, Entity, EntityKey, PostingDate, ClientKey, ClassKey,GPFlag)
	SELECT vd.PurchaseOrderDetailKey, vd.VoucherDetailKey, v.CompanyKey, ROUND(ISNULL(vd.PrebillAmount, 0), 2)
	, 'VOUCHER', vd.VoucherKey, v.PostingDate, ISNULL(i.ClientKey, 0), ISNULL(pod.ClassKey, 0), 0
	FROM   tVoucherDetail vd (nolock)
	INNER JOIN tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
	INNER  JOIN tInvoiceLine il (nolock) ON pod.InvoiceLineKey = il.InvoiceLineKey
	INNER JOIN tInvoice i (nolock) ON il.InvoiceKey = i.InvoiceKey
	INNER  JOIN tVoucher v (nolock) ON vd.VoucherKey = v.VoucherKey
	INNER  JOIN tPurchaseOrder po (nolock) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
	WHERE  po.BillAt in (0,1) -- we may miss a lot of them since in the past we would take them all
	AND    v.Posted = 1
	-- AND    isnull(v.OpeningTransaction, 0) = 0 Need to do everything
	
	
	UPDATE #temp
	SET    #temp.TransactionKey = t.TransactionKey
	FROM   tTransaction t (NOLOCK)
		INNER JOIN tPreference pref (NOLOCK) ON t.CompanyKey = pref.CompanyKey
	WHERE  t.Entity = 'INVOICE' -- because the entity in temp and permannet table have diff collation
	AND    #temp.EntityKey = t.EntityKey
	AND    #temp.Entity = 'INVOICE'
	AND    t.GLAccountKey = pref.POPrebillAccrualAccountKey
	AND    ISNULL(t.ClientKey, 0) = ISNULL(#temp.ClientKey, 0)
	AND    ISNULL(t.ClassKey, 0) = ISNULL(#temp.ClassKey, 0)
	
	UPDATE #temp
	SET    #temp.TransactionKey = t.TransactionKey
	FROM   tTransaction t (NOLOCK)
		INNER JOIN tPreference pref (NOLOCK) ON t.CompanyKey = pref.CompanyKey
	WHERE  t.Entity = 'VOUCHER'
	AND    #temp.EntityKey = t.EntityKey
	AND    #temp.Entity = 'VOUCHER'
	AND    t.GLAccountKey = pref.POPrebillAccrualAccountKey
	AND    ISNULL(t.ClientKey, 0) = ISNULL(#temp.ClientKey, 0)
	AND    ISNULL(t.ClassKey, 0) = ISNULL(#temp.ClassKey, 0)
		
	
	INSERT 	tTransactionOrderAccrual (PurchaseOrderDetailKey, CompanyKey,VoucherDetailKey, AccrualAmount, UnaccrualAmount,
	TransactionKey, Entity, EntityKey, PostingDate)
	SELECT PurchaseOrderDetailKey, CompanyKey, VoucherDetailKey, ISNULL(AccrualAmount, 0), ISNULL(UnaccrualAmount, 0),
	TransactionKey, Entity, EntityKey, PostingDate
	FROM #temp
	
	
	RETURN
GO
