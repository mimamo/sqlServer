USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_EmployeeService]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_EmployeeService]
AS

/*
  || When        Who Rel      What
  || 09/18/2012  WDF 10.5.6.0 New View to check Services Employee has Access to
*/


 select
     ve.*
    ,s.ServiceCode as [Employee Service Code]
    ,s.Description     as [Employee Service Description]
    ,s.ServiceCode + ' ' + s.Description as [Employee Full Service Description]
  from vListing_Employee ve
 LEFT OUTER JOIN tUserService us (NOLOCK) on (ve.UserKey = us.UserKey)
 LEFT OUTER JOIN tService      s (NOLOCK) on (us.ServiceKey = s.ServiceKey)
GO
