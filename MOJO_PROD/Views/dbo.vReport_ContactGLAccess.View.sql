USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_ContactGLAccess]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_ContactGLAccess]
AS

/*
  || When        Who Rel      What
  || 09/18/2012  WDF 10.5.6.0 New View to check GL Company access restrictions for Contacts
*/

Select 
    vr.*
   ,glc.GLCompanyID as [Access Company ID]
   ,glc.GLCompanyName as [Access Company Name]
   ,glc.GLCompanyID + ' ' + glc.GLCompanyName as [Access Full Company Name]
 From vListing_Contact vr
 LEFT OUTER JOIN tGLCompanyAccess glca (NOLOCK) ON (vr.UserKey = glca.EntityKey AND glca.Entity = 'tUser')
 LEFT OUTER JOIN tGLCompany        glc (NOLOCK) ON (glca.GLCompanyKey = glc.GLCompanyKey)
GO
