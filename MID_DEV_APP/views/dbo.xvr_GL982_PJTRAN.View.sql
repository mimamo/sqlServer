USE [MID_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_GL982_PJTRAN]    Script Date: 12/21/2015 14:17:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_GL982_PJTRAN]

AS

--Activity
SELECT PJTRAN.acct
, PJTRAN.amount
, Customer.CustId
, PJPROJ.project
, Customer.[Name]
, PJPROJ.pm_id02
, p.descr as 'Product'
, PJTRAN.fiscalno
, PJPROJ.contract_type
, PJPENT.pjt_entity
, PJPENT.pjt_entity_desc
, PJPROJ.project_desc
, PJPROJEX.pm_id25
, PJACCT.acct_group_cd
, PJPROJ.status_pa
, PJPROJ.manager1
, PJPROJ.manager2
FROM PJPROJ JOIN PJPENT ON PJPROJ.project = PJPENT.project
	LEFT JOIN PJTRAN ON PJPENT.pjt_entity = PJTRAN.pjt_entity 
		AND PJPENT.project = PJTRAN.project
	LEFT JOIN Customer ON PJPROJ.pm_id01 = Customer.CustId 
	LEFT JOIN PJPROJEX ON PJPROJ.project = PJPROJEX.project 
	LEFT JOIN PJACCT ON PJTRAN.acct = PJACCT.acct
	LEFT JOIN xIGProdCode p ON PJPROJ.pm_id02 = p.code_ID
WHERE PJACCT.acct_group_cd IN ('WA','WP','CM','FE')
	AND PJPROJ.contract_type = 'SEA'

UNION ALL 

--Budgets but no activity
SELECT isnull(PJTRAN.acct, '') as 'acct'
, isnull(PJTRAN.amount, 0) as 'amount'
, Customer.CustId
, PJPROJ.project
, Customer.[Name]
, PJPROJ.pm_id02
, p.descr as 'Product'
, isnull(PJTRAN.fiscalno, '') as 'fiscalno'
, PJPROJ.contract_type
, PJPENT.pjt_entity
, PJPENT.pjt_entity_desc
, PJPROJ.project_desc
, PJPROJEX.pm_id25
, isnull(PJACCT.acct_group_cd, '') as 'acct_group_cd'
, PJPROJ.status_pa
, PJPROJ.manager1
, PJPROJ.manager2
FROM PJPROJ JOIN PJPENT ON PJPROJ.project = PJPENT.project
	LEFT JOIN PJTRAN ON PJPENT.pjt_entity = PJTRAN.pjt_entity 
		AND PJPENT.project = PJTRAN.project
	LEFT JOIN Customer ON PJPROJ.pm_id01 = Customer.CustId 
	LEFT JOIN PJPROJEX ON PJPROJ.project = PJPROJEX.project 
	LEFT JOIN PJACCT ON PJTRAN.acct = PJACCT.acct
	LEFT JOIN xIGProdCode p ON PJPROJ.pm_id02 = p.code_ID
WHERE PJPROJ.contract_type = 'SEA'
	AND PJTRAN.amount is null
	AND PJPROJEX.pm_id25 <> ''
GO
