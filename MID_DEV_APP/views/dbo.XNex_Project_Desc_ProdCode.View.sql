USE [MID_DEV_APP]
GO
/****** Object:  View [dbo].[XNex_Project_Desc_ProdCode]    Script Date: 12/21/2015 14:17:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[XNex_Project_Desc_ProdCode] as
Select P.project as Job
	,p.project_desc as JobDescription
	,P.pm_id02 as ProdCode
	,A.RefNbr
	,A.DocType
	,C.ClassId
	,P.purchase_order_num as ClientRef#
from PJPROJ p join ARDoc A on P.project = A.ProjectID
join Customer C on C.CustId = A.CustId
where a.DocType in('in','cm','dm')
GO
