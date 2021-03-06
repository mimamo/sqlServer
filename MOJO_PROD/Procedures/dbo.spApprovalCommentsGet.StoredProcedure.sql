USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spApprovalCommentsGet]    Script Date: 12/10/2015 12:30:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spApprovalCommentsGet]

	(
		@Entity varchar(100),
		@EntityKey int
	)

AS --Encrypt


If @Entity = 'Invoice'
	Select ApprovalComments as Comments from tInvoice (nolock) Where InvoiceKey = @EntityKey
	
If @Entity = 'Billing'
	Select WorkSheetComment as Comments from tBilling (nolock) Where BillingKey = @EntityKey
	
If @Entity = 'Voucher'
	Select ApprovalComments as Comments from tVoucher (nolock) Where VoucherKey = @EntityKey
	
If @Entity = 'PO' or @Entity = 'IO' or @Entity = 'BC'
	Select ApprovalComments as Comments from tPurchaseOrder (nolock) Where PurchaseOrderKey = @EntityKey
	
If @Entity = 'Time'
	Select ApprovalComments as Comments from tTimeSheet (nolock) Where TimeSheetKey = @EntityKey
	
If @Entity = 'ExpReport'
	Select ApprovalComments as Comments from tExpenseEnvelope (nolock) Where ExpenseEnvelopeKey = @EntityKey
		
If @Entity = 'EstimateInternal'
	Select InternalComments as Comments from tEstimate (nolock) Where EstimateKey = @EntityKey	

If @Entity = 'EstimateExternal'
	Select ExternalComments as Comments from tEstimate (nolock) Where EstimateKey = @EntityKey
GO
