USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10555]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10555]

AS

	-- Change GLCompanyKey 0 to NULL, for new listing restrict cause 
	update tInvoice
	set    GLCompanyKey = null
	where  GLCompanyKey = 0 
		
	update tCampaign
	set    tCampaign.GLCompanyKey = p.GLCompanyKey
	from   tProject p (nolock)
	where  tCampaign.CampaignKey = p.CampaignKey

	update tCampaign
	set    tCampaign.GLCompanyKey = cl.GLCompanyKey
	from   tCompany cl (nolock)
	where  tCampaign.ClientKey = cl.CompanyKey
	and    tCampaign.GLCompanyKey is null


Update tActivity Set ActivityEntity = 'Diary' Where ProjectKey > 0 and ISNULL(TaskKey, 0) = 0 and ActivityEntity = 'Activity'
Update tActivity Set ActivityEntity = 'ToDo' Where ProjectKey > 0 and TaskKey > 0 and ActivityEntity = 'Activity'
Update tActivity Set AssignedUserKey = NULL Where AssignedUserKey = 0

	-- Patch for tCashTransactionLine GLCompanyKey
	update tCashTransactionLine
	set    tCashTransactionLine.GLCompanyKey = i.GLCompanyKey
	from   tInvoice i (nolock)
	where  tCashTransactionLine.Entity = 'INVOICE'
	and    tCashTransactionLine.EntityKey = i.InvoiceKey
	and    isnull(tCashTransactionLine.GLCompanyKey, 0) <> isnull(i.GLCompanyKey, 0)


    update tCashTransactionLine
	set    tCashTransactionLine.GLCompanyKey = v.GLCompanyKey
	from   tVoucher v (nolock)
	where  tCashTransactionLine.Entity = 'VOUCHER'
	and    tCashTransactionLine.EntityKey = v.VoucherKey
	and    isnull(tCashTransactionLine.GLCompanyKey, 0) <> isnull(v.GLCompanyKey, 0)
GO
