USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_PA951]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PA951]

AS

SELECT PJPROJ.pm_id01
, xIGFunctionCode.descr
, Customer.Name
, PJPROJ.gl_subacct
, PJINVDET.hold_status
, PJINVDET.acct
, PJINVDET.bill_status
, PJACCT.acct_group_cd
, PJINVDET.pjt_entity
, PJINVDET.amount
, PJINVDET.fiscalno
, PJPROJ.project
, PJPROJ.project_desc
FROM PJINVDET LEFT JOIN PJPROJ ON PJINVDET.project = PJPROJ.project 
	LEFT JOIN PJACCT ON PJINVDET.acct = PJACCT.acct 
	LEFT JOIN xIGFunctionCode ON PJINVDET.pjt_entity = xIGFunctionCode.code_ID 
	LEFT JOIN Customer ON PJPROJ.pm_id01 = Customer.CustId
WHERE PJINVDET.hold_status <> 'PG' 
	AND NOT (PJINVDET.acct LIKE 'OFFSET%' OR PJINVDET.acct LIKE 'PROJECT FEES%' )
	AND PJINVDET.bill_status <> 'B' 
	AND NOT (PJACCT.acct_group_cd = 'CM' OR PJACCT.acct_group_cd = 'FE')
GO
