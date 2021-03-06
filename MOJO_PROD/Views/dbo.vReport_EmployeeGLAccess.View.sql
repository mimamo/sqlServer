USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_EmployeeGLAccess]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_EmployeeGLAccess]
AS  

/*
  || When        Who Rel      What
  || 09/18/2012  WDF 10.5.6.0 New View to check Employee GL Company Access

*/

Select 
    ve.*
   ,glc.GLCompanyID as [Access Company ID]
   ,glc.GLCompanyName as [Access Company Name]
   ,glc.GLCompanyID + ' ' + glc.GLCompanyName as [Access Full Company Name]
 From vListing_Employee ve
 LEFT OUTER JOIN tUserGLCompanyAccess glca (NOLOCK) ON (ve.UserKey = glca.UserKey)
 LEFT OUTER JOIN tGLCompany        glc (NOLOCK) ON (glca.GLCompanyKey = glc.GLCompanyKey)
GO
