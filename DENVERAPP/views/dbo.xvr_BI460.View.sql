USE [DENVERAPP]
GO
/****** Object:  View [dbo].[xvr_BI460]    Script Date: 12/21/2015 15:42:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_BI460]

AS

Select a.APSProject
, a.APSStatus
, p.Project as 'BillJob'
, p.Status_pa as 'BillJobStatus'
, p.Alloc_Method_Cd as 'BillJobAolloc'
, p.Contract_Type as 'BillJobContract'
, p.pm_id01 as 'ClientID'
, p.pm_id02 as 'ProdID'
From
(
Select Project as 'APSProject'
, pm_id34 as 'BillProject'
, status_pa as 'APSStatus'
from PJPROJ
Where alloc_method_cd = 'APS'
) a Join PJPROJ p on a.BillProject = p.Project
GO
