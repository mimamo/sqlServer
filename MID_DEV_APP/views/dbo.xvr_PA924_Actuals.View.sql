USE [MID_DEV_APP]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PA924_Actuals]
AS

/*******************************************************************************************************
*	MID_DEV_APP.dbo.xvr_PA924_Actuals.sql
*
*   Notes:  


	select *
	from MID_DEV_APP.dbo.xvr_PA924_Actuals
	where project in('00583814AGY', -- incorrect
					'00383813AGY')	-- correct
	order by project
	
	select project, units_bf, *
	from MID_DEV_APP.dbo.PJACTROL
	where project in('00583814AGY', '00427814AGY', '00572314AGY', -- incorrect
					'00383813AGY','00515814AGY', '00492114AGY', '00517714AGY')	-- correct	
		and year(crtd_datetime) = 2015
	order by project
*                  
*   Modifications:   
*   Name				Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*  
********************************************************************************************************/

SELECT act.acct, 
	Amount01 = act.amount_01, 
	Amount02 = act.amount_02, 
	Amount03 = act.amount_03, 
	Amount04 = act.amount_04, 
    Amount05 = act.amount_05, 
    Amount06 = act.amount_06, 
    Amount07 = act.amount_07, 
    Amount08 = act.amount_08, 
    Amount09 = act.amount_09, 
    Amount10 = act.amount_10, 
    Amount11 = act.amount_11, 
    Amount12 = act.amount_12, 
    Amount13 = act.amount_13, 
    Amount14 = act.amount_14,     
    Amount15 = act.amount_15, 
    AmountBF = act.amount_bf, 
    FSYearNum = act.fsyear_num, 
    act.project, 
    AcctGroupCode = ISNULL(a.acct_group_cd, ''),     
    ControlCode = ISNULL(c.control_code, '') 
FROM MID_DEV_APP.dbo.PJACTROL act 
LEFT OUTER JOIN MID_DEV_APP.dbo.PJACCT a 
	ON act.acct = a.acct 
LEFT OUTER JOIN MID_DEV_APP.dbo.PJCONTRL c 
	ON act.acct = c.control_data
WHERE a.acct_group_cd IN ('WA', 'WP', 'CM', 'PB', 'FE')
	or c.control_code = 'BTD'
	
	
GO
