USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_CompanyProduct]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_CompanyProduct]
AS  

/*
  || When        Who Rel      What
  || 09/18/2012  GWG 10.5.6.0 New View modeled after vListing_Company to check setup of products under a company
  || 02/19/15    GHL 10.5.8.9 Added DivisionID + ProductID for Abelson Taylr
*/

Select 
	vc.*
	, cp.ProductName as [Product Name]
	, cp.ProductID as [Product ID]
	, cd.DivisionName as [Division Name]
	, cd.DivisionID as [Division ID]
	, cd.ProjectNumPrefix as [Division Project Prefix]
From
	vReport_Company vc (nolock)
	left outer join tClientProduct cp (nolock) on vc.ClientKey = cp.ClientKey
	left outer join tClientDivision cd (nolock) on cp.ClientDivisionKey = cd.ClientDivisionKey
GO
