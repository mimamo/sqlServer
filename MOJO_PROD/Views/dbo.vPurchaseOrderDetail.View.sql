USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vPurchaseOrderDetail]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vPurchaseOrderDetail]
AS

/*
|| When     Who Rel     What
|| 11/1/06  CRG 8.35    Added HeaderProjectNumber and HeaderProjectName to the view.
|| 5/10/07  CRG 8.4.3   (9077) Added tMediaEstimate.EstimateID
|| 10/26/07 CRG 8.4.3.9 (15197) Fixed MPostalCode so it will print on the Insertion Order.
|| 10/22/08 GHL 10.5    (37963) Added company address on the po header
||					     I had a chat with Mike and we decided to do it this way.
||                       I will put an address on the header of the PO.
||                       If this is not null, we will get the address from it
||                       If the GL company is not null, get the Printed Name from it in lieu of the company name
||                       If the GL company is not null, get the phone # from it in lieu of the company phone
|| 11/19/09 GHL 10.513   (68837) Added filter on TransferToKey
|| 12/08/11 RLB 10.551  (128190) Removed pulling the detail project number and name if there is no project on header
|| 09/05/12 MFT 10.559  (153457) CAddress override for GL Company
|| 11/26/12 RLB 10.562  (160342) If a Company address is selected use that over a GL Company Address
|| 09/27/13 MFT 10.572  Additional fields for new IO
|| 01/12/14 MFT 10.576  Changed tClientProduct join to override the worksheet ISNULL(mws.ClientProductKey, p.ClientProductKey)
|| 01/23/14 GHL 10.576  Added Currency ID
|| 04/29/14 MFT 10.579  Added "Old" fields from pod
|| 06/04/14 GHL 10.581  Added OldMediaPrintPositionID
|| 06/05/14 GHL 10.581  Added logic for manual premiums
|| 06/09/14 GHL 10.581  Added Media Order Revision
*/

SELECT po.*,
	ISNULL(po.PurchaseOrderTotal, 0) - ISNULL(po.SalesTax1Amount, 0) - ISNULL(po.SalesTax2Amount, 0) AS TotalNonTaxAmount,
	c.CompanyName AS VendorName,
	c.VendorID,
	pod.PurchaseOrderDetailKey,
	pod.LineNumber,
	pod.AdjustmentNumber,
	ISNULL(p.ProjectNumber, '') as ProjectNumber,
	ISNULL(p.ProjectName, '') as ProjectName,
	p.ClientKey,
	p.AccountManager,
	p.Active,
	p.ProjectStatusKey,
	t.TaskID,
	t.TaskName,
	ISNULL(pod.LineType, '') AS LineType,
	pod.ProjectKey as LineProjectKey,
	pod.ShortDescription,
	pod.LongDescription,
	ISNULL(pod.Quantity, 0) as Quantity,
	ISNULL(pod.UnitCost, 0) as UnitCost,
	ISNULL(pod.UnitRate, 0) AS UnitRate,
	pod.UnitDescription,
	ISNULL(pod.TotalCost, 0) as TotalCost,
	pod.Billable,
	pod.Markup,
	ISNULL(pod.BillableCost, 0) as BillableCost,
	pod.DetailOrderDate,
	pod.DetailOrderEndDate,
	pod.UserDate1,
	pod.UserDate2,
	pod.UserDate3,
	pod.UserDate4,
	pod.UserDate5,
	pod.UserDate6,
	pod.OrderDays,
	pod.OrderTime,
	pod.OrderLength,
	pod.Closed as LineClosed,
	ISNULL(pod.AppliedCost, 0) as AppliedCost,
	ISNULL(pod.TotalCost, 0) - ISNULL(pod.AppliedCost, 0) as OpenAmount,
	pod.CustomFieldKey as DetailCustomFieldKey,
	ISNULL(pod.GrossAmount, 0) AS GrossAmount,
	pod.OldDetailOrderDate,
	pod.OldShortDescription,
	pod.OldMediaPrintSpaceKey,
	pod.OldMediaPrintPositionKey,
	pod.OldCompanyMediaPrintContractKey,
	pod.OldMediaPrintSpaceID,
	pod.OldMediaPrintPositionID,
	
	case when isnull(po.GLCompanyKey, 0) > 0 then gl.PrintedName else c1.CompanyName end as CompanyName,
	case when isnull(po.GLCompanyKey, 0) > 0 then gl.Phone else c1.Phone end as CPhone,
	case when isnull(po.GLCompanyKey, 0) > 0 then gl.Fax else c1.Fax end as CFax,
	
	CASE WHEN ISNULL(po.CompanyAddressKey, 0) > 0 THEN a_po.Address1 ELSE
		case when isnull(gl.AddressKey, 0) > 0 then a_gl.Address1 else a_c1.Address1 end END AS CAddress1,
	CASE WHEN ISNULL(po.CompanyAddressKey, 0) > 0 THEN a_po.Address2 ELSE
		case when isnull(gl.AddressKey, 0) > 0 then a_gl.Address2 else a_c1.Address2 end END AS CAddress2,
	CASE WHEN ISNULL(po.CompanyAddressKey, 0) > 0 THEN a_po.Address3 ELSE
		case when isnull(gl.AddressKey, 0) > 0 then a_gl.Address3 else a_c1.Address3 end END AS CAddress3,
	CASE WHEN ISNULL(po.CompanyAddressKey, 0) > 0 THEN a_po.City ELSE
		case when isnull(gl.AddressKey, 0) > 0 then a_gl.City else a_c1.City end END AS CCity,
	CASE WHEN ISNULL(po.CompanyAddressKey, 0) > 0 THEN a_po.State ELSE
		case when isnull(gl.AddressKey, 0) > 0 then a_gl.State else a_c1.State end END AS CState,
	CASE WHEN ISNULL(po.CompanyAddressKey, 0) > 0 THEN a_po.PostalCode ELSE
		case when isnull(gl.AddressKey, 0) > 0 then a_gl.PostalCode else a_c1.PostalCode end END AS CPostalCode,
	CASE WHEN ISNULL(po.CompanyAddressKey, 0) > 0 THEN a_po.Country ELSE
		case when isnull(gl.AddressKey, 0) > 0 then a_gl.Country else a_c1.Country end END AS CCountry,

	Case When ISNULL(po.CompanyMediaKey, 0) = 0 then c.Phone
		else cm.Phone end as StationPhone,
	Case When ISNULL(po.CompanyMediaKey, 0) = 0 then c.Fax
		else cm.Fax end as StationFax,
	cm.Name as StationName,
	cm.Address1 as CMAddress1,
	cm.Address2 as CMAddress2,
	cm.Address3 as CMAddress3,
	cm.City as CMCity,
	cm.State as CMState,
	cm.PostalCode as CMPostalCode,
	cm.Country as CMCountry,
	cm.Phone as CMPhone,
	cm.Fax as CMFax,
	cm.PrintMaterialsInfo,
	cm.MAddress1 as MAddress1,
	cm.MAddress2 as MAddress2,
	cm.MAddress3 as MAddress3,
	cm.MCity as MCity,
	cm.MState as MState,
	cm.MPostalCode as MPostalCode,
	cm.MCountry as MCountry,
	cm.MPhone as MPhone,
	cm.MFax as MFax,
	cm.MMaterials as MMaterials,
	c.Phone,
	c.Fax,
	u.UserKey,
	u.FirstName + ' ' + u.LastName as MediaContactName,
	stext.StandardText as HeaderText,
	stext2.StandardText as FooterText,
	st1.SalesTaxName AS SalesTax1Name,
	st2.SalesTaxName AS SalesTax2Name,
	ISNULL(p2.ProjectNumber, '') as HeaderProjectNumber,
	ISNULL(p2.ProjectName, '') as HeaderProjectName,
	me.EstimateID,
	mm.MarketID,
	mm.MarketName,
	ISNULL(ms.SpaceID, po.MediaPrintSpaceID) as SpaceID,
	ISNULL(mp.PositionID, po.MediaPrintPositionID) as PositionID,
	mp.PositionName,
	mp.PositionShortName,
	mws.ClientKey AS WSClientKey,
	mws.WorksheetName,
	cl.CompanyName AS WSClientName,
	cl.CustomerID AS WSClientID,
	cp.ProductName,
	cmp.CampaignName,
	case when mpm.MediaPremiumKey > 0 then mpm.PremiumName 
		else
			-- manual premium, no key
			case when isnull(po.MediaWorksheetKey, 0) > 0 and pod.LineNumber > 1 then pod.ShortDescription
			else null end
	end as PremiumName,
	case when mpm.MediaPremiumKey > 0 then mpm.PremiumID 
		else
			-- manual premium, no key
			case when isnull(po.MediaWorksheetKey, 0) > 0 and pod.LineNumber > 1 then pod.ShortDescription
			else null end
	end as PremiumID,
	case when mpm.MediaPremiumKey > 0 then mpm.PremiumShortName 
		else
			-- manual premium, no key
			case when isnull(po.MediaWorksheetKey, 0) > 0 and pod.LineNumber > 1 then pod.ShortDescription
			else null end
	end as PremiumShortName,
	case when mpm.MediaPremiumKey > 0 then mpm.Description 
		else
			-- manual premium, no key
			case when isnull(po.MediaWorksheetKey, 0) > 0 and pod.LineNumber > 1 then pod.ShortDescription
			else null end
	end as PremiumDescription,
	pod.PCurrencyID as LinePCurrencyID,
	mo.Revision as MediaOrderRevision
FROM
	tPurchaseOrder po (nolock)
	INNER JOIN tCompany c (nolock) on c.CompanyKey = po.VendorKey
	INNER JOIN tCompany c1 (nolock) ON po.CompanyKey = c1.CompanyKey
	LEFT OUTER JOIN tPurchaseOrderDetail pod (nolock) ON po.PurchaseOrderKey = pod.PurchaseOrderKey AND pod.TransferToKey is null
	LEFT OUTER JOIN tTask t (nolock) on pod.TaskKey = t.TaskKey
	LEFT OUTER JOIN tProject p (nolock) ON pod.ProjectKey = p.ProjectKey
	LEFT OUTER JOIN tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
	LEFT OUTER JOIN tPurchaseOrderUser pu (nolock) on po.PurchaseOrderKey = pu.PurchaseOrderKey
	LEFT OUTER JOIN tUser u (nolock) on pu.UserKey = u.UserKey
	LEFT OUTER JOIN tSalesTax st1 (NOLOCK) ON po.SalesTaxKey = st1.SalesTaxKey
	LEFT OUTER JOIN tSalesTax st2 (NOLOCK) ON po.SalesTax2Key = st2.SalesTaxKey
	LEFT OUTER JOIN tAddress a_c1 (nolock) ON c1.DefaultAddressKey = a_c1.AddressKey
	LEFT OUTER JOIN tAddress a_po (nolock) ON po.CompanyAddressKey = a_po.AddressKey
	Left Outer Join tStandardText stext (nolock) on po.HeaderTextKey = stext.StandardTextKey
	Left Outer Join tStandardText stext2 (nolock) on po.FooterTextKey = stext2.StandardTextKey
	LEFT OUTER JOIN tProject p2 (nolock) ON po.ProjectKey = p2.ProjectKey
	LEFT OUTER JOIN tMediaEstimate me (nolock) ON po.MediaEstimateKey = me.MediaEstimateKey
	Left Outer Join tGLCompany gl (nolock) on po.GLCompanyKey = gl.GLCompanyKey
	LEFT OUTER JOIN tAddress a_gl (nolock) ON gl.AddressKey = a_gl.AddressKey
	LEFT OUTER JOIN tMediaMarket mm (nolock) ON po.MediaMarketKey = mm.MediaMarketKey
	LEFT OUTER JOIN tMediaSpace ms (nolock) on po.MediaPrintSpaceKey = ms.MediaSpaceKey
	LEFT OUTER JOIN tMediaPosition mp (nolock) ON po.MediaPrintPositionKey = mp.MediaPositionKey
	LEFT OUTER JOIN tMediaWorksheet mws (nolock) ON po.MediaWorksheetKey = mws.MediaWorksheetKey
	LEFT OUTER JOIN tCompany cl (nolock) ON mws.ClientKey = cl.CompanyKey
	LEFT OUTER JOIN tClientProduct cp (nolock) ON ISNULL(mws.ClientProductKey, p.ClientProductKey) = cp.ClientProductKey
	LEFT OUTER JOIN tCampaign cmp (nolock) ON p.CampaignKey = cmp.CampaignKey
	LEFT OUTER JOIN tMediaPremium mpm (nolock) ON pod.MediaPremiumKey = mpm.MediaPremiumKey
	LEFT OUTER JOIN tMediaOrder mo (nolock) on po.MediaOrderKey = mo.MediaOrderKey
GO
