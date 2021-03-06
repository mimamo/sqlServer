USE [SHOPPER_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_BI903_Actuals]    Script Date: 12/21/2015 14:33:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_BI903_Actuals]

AS

SELECT a.RI_ID, a.Project, SUM(a.BTD) as 'BTD', SUM(a.Actuals) as 'Actuals', a.FSYearNum
FROM (
SELECT r.RI_ID
, act.project
, CASE WHEN (c.control_code = 'BTD' AND act.fsyear_num = LEFT(r.BegPerNbr, 4)) OR (a.acct_group_cd = 'PB' AND act.fsyear_num = LEFT(r.BegPerNbr, 4))  
		THEN CASE WHEN Right(r.BegPerNbr, 2) = '01'
					THEN act.Amount_BF + act.Amount_01
					WHEN Right(r.BegPerNbr, 2) = '02'
					THEN act.Amount_BF + act.Amount_01 + act.Amount_02
					WHEN Right(r.BegPerNbr, 2) = '03'
					THEN act.Amount_BF + act.Amount_01 + act.Amount_02 + act.Amount_03
					WHEN Right(r.BegPerNbr, 2) = '04'
					THEN act.Amount_BF + act.Amount_01 + act.Amount_02 + act.Amount_03 + act.Amount_04
					WHEN Right(r.BegPerNbr, 2) = '05'
					THEN act.Amount_BF + act.Amount_01 + act.Amount_02 + act.Amount_03 + act.Amount_04 + act.Amount_05
					WHEN Right(r.BegPerNbr, 2) = '06'
					THEN act.Amount_BF + act.Amount_01 + act.Amount_02 + act.Amount_03 + act.Amount_04 + act.Amount_05 + act.Amount_06
					WHEN Right(r.BegPerNbr, 2) = '07'
					THEN act.Amount_BF + act.Amount_01 + act.Amount_02 + act.Amount_03 + act.Amount_04 + act.Amount_05 + act.Amount_06 + act.Amount_07
					WHEN Right(r.BegPerNbr, 2) = '08'
					THEN act.Amount_BF + act.Amount_01 + act.Amount_02 + act.Amount_03 + act.Amount_04 + act.Amount_05 + act.Amount_06 + act.Amount_07 + act.Amount_08
					WHEN Right(r.BegPerNbr, 2) = '09'
					THEN act.Amount_BF + act.Amount_01 + act.Amount_02 + act.Amount_03 + act.Amount_04 + act.Amount_05 + act.Amount_06 + act.Amount_07 + act.Amount_08 + act.Amount_09
					WHEN Right(r.BegPerNbr, 2) = '10'
					THEN act.Amount_BF + act.Amount_01 + act.Amount_02 + act.Amount_03 + act.Amount_04 + act.Amount_05 + act.Amount_06 + act.Amount_07 + act.Amount_08 + act.Amount_09 + act.Amount_10
					WHEN Right(r.BegPerNbr, 2) = '11'
					THEN act.Amount_BF + act.Amount_01 + act.Amount_02 + act.Amount_03 + act.Amount_04 + act.Amount_05 + act.Amount_06 + act.Amount_07 + act.Amount_08 + act.Amount_09 + act.Amount_10 + act.Amount_11
					WHEN Right(r.BegPerNbr, 2) = '12'
					THEN act.Amount_BF + act.Amount_01 + act.Amount_02 + act.Amount_03 + act.Amount_04 + act.Amount_05 + act.Amount_06 + act.Amount_07 + act.Amount_08 + act.Amount_09 + act.Amount_10 + act.Amount_11 + act.Amount_12 end 	
					ELSE 0 end as 'BTD'
, CASE WHEN (a.acct_group_cd IN ('WA', 'WP', 'FE', 'CM')) AND act.fsyear_num = LEFT(r.BegPerNbr, 4)   
		THEN CASE WHEN Right(r.BegPerNbr, 2) = '01'
					THEN act.Amount_BF + act.Amount_01
					WHEN Right(r.BegPerNbr, 2) = '02'
					THEN act.Amount_BF + act.Amount_01 + act.Amount_02
					WHEN Right(r.BegPerNbr, 2) = '03'
					THEN act.Amount_BF + act.Amount_01 + act.Amount_02 + act.Amount_03
					WHEN Right(r.BegPerNbr, 2) = '04'
					THEN act.Amount_BF + act.Amount_01 + act.Amount_02 + act.Amount_03 + act.Amount_04
					WHEN Right(r.BegPerNbr, 2) = '05'
					THEN act.Amount_BF + act.Amount_01 + act.Amount_02 + act.Amount_03 + act.Amount_04 + act.Amount_05
					WHEN Right(r.BegPerNbr, 2) = '06'
					THEN act.Amount_BF + act.Amount_01 + act.Amount_02 + act.Amount_03 + act.Amount_04 + act.Amount_05 + act.Amount_06
					WHEN Right(r.BegPerNbr, 2) = '07'
					THEN act.Amount_BF + act.Amount_01 + act.Amount_02 + act.Amount_03 + act.Amount_04 + act.Amount_05 + act.Amount_06 + act.Amount_07
					WHEN Right(r.BegPerNbr, 2) = '08'
					THEN act.Amount_BF + act.Amount_01 + act.Amount_02 + act.Amount_03 + act.Amount_04 + act.Amount_05 + act.Amount_06 + act.Amount_07 + act.Amount_08
					WHEN Right(r.BegPerNbr, 2) = '09'
					THEN act.Amount_BF + act.Amount_01 + act.Amount_02 + act.Amount_03 + act.Amount_04 + act.Amount_05 + act.Amount_06 + act.Amount_07 + act.Amount_08 + act.Amount_09
					WHEN Right(r.BegPerNbr, 2) = '10'
					THEN act.Amount_BF + act.Amount_01 + act.Amount_02 + act.Amount_03 + act.Amount_04 + act.Amount_05 + act.Amount_06 + act.Amount_07 + act.Amount_08 + act.Amount_09 + act.Amount_10
					WHEN Right(r.BegPerNbr, 2) = '11'
					THEN act.Amount_BF + act.Amount_01 + act.Amount_02 + act.Amount_03 + act.Amount_04 + act.Amount_05 + act.Amount_06 + act.Amount_07 + act.Amount_08 + act.Amount_09 + act.Amount_10 + act.Amount_11
					WHEN Right(r.BegPerNbr, 2) = '12'
					THEN act.Amount_BF + act.Amount_01 + act.Amount_02 + act.Amount_03 + act.Amount_04 + act.Amount_05 + act.Amount_06 + act.Amount_07 + act.Amount_08 + act.Amount_09 + act.Amount_10 + act.Amount_11 + act.Amount_12 end 	
					ELSE 0 end as 'Actuals'
, act.fsyear_num as 'FSYearNum'
FROM PJACTROL act LEFT JOIN PJACCT a ON act.acct = a.acct 
	LEFT JOIN PJCONTRL c ON act.acct = c.control_data
	CROSS JOIN RptRuntime r
WHERE (a.acct_group_cd IN ('WA', 'WP', 'PB', 'FE', 'CM')) 
	OR (c.control_code = 'BTD')) a
GROUP BY a.RI_ID, a.project, a.FSYearNum
GO
