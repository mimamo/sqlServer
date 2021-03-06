USE [DENVERAPP]
GO
/****** Object:  View [dbo].[xvr_BU973]    Script Date: 12/21/2015 15:42:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_BU973]

AS

SELECT c.ClassID
, c.CustId
, c.[name] as CustName
, x.code_id as ProdID
, p.status_pa as Status
, p.project_desc as ProjectDesc
, BU973_Join.Datasource
, BU973_Join.ProjectID
, BU973_Join.[Year]
, BU973_Join.Amount_01
, BU973_Join.Amount_02
, BU973_Join.Amount_03
, BU973_Join.Amount_04
, BU973_Join.Amount_05
, BU973_Join.Amount_06
, BU973_Join.Amount_07
, BU973_Join.Amount_08
, BU973_Join.Amount_09
, BU973_Join.Amount_10
, BU973_Join.Amount_11
, BU973_Join.Amount_12
, BU973_Join.Amount_YTD
FROM (SELECT 'TRAPS' as 'Datasource'
, p_number as 'ProjectID'
, TrapsYear as 'Year'
, Sum(Amount_01) as 'Amount_01'
, Sum(Amount_02) as 'Amount_02'
, Sum(Amount_03) as 'Amount_03'
, Sum(Amount_04) as 'Amount_04'
, Sum(Amount_05) as 'Amount_05'
, Sum(Amount_06) as 'Amount_06'
, Sum(Amount_07) as 'Amount_07'
, Sum(Amount_08) as 'Amount_08'
, Sum(Amount_09) as 'Amount_09'
, Sum(Amount_10) as 'Amount_10'
, Sum(Amount_11) as 'Amount_11'
, Sum(Amount_12) as 'Amount_12'
, Sum(Amount_YTD) as 'Amount_YTD'
FROM (SELECT Traps.p_number
	, SUBSTRING(Traps.Trapsfiscal, 1, 4) as 'TrapsYear'
	, CASE WHEN SUBSTRING(Traps.Trapsfiscal, 5, 2) = '01' THEN Sum(Traps.TrapsBTD) ELSE '0' end as 'Amount_01'
	, CASE WHEN SUBSTRING(Traps.Trapsfiscal, 5, 2) = '02' THEN Sum(Traps.TrapsBTD) ELSE '0' end as 'Amount_02'
	, CASE WHEN SUBSTRING(Traps.Trapsfiscal, 5, 2) = '03' THEN Sum(Traps.TrapsBTD) ELSE '0' end as 'Amount_03'
	, CASE WHEN SUBSTRING(Traps.Trapsfiscal, 5, 2) = '04' THEN Sum(Traps.TrapsBTD) ELSE '0' end as 'Amount_04'
	, CASE WHEN SUBSTRING(Traps.Trapsfiscal, 5, 2) = '05' THEN Sum(Traps.TrapsBTD) ELSE '0' end as 'Amount_05'
	, CASE WHEN SUBSTRING(Traps.Trapsfiscal, 5, 2) = '06' THEN Sum(Traps.TrapsBTD) ELSE '0' end as 'Amount_06'
	, CASE WHEN SUBSTRING(Traps.Trapsfiscal, 5, 2) = '07' THEN Sum(Traps.TrapsBTD) ELSE '0' end as 'Amount_07'
	, CASE WHEN SUBSTRING(Traps.Trapsfiscal, 5, 2) = '08' THEN Sum(Traps.TrapsBTD) ELSE '0' end as 'Amount_08'
	, CASE WHEN SUBSTRING(Traps.Trapsfiscal, 5, 2) = '09' THEN Sum(Traps.TrapsBTD) ELSE '0' end as 'Amount_09'
	, CASE WHEN SUBSTRING(Traps.Trapsfiscal, 5, 2) = '10' THEN Sum(Traps.TrapsBTD) ELSE '0' end as 'Amount_10'
	, CASE WHEN SUBSTRING(Traps.Trapsfiscal, 5, 2) = '11' THEN Sum(Traps.TrapsBTD) ELSE '0' end as 'Amount_11'
	, CASE WHEN SUBSTRING(Traps.Trapsfiscal, 5, 2) = '12' THEN Sum(Traps.TrapsBTD) ELSE '0' end as 'Amount_12'
	, Sum(Traps.TrapsBTD) as 'Amount_YTD'
	FROM (SELECT Projects.p_number
		, CAST(YEAR(DATEADD(DAY, Effective_date/(60*60*24), '1/1/1970')) as VARCHAR) +  RIGHT('00' + CAST(MONTH(DATEADD(DAY, Effective_date/(60*60*24), '1/1/1970')) as VARCHAR), 2) as 'TrapsFiscal'
		, SUM(Billing.Amount) as 'TrapsBTD'
		FROM (SELECT * FROM OPENQUERY([xRHSQL.bridge], 'Select * FROM estudio.phpgw_p_billing ')) Billing JOIN 
			 (SELECT * FROM OPENQUERY ([xRHSQL.bridge], 'Select * From estudio.phpgw_p_projects')) Projects ON billing.project_id = Projects.Project_id
		GROUP BY Projects.p_number, CAST(YEAR(DATEADD(DAY, Effective_date/(60*60*24), '1/1/1970')) as VARCHAR) +  RIGHT('00' + CAST(MONTH(DATEADD(DAY, Effective_date/(60*60*24), '1/1/1970')) as VARCHAR), 2)) Traps
		GROUP BY p_number, Trapsfiscal
	) TrapsROL
GROUP BY p_number, TrapsYear

UNION ALL

SELECT 'DSL' as DataSource
, Project
, fsyear_num
, amount_01
, amount_02
, amount_03
, amount_04
, amount_05
, amount_06
, amount_07
, amount_08
, amount_09
, amount_10
, amount_11
, amount_12
, amount_01 + amount_02 + amount_03 + amount_04 + amount_05 + amount_06 + amount_07 + amount_08 + amount_09 + amount_10 + amount_11 + amount_12 as Amount_BTD
FROM PJACTROL
WHERE acct = 'APS BTD') BU973_Join JOIN PJPROJ p ON BU973_Join.ProjectID = p.Project
	JOIN Customer c ON p.pm_id01 = c.custid
	JOIN xIGProdCode x ON p.pm_id02 = x.code_id
GO
