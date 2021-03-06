USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderGet]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderGet]
	@PurchaseOrderKey int = NULL,
	@PurchaseOrderNumber varchar(30) = NULL,
	@CompanyKey int = NULL

AS --Encrypt

/*
|| 02/28/07 BSH 8.4.0.2 Removed '-' in Approved By
|| 07/12/07 BSH 8.5     (9659)Get GLCompanyName
|| 01/17/08 BSH 8.5     (18369)Check if any VI lines have been applied.
|| 05/08/09 GHL 10.025  Added AccruedBalance
|| 11/20/09 MFT 10.515	Added GLCompanyID for GLCompanyLookup control
|| 11/24/09 MFT 10.515  Added tSalesTax for SalesTaxLookup controls, StatusName
|| 12/03/09 MFT 10.515  Added @PurchaseOrderNumber parameter
|| 09/10/10 MFT 10.535  Added tPurchaseOrderUser query
|| 02/10/12 MFT 10.552  Added BillingID
|| 12/13/12 WDF 10.563  (162210) Added LastUpdateByName
|| 07/08/13 WDF 10.570  (176947) Added MarketID/MarketName
|| 09/05/13 CRG 10.572  Now joining the main query out to tMediaSpace, tMediaPosition, tCompanyMediaContract, tMediaUnitType
|| 09/16/13 CRG 10.572  Added MediaPrintSpaceID
|| 09/30/13 CRG 10.573  Added POMarketID, and POMarketName which is linked to the MediaMarketKey in tPurchaseOrder,
||                      rather than the existing MarketID and MarketName which is linked to tCompanyMedia.
|| 10/11/13 CRG 10.573  Added rollup of GrossAmount
|| 10/30/13 CRG 10.573  Added VoucherTotal
|| 12/09/13 GHL 10.575  Added ProjectBillable, Office fields for new flex PO screen 
||                      (to set correct tVoucherDetail.Billable + Office when adding lines) 
|| 12/09/13 CRG 10.575  Added MediaPrintPositionID
|| 12/23/13 CRG 10.575	Fixed flaw in Rollup logic for new Media PO's
|| 03/04/14 GHL 10.577  Added Publication's Frequency + Circulation (tCompanyMedia)
|| 03/14/14 CRG 10.578  Added BillingBase, BillingAdjPercent, BillingAdjBase. 
||                      If they're NULL on the PO, get them from the Media Worksheet. Because the query is getting po.*, then I am calling these columns
||                      BillingBase2, etc. in the final query
|| 03/18/14 CRG 10.578  Now returning PositionName instead of PositionShortName from tMediaPosition to match the settings on the lookup control
|| 03/28/14 CRG 10.578  Added MediaCategory ID and Name
|| 04/02/14 CRG 10.578  Added CreatedByName
|| 04/10/14 CRG 10.579  Added WSDemoID
|| 04/18/14 GHL 10.579  Added Client and Worksheet
|| 06/23/14 GHL 10.581  Added calculation of UnitCost and UnitRate because the grid is showing the top POD row right now
|| 10/07/14 GHL 10.585  Added Sales tax full name to display on a label on the new media screen
|| 11/03/14 GHL 10.586  Fixed problem with returning pod.SalesTax1Amount as SalesTax1Amount because there is 
||                      already a po.SalesTax1Amount. Returning now OrderSalesTax1Amount and I will have to overwrite
||                      SalesTax1Amount = OrderSalesTax1Amount in BuyBase.vb
|| 12/29/14 GHL 10.587  (240381) When calculating AmountBilled, check that InvoiceLineKey > 0
*/

IF @PurchaseOrderKey IS NULL
	SELECT
		@PurchaseOrderKey = PurchaseOrderKey
	FROM
		tPurchaseOrder (nolock)
	WHERE
		CompanyKey = @CompanyKey AND
		PurchaseOrderNumber = @PurchaseOrderNumber

IF @PurchaseOrderKey IS NULL
	RETURN -1

Declare @Billed tinyint, @BillingDetail tinyint, @BillingID int, @MaxLine int, @VoucherDetail tinyint, @AccruedBalance money, @VoucherTotal money

If exists(Select 1 from tPurchaseOrderDetail (nolock) Where PurchaseOrderKey = @PurchaseOrderKey and InvoiceLineKey > 0)
	Select @Billed = 1
else
	Select @Billed = 0

Select @BillingID = b.BillingID
from
	tBillingDetail bd (nolock)
	inner join tPurchaseOrderDetail pod (nolock) on bd.EntityKey = pod.PurchaseOrderDetailKey AND bd.Entity = 'tPurchaseOrderDetail'
	inner join tBilling b (nolock) on bd.BillingKey = b.BillingKey  
Where
	pod.PurchaseOrderKey = @PurchaseOrderKey AND
	b.Status < 5
IF ISNULL(@BillingID, 0) > 0
	Select @BillingDetail = 1
else
	BEGIN
		Select
			@BillingDetail = 0,
			@BillingID = 0
	END

if exists (select 1 from tVoucherDetail vd (nolock)
				inner join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
				inner join tPurchaseOrder po (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey
			where po.PurchaseOrderKey = @PurchaseOrderKey)
BEGIN
	Select @VoucherDetail = 1
	
	SELECT	@VoucherTotal = SUM(vd.TotalCost)
	FROM	tVoucherDetail vd (nolock)
	INNER JOIN tPurchaseOrderDetail pod (nolock) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
	INNER JOIN tPurchaseOrder po (nolock) ON po.PurchaseOrderKey = pod.PurchaseOrderKey
	WHERE	po.PurchaseOrderKey = @PurchaseOrderKey
END
else
	Select @VoucherDetail = 0
		

-- Added for Spots, Adjustments, Make Goods who share same line number
Select @MaxLine = ISNULL(MAX(LineNumber), 0)
From   tPurchaseOrderDetail (nolock)
Where  PurchaseOrderKey = @PurchaseOrderKey 
	
-- Do not use ISNULL here since we need to know in the UI if records exist	
SELECT @AccruedBalance = SUM(toa.AccrualAmount - toa.UnaccrualAmount)
FROM   tPurchaseOrderDetail pod (NOLOCK)
	INNER JOIN tTransactionOrderAccrual toa (NOLOCK) 
		ON pod.PurchaseOrderDetailKey = toa.PurchaseOrderDetailKey
WHERE  pod.PurchaseOrderKey = @PurchaseOrderKey
	
-- These vars are required to get the Rate History displayed on the UI for each currency 
DECLARE @GLCompanyKey int
DECLARE @MultiCurrency int
DECLARE @PODate smalldatetime
DECLARE @CurrencyID varchar(10)
DECLARE @ExchangeRate decimal(24,7) -- not the rate on the check header but the one in rate history
DECLARE @RateHistory int
DECLARE @PCurrencyID varchar(10)
DECLARE @PExchangeRate decimal(24,7) -- not the rate on the check header but the one in rate history
DECLARE @PRateHistory int
DECLARE @HasOtherCurrency int -- can be used to prevent from using the old PO screen

select @CompanyKey = po.CompanyKey
	  ,@GLCompanyKey = isnull(po.GLCompanyKey, 0) 
      ,@CurrencyID = po.CurrencyID
	  ,@PCurrencyID = po.PCurrencyID
	  ,@PODate = po.PODate
	  ,@MultiCurrency = isnull(pref.MultiCurrency, 0)
from   tPurchaseOrder po (nolock)
inner join tPreference pref (nolock) on po.CompanyKey = pref.CompanyKey
where  po.PurchaseOrderKey = @PurchaseOrderKey

-- get the rate history for day/gl comp/curr needed to display on screen
if @MultiCurrency = 1 and isnull(@CurrencyID, '') <> ''
	exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @CurrencyID, @PODate, @ExchangeRate output, @RateHistory output
if @MultiCurrency = 1 and isnull(@PCurrencyID, '') <> ''
	exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @PCurrencyID, @PODate, @PExchangeRate output, @PRateHistory output

select @HasOtherCurrency = 0

if isnull(@CurrencyID, '') <> ''
	select @HasOtherCurrency = 1
if isnull(@PCurrencyID, '') <> ''
	select @HasOtherCurrency = 1
if exists (select 1 from tPurchaseOrderDetail (nolock)
			where PurchaseOrderKey = @PurchaseOrderKey
			and isnull(PCurrencyID, '') <> ''
			)
			select @HasOtherCurrency = 1

	SELECT 
		po.*, 
		@Billed as Billed,
		@BillingDetail as BillingDetail,
		@BillingID AS BillingID,
		@VoucherDetail as VoucherDetail,
		@AccruedBalance as AccruedBalance,
		c.VendorID,
		c.CompanyName,
		isnull(c.VendorID, '') + ' - ' +  c.CompanyName as VendorFullName,
		pot.PurchaseOrderTypeName,
		pot.HeaderFieldSetKey,
		pot.DetailFieldSetKey,
		p.ProjectNumber,
		p.ProjectName,
		p.ProjectNumber + ' - ' + p.ProjectName as ProjectFullName,
		p.GetMarkupFrom,
		p.ItemMarkup,
		p.IOCommission,
		p.BCCommission,
		case when isnull(p.NonBillable, 0) = 1 then 0 else 1 end as ProjectBillable,
		o.OfficeKey,
		o.OfficeID,
		o.OfficeName,
		t.TaskID,
		t.TaskName,
		i.ItemID,
		i.ItemName,
		cl.ClassID,
		cl.ClassName,
		u.FirstName + ' ' + u.LastName as ApprovedByName,
		u2.FirstName + ' ' + u2.LastName as LastUpdateByName,
		me.EstimateID,
		cm.StationID,
		cm.Name as StationName,
		pod.TotalCost,
		pod.BillableCost,
		pod.AppliedCost,
		pod.AmountBilled,
		pod.LineCount,
		pod.GrossAmount,
		pod.Quantity,
		pod.Quantity1,
		pod.Quantity2,
		pod.SalesTax1Amount as OrderSalesTax1Amount, -- because there is a po.SalesTax1Amount
		pod.SalesTax2Amount as OrderSalesTax2Amount, -- because there is a po.SalesTax2Amount
		case when isnull(pod.Quantity, 0) = 0 then pod.TotalCost else pod.TotalCost/pod.Quantity end as UnitCost, 
		case when isnull(pod.Quantity, 0) = 0 then pod.GrossAmount else pod.GrossAmount/pod.Quantity end as UnitRate, 
		cm.Date1Days,
		cm.Date2Days,
		cm.Date3Days,
		cm.Date4Days,
		cm.Date5Days,
		cm.Date6Days,
		cm.Frequency,
		cm.Circulation, 
		mm.MarketID,
		mm.MarketName,
		pomm.MarketID AS POMarketID,
		pomm.MarketName AS POMarketName,
		@MaxLine as MaxLine,
		glc.GLCompanyName,
		glc.GLCompanyID,
		st1.SalesTaxID,
		st1.SalesTaxName,
		st1.SalesTaxID + ' - ' + st1.SalesTaxName as SalesTaxFullName,
		st2.SalesTaxID AS SalesTaxID2,
		st2.SalesTaxName AS SalesTaxName2,
		st2.SalesTaxID + ' - ' + st2.SalesTaxName as SalesTaxFullName2,

		st1.SalesTaxName as SalesTax1Name, 
		st1.TaxRate as Tax1Rate,
		st1.PiggyBackTax as PiggyBackTax1,
		st2.SalesTaxName as SalesTax2Name,
		st2.TaxRate as Tax2Rate,
		st2.PiggyBackTax as PiggyBackTax2,
		ISNULL(ms.SpaceID, po.MediaPrintSpaceID) as MediaPrintSpaceID2,
		ms.SpaceName,
		mp.PositionName,
		ISNULL(mp.PositionID, po.MediaPrintPositionID) AS MediaPrintPositionID2,
		cmc.ContractID,
		cmc.ContractName,
		mut.UnitTypeID,
		mut.UnitTypeName,
		CASE po.Status
			WHEN 1 THEN 'Not Sent For Approval'
			WHEN 2 THEN 'Sent for Approval'
			WHEN 3 THEN 'Rejected'
			WHEN 4 THEN 'Approved' END + CASE po.Closed WHEN 1 THEN ' (Closed)' ELSE '' END AS StatusName,
		ISNULL(@VoucherTotal, 0) AS VoucherTotal,

		@RateHistory as RateHistory,
		@PRateHistory as PRateHistory,
		@HasOtherCurrency as HasOtherCurrency,
		ISNULL(po.BillingBase, mw.BillingBase) AS BillingBase2,
		ISNULL(po.BillingAdjPercent, mw.BillingAdjPercent) AS BillingAdjPercent2,
		ISNULL(po.BillingAdjBase, mw.BillingAdjBase) AS BillingAdjBase2,
		mc.CategoryID,
		mc.CategoryName,
		u3.UserName AS CreatedByName,
		ISNULL(md.DemographicID, '') + ' / ' + ISNULL(wd.DemoType, '') AS WSDemoID,
		mw.WorksheetID,
		mw.ClientKey,
		cli.CustomerID as ClientID,
		cli.CompanyName as ClientName,
		isnull(cli.CustomerID, '') + ' - ' +  cli.CompanyName as ClientFullName
	FROM 
		tPurchaseOrder po (nolock)
		inner join tCompany c (nolock) on po.VendorKey = c.CompanyKey
		left outer join tPurchaseOrderType pot (nolock) on po.PurchaseOrderTypeKey = pot.PurchaseOrderTypeKey
		left outer join tProject p (nolock) on po.ProjectKey = p.ProjectKey
		left outer join tTask t (nolock) on po.TaskKey = t.TaskKey
		left outer join tItem i (nolock) on po.ItemKey = i.ItemKey
		left outer join tUser u (nolock) on po.ApprovedByKey = u.UserKey
		left outer join tUser u2 (nolock) on po.LastUpdateBy = u2.UserKey
		left outer join vUserName u3 (nolock) on po.CreatedByKey = u3.UserKey
		left outer join tGLCompany glc (nolock) on po.GLCompanyKey = glc.GLCompanyKey
		left outer join tClass cl (nolock) on po.ClassKey = cl.ClassKey
		left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
		left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
		left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
		left outer join tMediaMarket pomm (nolock) on po.MediaMarketKey = pomm.MediaMarketKey
		left outer join tSalesTax st1 (nolock) on po.SalesTaxKey = st1.SalesTaxKey
		left outer join tSalesTax st2 (nolock) on po.SalesTax2Key = st2.SalesTaxKey
		left outer join tMediaSpace ms (nolock) on po.MediaPrintSpaceKey = ms.MediaSpaceKey
		left outer join tMediaPosition mp (nolock) on po.MediaPrintPositionKey = mp.MediaPositionKey
		left outer join tCompanyMediaContract cmc (nolock) on po.CompanyMediaPrintContractKey = cmc.CompanyMediaContractKey
		left outer join tMediaUnitType mut (nolock) on po.MediaUnitTypeKey = mut.MediaUnitTypeKey
		left outer join tOffice o (nolock) on p.OfficeKey = o.OfficeKey
		left outer join tMediaWorksheet mw (nolock) on po.MediaWorksheetKey = mw.MediaWorksheetKey
		left outer join tMediaCategory mc (nolock) on po.MediaCategoryKey = mc.MediaCategoryKey
		left outer join tMediaWorksheetDemo wd (nolock) on po.MediaWorksheetDemoKey = wd.MediaWorksheetDemoKey
		left outer join tMediaDemographic md (nolock) ON wd.MediaDemographicKey = md.MediaDemographicKey
		left outer join tCompany cli (nolock) on mw.ClientKey = cli.CompanyKey
		Left outer join 
		(Select PurchaseOrderKey, Count(*) as LineCount
			, Sum(TotalCost) as TotalCost
			, Sum(BillableCost) as BillableCost
			, sum(case when InvoiceLineKey > 0 then ISNULL(AmountBilled, 0) else 0 end) as AmountBilled
			, sum(AppliedCost) as AppliedCost
			, SUM(GrossAmount) as GrossAmount
			, SUM(Quantity) as Quantity
			, SUM(Quantity1) as Quantity1
			, SUM(Quantity2) as Quantity2
			, SUM(SalesTax1Amount) as SalesTax1Amount
			, SUM(SalesTax2Amount) as SalesTax2Amount
			From tPurchaseOrderDetail (nolock)
			Where
				(LineType IS NULL --For all regular PO's
				OR 
				ISNULL(tPurchaseOrderDetail.LineNumber, 1) = 1) --For new Media PO's
			Group By PurchaseOrderKey) as pod on pod.PurchaseOrderKey = po.PurchaseOrderKey
	WHERE
		po.PurchaseOrderKey = @PurchaseOrderKey
	
	SELECT
		u.*,
		po.VendorKey,
		pu.NotificationSent AS NotificationSent
	FROM
		tPurchaseOrderUser pu (nolock)
		INNER JOIN tPurchaseOrder po (nolock)
			ON pu.PurchaseOrderKey = po.PurchaseOrderKey
		INNER JOIN vUserName u (nolock)
			ON pu.UserKey = u.UserKey
	WHERE
		pu.PurchaseOrderKey = @PurchaseOrderKey
	
	RETURN 1
GO
