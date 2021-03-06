USE [DENVERAPP]
GO
/****** Object:  View [dbo].[xvr_PA933]    Script Date: 12/21/2015 15:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PA933] 
as
SELECT w.project as 'Job'
, w.pjt_entity as 'Function'
, w.trans_date
, p.pm_id01 as 'CustCode'
, p.pm_id02 as 'ProdCode'
, w.system_cd as 'Module'
, w.fiscalno
, w.bill_batch_id
, w.batch_id
, w.detail_num
, w.units
FROM PJTRANWK w JOIN PJPROJ p on w.project = p.project
	JOIN xIGProdCode xp on p.pm_id02 = xp.code_id
	JOIN Customer c on p.pm_id01 = c.custID
GO
