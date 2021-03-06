USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingPaymentGetList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingPaymentGetList]

	(
		@BillingKey int,
		@AppliedOnly tinyint
	)

AS --Encrypt

  /*
  || When     Who Rel    What
  || 07/06/07 GHL 8.5    Added @GLCompanyKey 
  || 10/03/10 GHL 10.537 (93631) When a project is specified, find a match on invoice header or invoice line  
  || 09/27/12 GHL 10.560 Added Billing Group Code column for HMI request
  ||                     Also filtering out the Advance bills for the billing group
  || 08/26/13 WDF 10.571 (182241) Added CampaignID
  || 12/01/14 GAR 10.586 (237723) If there is a project, use the Campaign from that if it exists, if not, use
  ||					 the campaign from the Invoice.
  */
  
Declare @ClientKey int
       ,@ProjectKey int
	   ,@GLCompanyKey int
	   ,@Entity varchar(50)
	   ,@EntityKey int
	   ,@GroupEntity varchar(50)
	   ,@GroupEntityKey int
	   ,@BillingGroupKey int

Select @ClientKey = ClientKey
	  ,@ProjectKey = ProjectKey
	  ,@GLCompanyKey = GLCompanyKey
	  ,@Entity = Entity
	  ,@EntityKey = EntityKey
	  ,@GroupEntity = GroupEntity
	  ,@GroupEntityKey = GroupEntityKey
from tBilling (nolock) Where BillingKey = @BillingKey

if @Entity = 'BillingGroup'
begin
	select @BillingGroupKey = @EntityKey
end
else if @GroupEntity = 'BillingGroup'
begin
	select @BillingGroupKey = @GroupEntityKey
end

--Invoice Key is the key of the invoice being applied to. AdvBillInvoiceKey is the advance bill

if @AppliedOnly = 0
BEGIN

	IF @ProjectKey IS NULL
		-- No Project, this is a Master WS
		-- Query based on client	
		Select
			1 as Applied,
			i.InvoiceKey, 
			i.InvoiceNumber, 
			i.InvoiceDate, 
			i.Posted,
			i.InvoiceTotalAmount, 
			(ISNULL(InvoiceTotalAmount, 0)
				 - ISNULL((Select Sum(Amount) from tInvoiceAdvanceBill (nolock) 
					Where tInvoiceAdvanceBill.AdvBillInvoiceKey = i.InvoiceKey), 0)
				 - ISNULL((Select Sum(Amount) from tBillingPayment (nolock) 
					inner join tBilling (nolock) on tBilling.BillingKey = tBillingPayment.BillingKey
					Where tBillingPayment.Entity = 'INVOICE' 
					and tBilling.Status < 5
					and tBillingPayment.EntityKey = i.InvoiceKey), 0))
			as UnAppliedAmount,
			bp.BillingPaymentKey as InvoiceAdvanceBillKey,
			p.ProjectNumber,
			ISNULL(cp.CampaignID,icp.CampaignID) as CampaignID,
			bp.Amount,
			bg.BillingGroupCode
		From 
			tInvoice i (nolock)
			inner join tBillingPayment bp (nolock) on i.InvoiceKey = bp.EntityKey and bp.Entity = 'INVOICE'
			left outer join tProject p (nolock) on i.ProjectKey = p.ProjectKey
			left outer join tCampaign cp (NOLOCK) on p.CampaignKey = cp.CampaignKey
			left outer join tCampaign icp (nolock) on i.CampaignKey = icp.CampaignKey
			left outer join tBillingGroup bg (nolock) on i.BillingGroupKey = bg.BillingGroupKey
		Where
			bp.BillingKey = @BillingKey

		UNION ALL

		Select
			0 as Applied,
			i.InvoiceKey, 
			i.InvoiceNumber, 
			i.InvoiceDate, 
			i.Posted,
			i.InvoiceTotalAmount, 
			i.InvoiceTotalAmount 
				- ISNULL((Select Sum(Amount) from tInvoiceAdvanceBill (nolock) 
					Where tInvoiceAdvanceBill.AdvBillInvoiceKey = i.InvoiceKey), 0)
				- ISNULL((Select Sum(Amount) from tBillingPayment (nolock) 
					inner join tBilling (nolock) on tBilling.BillingKey = tBillingPayment.BillingKey
					Where tBillingPayment.Entity = 'INVOICE' 
					and tBilling.Status < 5
					and tBillingPayment.EntityKey = i.InvoiceKey), 0)
				as UnAppliedAmount,	
			0,
			p.ProjectNumber,
			ISNULL(cp.CampaignID,icp.CampaignID) as CampaignID,
			0,
			bg.BillingGroupCode
		From
			tInvoice i (nolock)
			left outer join tProject p (nolock) on i.ProjectKey = p.ProjectKey
			left outer join tCampaign cp (NOLOCK) on p.CampaignKey = cp.CampaignKey
			left outer join tCampaign icp (nolock) on i.CampaignKey = icp.CampaignKey
			left outer join tBillingGroup bg (nolock) on i.BillingGroupKey = bg.BillingGroupKey
		Where
			i.AdvanceBill = 1 and
			i.InvoiceStatus = 4 and
			i.ClientKey = @ClientKey and
			i.InvoiceTotalAmount > 0 and
			i.InvoiceKey not in (Select EntityKey from tBillingPayment (nolock)
							Where tBillingPayment.BillingKey = @BillingKey) and
					(ISNULL(InvoiceTotalAmount, 0)
				 - ISNULL((Select Sum(Amount) from tInvoiceAdvanceBill (nolock) 
					Where tInvoiceAdvanceBill.AdvBillInvoiceKey = i.InvoiceKey), 0)
				 - ISNULL((Select Sum(Amount) from tBillingPayment (nolock) 
					inner join tBilling (nolock) on tBilling.BillingKey = tBillingPayment.BillingKey
					Where tBillingPayment.Entity = 'INVOICE' 
					and tBilling.Status < 5
					and tBillingPayment.EntityKey = i.InvoiceKey), 0)) > 0
			and ISNULL(i.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) 
			
			and (@BillingGroupKey is null Or i.BillingGroupKey = @BillingGroupKey)
		ELSE
		-- Project WS, this is not a Master WS
		-- Query based on client AND project on Invoice Lines	
		
		Select
			1 as Applied,
			i.InvoiceKey, 
			i.InvoiceNumber, 
			i.InvoiceDate, 
			i.Posted,
			i.InvoiceTotalAmount, 
			(ISNULL(InvoiceTotalAmount, 0)
				 - ISNULL((Select Sum(Amount) from tInvoiceAdvanceBill (nolock) 
					Where tInvoiceAdvanceBill.AdvBillInvoiceKey = i.InvoiceKey), 0)
				 - ISNULL((Select Sum(Amount) from tBillingPayment (nolock) 
					inner join tBilling (nolock) on tBilling.BillingKey = tBillingPayment.BillingKey
					Where tBillingPayment.Entity = 'INVOICE' 
					and tBilling.Status < 5
					and tBillingPayment.EntityKey = i.InvoiceKey), 0))
			as UnAppliedAmount,
			bp.BillingPaymentKey as InvoiceAdvanceBillKey,
			p.ProjectNumber,
			cp.CampaignID,
			bp.Amount,
			bg.BillingGroupCode
		From 
			tInvoice i (nolock)
			inner join tBillingPayment bp (nolock) on i.InvoiceKey = bp.EntityKey and bp.Entity = 'INVOICE'
			left outer join tProject p (nolock) on i.ProjectKey = p.ProjectKey
			left outer join tCampaign cp (NOLOCK) on p.CampaignKey = cp.CampaignKey
			left outer join tBillingGroup bg (nolock) on i.BillingGroupKey = bg.BillingGroupKey
		Where
			bp.BillingKey = @BillingKey

		UNION ALL

		Select
			0 as Applied,
			i.InvoiceKey, 
			i.InvoiceNumber, 
			i.InvoiceDate, 
			i.Posted,
			i.InvoiceTotalAmount, 
			i.InvoiceTotalAmount 
				- ISNULL((Select Sum(Amount) from tInvoiceAdvanceBill (nolock) 
					Where tInvoiceAdvanceBill.AdvBillInvoiceKey = i.InvoiceKey), 0)
				- ISNULL((Select Sum(Amount) from tBillingPayment (nolock) 
					inner join tBilling (nolock) on tBilling.BillingKey = tBillingPayment.BillingKey
					Where tBillingPayment.Entity = 'INVOICE' 
					and tBilling.Status < 5
					and tBillingPayment.EntityKey = i.InvoiceKey), 0)
				as UnAppliedAmount,	
			0,
			p.ProjectNumber,
			cp.CampaignID,
			0,
			bg.BillingGroupCode
		From
			tInvoice i (nolock)
			left outer join tProject p (nolock) on i.ProjectKey = p.ProjectKey
			left outer join tCampaign cp (NOLOCK) on p.CampaignKey = cp.CampaignKey
			left outer join tBillingGroup bg (nolock) on i.BillingGroupKey = bg.BillingGroupKey
		Where
			i.AdvanceBill = 1 and
			i.InvoiceStatus = 4 and
			i.ClientKey = @ClientKey and
			i.InvoiceTotalAmount > 0 and
			i.InvoiceKey not in (Select EntityKey from tBillingPayment (nolock)
							Where tBillingPayment.BillingKey = @BillingKey) 
			and				
				(ISNULL(InvoiceTotalAmount, 0)
				 - ISNULL((Select Sum(Amount) from tInvoiceAdvanceBill (nolock) 
					Where tInvoiceAdvanceBill.AdvBillInvoiceKey = i.InvoiceKey), 0)
				 - ISNULL((Select Sum(Amount) from tBillingPayment (nolock) 
					inner join tBilling (nolock) on tBilling.BillingKey = tBillingPayment.BillingKey
					Where tBillingPayment.Entity = 'INVOICE' 
					and tBilling.Status < 5
					and tBillingPayment.EntityKey = i.InvoiceKey), 0)) > 0

			and (exists (select 1 from tInvoiceLine il (nolock) where il.InvoiceKey = i.InvoiceKey
						and il.ProjectKey = @ProjectKey)
						Or p.ProjectKey = @ProjectKey)


			and ISNULL(i.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) 

			and (@BillingGroupKey is null Or i.BillingGroupKey = @BillingGroupKey)
		
END
ELSE
BEGIN
	-- Applied Only
		Select
			1 as Applied,
			i.InvoiceKey, 
			i.InvoiceNumber, 
			i.InvoiceDate, 
			i.Posted,
			i.InvoiceTotalAmount, 
			(ISNULL(InvoiceTotalAmount, 0)
				 - ISNULL((Select Sum(Amount) from tInvoiceAdvanceBill (nolock) 
				 Where tInvoiceAdvanceBill.AdvBillInvoiceKey = i.InvoiceKey), 0)
				 - ISNULL((Select Sum(Amount) from tBillingPayment (nolock) 
					inner join tBilling (nolock) on tBilling.BillingKey = tBillingPayment.BillingKey
					Where tBillingPayment.Entity = 'INVOICE' 
					and tBilling.Status < 5
				 and tBillingPayment.EntityKey = i.InvoiceKey), 0))
			as UnAppliedAmount,
			bp.BillingPaymentKey as InvoiceAdvanceBillKey,
			p.ProjectNumber,
			cp.CampaignID,
			bp.Amount,
			bg.BillingGroupCode
		From 
			tInvoice i (nolock)
			inner join tBillingPayment bp (nolock) on i.InvoiceKey = bp.EntityKey and bp.Entity = 'INVOICE'
			left outer join tProject p (nolock) on i.ProjectKey = p.ProjectKey
			left outer join tCampaign cp (NOLOCK) on p.CampaignKey = cp.CampaignKey
			left outer join tBillingGroup bg (nolock) on i.BillingGroupKey = bg.BillingGroupKey
		Where
			bp.BillingKey = @BillingKey


END
GO
