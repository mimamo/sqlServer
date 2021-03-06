USE [MID_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_BU96C_Actuals]    Script Date: 12/21/2015 14:17:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_BU96C_Actuals]

AS
SELECT act.acct
, act.pjt_entity AS [Function]
, SUM(act.amount_01) AS Amount01
, SUM(act.amount_02) AS Amount02
, SUM(act.amount_03) AS Amount03
, SUM(act.amount_04) AS Amount04
, SUM(act.amount_05) AS Amount05
, SUM(act.amount_06) AS Amount06
, SUM(act.amount_07) AS Amount07
, SUM(act.amount_08) AS Amount08
, SUM(act.amount_09) AS Amount09
, SUM(act.amount_10) AS Amount10
, SUM(act.amount_11) AS Amount11
, SUM(act.amount_12) AS Amount12
, SUM(act.amount_13) AS Amount13
, SUM(act.amount_14) AS Amount14
, SUM(act.amount_15) AS Amount15
, SUM(act.amount_bf) AS AmountBF
, act.fsyear_num AS FSYearNum
, act.project
, ISNULL(a.acct_group_cd, '') AS AcctGroupCode
, ISNULL(c.control_code, '') AS ControlCode
FROM PJACTSUM act LEFT OUTER JOIN PJACCT a 
	ON act.acct = a.acct LEFT OUTER JOIN PJCONTRL c 
	ON act.acct = c.control_data
WHERE ((a.acct_group_cd IN ('WA', 'WP', 'CM', 'PB', 'FE')) 
	OR (c.control_code = 'BTD'))
GROUP BY act.acct, act.pjt_entity, act.amount_01, act.amount_02, act.amount_03, act.amount_04, act.amount_05, act.amount_06,
act.amount_07, act.amount_08, act.amount_09, act.amount_10, act.amount_11, act.amount_12, act.amount_13, act.amount_14, 
act.amount_15, act.amount_bf, act.fsyear_num, act.project, a.acct_group_cd, c.control_code
GO
