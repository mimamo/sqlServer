USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_BU010_Actuals]    Script Date: 12/21/2015 13:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_BU010_Actuals]
AS
SELECT     act.acct, act.amount_01 AS Amount01, act.amount_02 AS Amount02, act.amount_03 AS Amount03, act.amount_04 AS Amount04, 
                      act.amount_05 AS Amount05, act.amount_06 AS Amount06, act.amount_07 AS Amount07, act.amount_08 AS Amount08, act.amount_09 AS Amount09, 
                      act.amount_10 AS Amount10, act.amount_11 AS Amount11, act.amount_12 AS Amount12, act.amount_13 AS Amount13, act.amount_14 AS Amount14, 
                      act.amount_15 AS Amount15, act.amount_bf AS AmountBF, act.fsyear_num AS FSYearNum, act.project, ISNULL(a.acct_group_cd, '') AS AcctGroupCode, 
                      ISNULL(c.control_code, '') AS ControlCode
FROM         dbo.PJACTROL AS act LEFT OUTER JOIN
                      dbo.PJACCT AS a ON act.acct = a.acct LEFT OUTER JOIN
                      dbo.PJCONTRL AS c ON act.acct = c.control_data
WHERE     (a.acct_group_cd IN ('WA', 'WP', 'CM', 'PB', 'FE')) OR
                      (c.control_code = 'BTD')
GO
