USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spApprovalCommentsUpdate]    Script Date: 12/10/2015 12:30:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spApprovalCommentsUpdate]

	(
		@Entity varchar(100),
		@EntityKey int,
		@Comments varchar(300)
	)

AS --Encrypt


If @Entity = 'Invoice'
	Update tInvoice Set ApprovalComments = @Comments Where InvoiceKey = @EntityKey
	
If @Entity = 'Billing'
	Update tBilling Set WorkSheetComment = @Comments Where BillingKey = @EntityKey
	
If @Entity = 'Voucher'
	Update tVoucher Set ApprovalComments = @Comments Where VoucherKey = @EntityKey
	
If @Entity = 'PO' or @Entity = 'IO' or @Entity = 'BC'
	Update tPurchaseOrder Set ApprovalComments = @Comments Where PurchaseOrderKey = @EntityKey
	
If @Entity = 'Time'
	Update tTimeSheet Set ApprovalComments = @Comments Where TimeSheetKey = @EntityKey
	
If @Entity = 'ExpReport'
	Update tExpenseEnvelope Set ApprovalComments = @Comments Where ExpenseEnvelopeKey = @EntityKey
GO
