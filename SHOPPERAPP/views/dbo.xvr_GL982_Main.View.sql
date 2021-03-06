USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[xvr_GL982_Main]    Script Date: 12/21/2015 16:12:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  VIEW [dbo].[xvr_GL982_Main]

AS

SELECT p.CustId
, p.[Name]
, p.pm_id02
, p.Product
, p.project
, p.project_desc
, p.pjt_entity
, p.pjt_entity_desc
, p.acct
, p.amount
, p.fiscalno
, p.contract_type
, p.pm_id25
, p.status_pa
, p.manager1
, p.manager2

, 0  as 'bamount'
, '' as 'bproject'
, '' as 'bfunction'
, '' as 'brevid'

FROM xvr_GL982_PJTRAN p
	
UNION ALL

SELECT c.CustId
, c.[Name]
, p.pm_id02
, xp.descr as 'Product'
, p.project
, p.project_desc
, pent.pjt_entity
, pent.pjt_entity_desc
, '' as 'acct'
, 0 as 'amount'
, b.Post_Period as 'fiscalno'
, p.contract_type
, b.RevID as 'pm_id25'
, p.status_pa
, p.manager1
, p.manager2

, ISNULL(b.CLEamount, 0) as 'bamount'
, ISNULL(b.project, '') as 'bproject'
, ISNULL(b.pjt_entity, '') as 'bfunction'
, ISNULL(b.revid, '') as 'brevid'

FROM PJPROJ p JOIN PJPENT pent ON p.project = pent.project
	JOIN xvr_Est_CLE_Period b ON pent.project = b.project AND pent.pjt_entity = b.pjt_entity
	JOIN customer c on p.pm_id01 = c.custID
	LEFT JOIN xIGProdCode xp ON p.pm_id02 = xp.code_ID
WHERE p.contract_type = 'SEA'
GO
