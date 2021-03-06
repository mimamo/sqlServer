USE [MID_DEV_APP]
GO
/****** Object:  View [dbo].[xcog_xvrRevElist_OOSProjectList]    Script Date: 12/21/2015 14:17:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[xcog_xvrRevElist_OOSProjectList]
AS

Select distinct j.project, j.project_desc, j.pm_id02, j.status_pa
From PJPROJ j JOIN xIGProdReporting r ON j.pm_id02 = r.ProdID
	JOIN PJPENT t ON j.project = t.project
	JOIN xIGFunctionCode f ON f.code_ID = t.pjt_entity
Where r.OOS = '1'	
	and j.contract_type not in ('APS', 'FIN', 'IPM', 'ITD', 'NBIZ', 'PARN', 'SEA', 'SP2', 'TIME')
	AND f.code_group in ('FEE', 'MDIA')
GO
