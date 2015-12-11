USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vPurchaseOrder]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE         VIEW [dbo].[vPurchaseOrder]
/*
|| When     Who Rel     What
|| 10/22/08 GHL 10.5    (37963) Added company address on the po header
||					     I had a chat with Mike and we decided to do it this way.
||                       I will put an address on the header of the PO. 
||                       If this is not null, we will get the address from it 
||                       If the GL company is not null, get the Printed Name from it in lieu of the company name 
||                       If the GL company is not null, get the phone # from it in lieu of the company phone
*/

AS
SELECT po.*, 
	c.CompanyName AS VendorName, 
	c.VendorID,

	case when isnull(po.GLCompanyKey, 0) > 0 then gl.PrintedName else c1.CompanyName end as CompanyName, 

	case when isnull(po.CompanyAddressKey, 0) > 0 then a_po.Address1 else a_dc1.Address1 end AS CAddress1, 
	case when isnull(po.CompanyAddressKey, 0) > 0 then a_po.Address2 else a_dc1.Address2 end AS CAddress2, 
	case when isnull(po.CompanyAddressKey, 0) > 0 then a_po.Address3 else a_dc1.Address3 end AS CAddress3, 
	case when isnull(po.CompanyAddressKey, 0) > 0 then a_po.City else a_dc1.City end AS CCity,
	case when isnull(po.CompanyAddressKey, 0) > 0 then a_po.State else a_dc1.State end AS CState, 
	case when isnull(po.CompanyAddressKey, 0) > 0 then a_po.PostalCode else a_dc1.PostalCode end AS CPostalCode, 
	case when isnull(po.CompanyAddressKey, 0) > 0 then a_po.Country else a_dc1.Country end AS CCountry,
  
	pot.PurchaseOrderTypeName,
	stext.StandardText as HeaderText,
	stext2.StandardText as FooterText
FROM tCompany c 
	INNER JOIN tPurchaseOrder po (nolock) ON c.CompanyKey = po.VendorKey 
	INNER JOIN tCompany c1 (nolock) ON po.CompanyKey = c1.CompanyKey 
	LEFT OUTER JOIN tPurchaseOrderType pot (nolock) ON po.PurchaseOrderTypeKey = pot.PurchaseOrderTypeKey
	LEFT OUTER JOIN tAddress a_dc1 (nolock) ON c1.DefaultAddressKey = a_dc1.AddressKey 
	LEFT OUTER JOIN tAddress a_po (nolock) ON po.CompanyAddressKey = a_po.AddressKey 
	Left Outer Join tStandardText stext (nolock) on po.HeaderTextKey = stext.StandardTextKey
	Left Outer Join tStandardText stext2 (nolock) on po.FooterTextKey = stext2.StandardTextKey	
	Left Outer Join tGLCompany gl (nolock) on po.GLCompanyKey = gl.GLCompanyKey
GO
