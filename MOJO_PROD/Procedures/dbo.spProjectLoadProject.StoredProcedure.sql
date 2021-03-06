USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectLoadProject]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectLoadProject]
	(
	@ProjectKey int
	)
AS

/*
|| When      Who Rel      What
|| 4/14/08   CRG 1.0.0.0  Added LockCompany for use by the Setup screen.
|| 4/21/08   CRG 1.0.0.0  Added LockNonBillable for use by the Setup screen.
|| 5/28/09   GWG 10.5     Add opportunity subject
|| 7/28/09   CRG 10.5.0.4 Added Client fields because we switched the screen to a Client lookup from a combo.
|| 08/19/09  MAS 10.5.0.7 (58951)Added tRequest.RequestID used for ProjectRequest Lookup in Project->Setup
|| 09/02/09  GWG 10.5.0.9 Added Campaign ID and name
|| 12/20/09  GWG 10.5.1.5 Added the new layout and segments to the get
|| 05/18/12  GHL 10.5.5.6 Added user names because we are using now lookups vs comboboxes
|| 05/18/12  RLB 10.5.5.6 Added OfficeID and OfficeName because we are using now lookups vs comboboxes
|| 09/26/12  GHL 10.5.6.0 Added Billing Group info for HMI request
|| 08/26/13  RLB 10.5.7.1 (170225) Added Billing Manager Name
|| 09/22/14  MAS 10.5.8.3 Added lockBilling for Abelson Taylor to lock divisions/products if the project has been billed
|| 11/06/14  RLB 10.5.8.6 Added LockLaborRate and LockMarkupFrom  for Abelson Taylor
|| 02/02/15  GHL 10.5.8.8 Abelson new requirements: lock division and product if transactions are billed, marked as billed, written off,
||                        posted to wip or on billing worksheets
||                        Also tried to limit the number of queries in tTime
|| 02/27/15  GHL 10.5.8.9 For Abelson, do not consider transferred transactions when setting the lock of divisions
|| 04/17/15  GHL 10.5.9.1 (253794) Check transactions to lock Currency
*/

DECLARE @MultiCurrency INT
SELECT @MultiCurrency = ISNULL(MultiCurrency, 0) 
FROM tPreference pref (NOLOCK) 
INNER JOIN tProject p (NOLOCK) ON pref.CompanyKey = p.CompanyKey
WHERE p.ProjectKey = @ProjectKey

DECLARE @LockCurrency INT			SELECT @LockCurrency = 0
DECLARE @LockCompany INT			SELECT @LockCompany = 0
DECLARE @LockDivisionProduct INT	SELECT @LockDivisionProduct = 0 -- used to lock the Division and Product for Abelson Taylor

if exists(Select 1 from tInvoiceLine (nolock) Where ProjectKey = @ProjectKey)
	Select @LockCompany = 1
	
if @LockCompany = 0 and exists(Select 1 from tVoucherDetail (nolock) Where ProjectKey = @ProjectKey)
	Select @LockCompany = 1
	
if exists(Select 1 from tMiscCost (nolock) Where ProjectKey = @ProjectKey and (InvoiceLineKey > 0 or WIPPostingInKey > 0 or WIPPostingOutKey > 0))
	Select @LockCompany = 1
		  ,@LockDivisionProduct = 1

if @LockDivisionProduct = 0 and exists(Select 1 from tExpenseReceipt (nolock) Where ProjectKey = @ProjectKey and (InvoiceLineKey > 0 or WIPPostingInKey > 0 or WIPPostingOutKey > 0))
	Select @LockCompany = 1
		  ,@LockDivisionProduct = 1
	
if @LockDivisionProduct = 0 and exists(Select 1 from tVoucherDetail (nolock) Where ProjectKey = @ProjectKey and (InvoiceLineKey > 0 or WIPPostingInKey > 0 or WIPPostingOutKey > 0))
	Select @LockCompany = 1
		  ,@LockDivisionProduct = 1

if @LockDivisionProduct = 0 and exists(Select 1 from tTime (nolock) Where ProjectKey = @ProjectKey and (InvoiceLineKey > 0 or WIPPostingInKey > 0 or WIPPostingOutKey > 0))
	Select @LockCompany = 1
		  ,@LockDivisionProduct = 1
	
if @LockCompany = 0  and exists(Select 1 from tPurchaseOrderDetail (nolock) Where ProjectKey = @ProjectKey)
	Select @LockCompany = 1

if @LockDivisionProduct = 0 and exists(Select 1 from tBilling (nolock) Where ProjectKey = @ProjectKey)
	Select @LockCompany = 1
		  ,@LockDivisionProduct = 1
	
Declare	@LockNonBillable int
Select	@LockNonBillable = 0
	
if exists(Select 1 from tMiscCost (nolock) Where ProjectKey = @ProjectKey and WIPPostingInKey <> 0 and WIPPostingOutKey = 0)
	Select @LockNonBillable = 1
	
if @LockNonBillable = 0 and exists(Select 1 from tExpenseReceipt (nolock) Where ProjectKey = @ProjectKey and WIPPostingInKey <> 0 and WIPPostingOutKey = 0)
	Select @LockNonBillable = 1
	
if @LockNonBillable = 0 and exists(Select 1 from tVoucherDetail (nolock) Where ProjectKey = @ProjectKey and WIPPostingInKey <> 0 and WIPPostingOutKey = 0)
	Select @LockNonBillable = 1

if @LockNonBillable = 0 and exists(Select 1 from tTime (nolock) Where ProjectKey = @ProjectKey and WIPPostingInKey <> 0 and WIPPostingOutKey = 0)
	Select @LockNonBillable = 1


if exists (select 1 from tPreference pref (nolock)
			inner join tProject p (nolock) on pref.CompanyKey = p.CompanyKey 
            where p.ProjectKey = @ProjectKey
			and   lower(pref.Customizations) like '%abelson%' 
		  )
	begin
		-- if allready locked, no need to check further, so only do this if @LockDivisionProduct = 0 
		if @LockDivisionProduct = 0
		begin
			-- we have already checked if transactions were billed or in WIP
			-- we need to check now if transactions where marked as billed or written off  
			if exists (Select 1 from tMiscCost (nolock) Where ProjectKey = @ProjectKey and (InvoiceLineKey = 0 or WriteOff = 1))
				Select @LockDivisionProduct = 1

			if @LockDivisionProduct = 0 and exists(
				Select 1 from tExpenseReceipt (nolock) Where ProjectKey = @ProjectKey and (InvoiceLineKey = 0 or WriteOff = 1)
				and TransferToKey is null				
			)
				Select @LockDivisionProduct = 1

			if @LockDivisionProduct = 0 and exists(
				Select 1 from tVoucherDetail (nolock) Where ProjectKey = @ProjectKey and (InvoiceLineKey = 0 or WriteOff = 1)
				and TransferToKey is null
				)
				Select @LockDivisionProduct = 1

			if @LockDivisionProduct = 0 and exists(
				Select 1 from tPurchaseOrderDetail (nolock) Where ProjectKey = @ProjectKey and InvoiceLineKey >= 0
				and TransferToKey is null
				)
				Select @LockDivisionProduct = 1

			if @LockDivisionProduct = 0 and exists(
				Select 1 from tTime (nolock) Where ProjectKey = @ProjectKey and (InvoiceLineKey = 0 or WriteOff = 1)
				and TransferToKey is null
				)
				Select @LockDivisionProduct = 1

		end
	end
else
	begin
		-- no need to lock division and product
		select @LockDivisionProduct = 0
	end

IF @MultiCurrency = 1
BEGIN
	-- check transactions for the currency, starting with the least costly
	IF @LockCompany = 1
		SELECT @LockCurrency = 1

	IF @LockCurrency = 0 
		IF EXISTS (SELECT 1 FROM tMiscCost (NOLOCK) WHERE ProjectKey = @ProjectKey)
			SELECT @LockCurrency = 1

	IF @LockCurrency = 0 
		IF EXISTS (SELECT 1 FROM tExpenseReceipt (NOLOCK) WHERE ProjectKey = @ProjectKey)
			SELECT @LockCurrency = 1

	IF @LockCurrency = 0 
		IF EXISTS (SELECT 1 FROM tTime (NOLOCK) WHERE ProjectKey = @ProjectKey)
			SELECT @LockCurrency = 1
END

select	p.* 
		,l.Subject as LeadSubject
		,@LockCompany AS LockCompany
		,@LockNonBillable AS LockNonBillable
		,@LockDivisionProduct AS LockBilling -- Change name to the one used in Flex 
		,@LockCurrency AS LockCurrency
		,(select isnull(count(*),0) from tInvoiceLine (nolock) where tInvoiceLine.ProjectKey = @ProjectKey) as Invoiced
		,ps.Locked as StatusLocked
		,c.CustomerID AS ClientID
		,c.CompanyName AS ClientName
		,c.LockLaborRate
		,c.LockMarkupFrom
		,r.RequestID AS RequestID
		,ca.CampaignID
		,ca.CampaignName
		,cs.SegmentName
		,la.LayoutName
		,o.OfficeID
		,o.OfficeName
		,bg.BillingGroupCode as BillingGroup -- cannot use BillingGroupCode because I use BillingGroupCode for conversion 
		 
		,case when u1.UserKey is null then null else ISNULL(u1.FirstName, '') + ' ' + ISNULL(u1.LastName, '') end AS KeyPeople1UserName
		,case when u2.UserKey is null then null else ISNULL(u2.FirstName, '') + ' ' + ISNULL(u2.LastName, '') end AS KeyPeople2UserName
		,case when u3.UserKey is null then null else ISNULL(u3.FirstName, '') + ' ' + ISNULL(u3.LastName, '') end AS KeyPeople3UserName
		,case when u4.UserKey is null then null else ISNULL(u4.FirstName, '') + ' ' + ISNULL(u4.LastName, '') end AS KeyPeople4UserName
		,case when u5.UserKey is null then null else ISNULL(u5.FirstName, '') + ' ' + ISNULL(u5.LastName, '') end AS KeyPeople5UserName
		,case when u6.UserKey is null then null else ISNULL(u6.FirstName, '') + ' ' + ISNULL(u6.LastName, '') end AS KeyPeople6UserName
		,case when uam.UserKey is null then null else ISNULL(uam.FirstName, '') + ' ' + ISNULL(uam.LastName, '') end AS AccountManagerUserName
		,case when ubm.UserKey is null then null else ISNULL(ubm.FirstName, '') + ' ' + ISNULL(ubm.LastName, '') end AS BillingManagerName
from	tProject p (nolock) 
inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
inner join tPreference pref (nolock) on p.CompanyKey = pref.CompanyKey
left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
left outer join tLead l (nolock) on p.LeadKey = l.LeadKey
left outer join tRequest r (nolock) on r.RequestKey = p.RequestKey
left outer join tCampaign ca (nolock) on p.CampaignKey = ca.CampaignKey
left outer join tCampaignSegment cs (nolock) on p.CampaignSegmentKey = cs.CampaignSegmentKey
left outer join tLayout la (nolock) on p.LayoutKey = la.LayoutKey

left outer join tUser u1 (nolock) on p.KeyPeople1 = u1.UserKey
left outer join tUser u2 (nolock) on p.KeyPeople2 = u2.UserKey
left outer join tUser u3 (nolock) on p.KeyPeople3 = u3.UserKey
left outer join tUser u4 (nolock) on p.KeyPeople4 = u4.UserKey
left outer join tUser u5 (nolock) on p.KeyPeople5 = u5.UserKey
left outer join tUser u6 (nolock) on p.KeyPeople6 = u6.UserKey
left outer join tUser uam (nolock) on p.AccountManager = uam.UserKey
left outer join tUser ubm (nolock) on p.BillingManagerKey = ubm.UserKey
left outer join tOffice o (nolock) on p.OfficeKey = o.OfficeKey
left outer join tBillingGroup bg (nolock) on p.BillingGroupKey = bg.BillingGroupKey

Where	p.ProjectKey = @ProjectKey
GO
