USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_CompanyDivision]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_CompanyDivision]
AS  

/*
  || When        Who Rel      What
  || 09/18/2012  GWG 10.5.6.0 New View modeled after vListing_Company to check setup of divisions under a company
  || 02/19/15    GHL 10.5.8.9 Added DivisionID for Abelson Taylr

*/

Select 
	vc.*
	, cd.DivisionName as [Division Name]
	, cd.DivisionID as [Division ID]
	, cd.ProjectNumPrefix as [Division Project Prefix]
From
	vReport_Company vc (nolock)
	left outer join tClientDivision cd (nolock) on vc.ClientKey = cd.ClientKey
GO
