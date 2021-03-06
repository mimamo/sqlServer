USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_BU008]    Script Date: 12/21/2015 13:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_BU008]

AS

SELECT 
c.ClassID as 'CustClass'
, p.pm_id01 as 'CustID'
, c.[name] as 'CustName'
, p.pm_id02 as 'ProdID'
, x.descr as 'ProdDesc'
, p.project
, p.project_desc
, p.status_pa as 'JobStatus'
, p.manager1 as 'PMID'
, p.manager2 as 'AcctServiceID'
, p.purchase_order_num as 'ClientRefNum'
, p.pm_id32 as 'OfferNum'
, p.Contract_type as 'Category'
, ISNULL(cle2.revID, '') as 'CLERevID'
, ISNULL(cle2.CLEAmount, 0) as 'CLEAmount'
--, ISNULL(cle2.CLEStatus, '') as 'CLEStatus' CLE Status is always P.
, ISNULL(ule2.revID, '') as 'ULERevID'
, ISNULL(ule2.ULEAmount, 0) as 'ULEAmount'
, ISNULL(ule2.Status, '') as 'ULEStatus'
FROM PJPROJ p LEFT JOIN Customer c ON p.pm_id01 = c.CustID
	LEFT JOIN xIGProdCode x ON p.pm_id02 = x.code_ID
	JOIN PJPROJEX ex ON p.project = ex.project
	LEFT JOIN (SELECT CLE.Project, CLE.RevId, Sum(CLE.CLEAmount) as 'CLEAmount' FROM xvr_Est_CLE CLE GROUP BY CLE.Project, CLE.RevId) CLE2 ON p.Project = CLE2.Project
	Left Join (SELECT ULE.Project, ULE.RevID, ULE.Status, Sum(ULE.ULEAmount) as 'ULEAmount' FROM xvr_Est_ULE ULE GROUP BY ULE.Project, ULE.RevId, ULE.Status) ULE2 ON p.Project = ULE2.Project
GO
