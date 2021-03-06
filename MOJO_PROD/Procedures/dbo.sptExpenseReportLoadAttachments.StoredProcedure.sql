USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptExpenseReportLoadAttachments]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptExpenseReportLoadAttachments]
	@ExpenseEnvelopeKey int
AS

/*
|| When      Who Rel      What
|| 09/30/11  RLB 10.5.4.8 (118535) Created
|| 12/09/11  RLB 10.5.5.1 (128401) bug fix
|| 05/03/12  GHL 10.5.5.5  Added VoucherDetailKey so that we can copy attachments from ER to VI
*/

	SELECT	a.*
	       ,er.VoucherDetailKey -- this will help after converting ER to VI when copying attachments
	FROM	tAttachment a (nolock)
	INNER JOIN tExpenseReceipt er (nolock) ON a.EntityKey = er.ExpenseReceiptKey 
	WHERE  a.AssociatedEntity = 'ExpenseReceipt' 
	AND er.ExpenseEnvelopeKey =  @ExpenseEnvelopeKey
GO
