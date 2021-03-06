USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_PAPRJ_Actuals]    Script Date: 12/21/2015 13:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PAPRJ_Actuals]

AS

SELECT a.Project
, a.fsyear_num
, sum(a.Actuals) as 'Actuals'
, sum(a.BTD) as 'BTD'
, round(sum(a.Actuals),2) - round(sum(a.BTD),2) as 'ActualsToBill'
FROM(
SELECT act.project
, act.fsyear_num
, CASE WHEN a.acct_group_cd IN ('WA', 'WP', 'CM', 'FE') --AND act.fsyear_num = year(GetDate())
		THEN CASE WHEN month(GetDate()) = '1' 
					THEN act.amount_bf + act.amount_01 
					WHEN month(GetDate()) = '2' 
					THEN act.amount_bf + act.amount_01 + act.amount_02 
					WHEN month(GetDate()) = '3' 
					THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03  
					WHEN month(GetDate()) = '4' 
					THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 
					WHEN month(GetDate()) = '5' 
					THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05  
					WHEN month(GetDate()) = '6' 
					THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06  
					WHEN month(GetDate()) = '7' 
					THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07  
					WHEN month(GetDate()) = '8' 
					THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07 + act.amount_08
					WHEN month(GetDate()) = '9' 
					THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07 + act.amount_08 + act.amount_09  
					WHEN month(GetDate()) = '10' 
					THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07 + act.amount_08 + act.amount_09 + act.amount_10  
					WHEN month(GetDate()) = '11' 
					THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07 + act.amount_08 + act.amount_09 + act.amount_10 + act.amount_11  
					WHEN month(GetDate()) = '12' 
					THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07 + act.amount_08 + act.amount_09 + act.amount_10 + act.amount_11 + act.amount_12
					ELSE 0 end
			ELSE 0 end as 'Actuals'
, CASE WHEN c.control_code = 'BTD' OR a.acct_group_cd = 'PB' --AND act.fsyear_num = year(GetDate())
		THEN CASE WHEN month(GetDate()) = '1' 
					THEN act.amount_bf + act.amount_01 
					WHEN month(GetDate()) = '2' 
					THEN act.amount_bf + act.amount_01 + act.amount_02 
					WHEN month(GetDate()) = '3' 
					THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03  
					WHEN month(GetDate()) = '4' 
					THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 
					WHEN month(GetDate()) = '5' 
					THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05  
					WHEN month(GetDate()) = '6' 
					THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06  
					WHEN month(GetDate()) = '7' 
					THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07  
					WHEN month(GetDate()) = '8' 
					THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07 + act.amount_08
					WHEN month(GetDate()) = '9' 
					THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07 + act.amount_08 + act.amount_09  
					WHEN month(GetDate()) = '10' 
					THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07 + act.amount_08 + act.amount_09 + act.amount_10  
					WHEN month(GetDate()) = '11' 
					THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07 + act.amount_08 + act.amount_09 + act.amount_10 + act.amount_11  
					WHEN month(GetDate()) = '12' 
					THEN act.amount_bf + act.amount_01 + act.amount_02 + act.amount_03 + act.amount_04 + act.amount_05 + act.amount_06 + act.amount_07 + act.amount_08 + act.amount_09 + act.amount_10 + act.amount_11 + act.amount_12
					ELSE 0 end
			ELSE 0 end as 'BTD'
FROM PJACTROL act LEFT JOIN PJACCT a ON act.acct = a.acct 
	LEFT JOIN PJCONTRL c ON act.acct = c.control_data
WHERE a.acct_group_cd IN ('WA', 'WP', 'CM', 'PB', 'FE') 
	OR c.control_code = 'BTD') a
GROUP BY a.Project, a.fsyear_num
GO
