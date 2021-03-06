USE [MID_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_PA950_main]    Script Date: 12/21/2015 14:17:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PA950_main]

as
SELECT PJTRAN.acct
, PJTRAN.amount
, PJTRAN.pjt_entity
, PJTRAN.fiscalno
, PJPROJ.pm_id01
, xIGFunctionCode.descr
, Customer.[Name]
, PJTRAN.gl_subacct
, PJPROJ.contract_type
, PJTRAN.project
, PJTRAN.crtd_prog
, PJTRAN.batch_type
, PJTRAN.gl_acct
, PJTRAN.tr_id30
, SubAcct.Descr as 'Department'
 FROM PJTRAN LEFT OUTER JOIN SubAcct
	ON PJTRAN.gl_subacct = SubAcct.Sub JOIN PJPROJ
	ON PJTRAN.project = PJPROJ.project LEFT OUTER JOIN xIGFunctionCode 
	ON PJTRAN.pjt_entity = xIGFunctionCode.code_ID LEFT OUTER JOIN Customer 
	ON PJPROJ.pm_id01 = Customer.CustId 
 WHERE  (PJTRAN.pjt_entity <> '99999')
	AND (PJTRAN.acct in ('ART BUYING FEES', 'RETAINERS', 'APS BUYING FEES','BRDCST FEES', 'DIRECT MKTG FEE', 'INTERACTIVE FEE', 'INTERACTIVE FEES', 'MARKUP', 'MISC PRJCT FEE',
	'PRODUCTION BILL', 'PROJECT FEE', 'PROJECT FEES'))
	AND (PJTRAN.gl_acct <> '2100') 
	AND (PJTRAN.gl_acct NOT LIKE '12%') 
	AND (PJTRAN.crtd_prog = 'BIREG') 
	AND (PJTRAN.batch_type = 'BI')
	AND (PJTRAN.gl_acct > '0') 
	AND (PJTRAN.tr_id30 <> 0)
GO
