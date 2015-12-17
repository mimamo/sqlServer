USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_CompanyGLAccess]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_CompanyGLAccess]
AS  

/*
  || When        Who Rel      What
  || 09/18/2012  GWG 10.5.6.0 New View modeled after vListing_Company to check GL Company access restrictions

*/

Select 
	  vc.*
	, gl.GLCompanyID as [Access Company ID]
	, gl.GLCompanyName as [Access Company Name]
	, gl.GLCompanyID + ' ' + gl.GLCompanyName as [Access Full Company Name]
From vReport_Company vc
left outer join tGLCompanyAccess gla (nolock) on vc.ClientKey = gla.EntityKey and gla.Entity = 'tCompany'
left outer join tGLCompany gl (nolock) on gla.GLCompanyKey = gl.GLCompanyKey
GO
