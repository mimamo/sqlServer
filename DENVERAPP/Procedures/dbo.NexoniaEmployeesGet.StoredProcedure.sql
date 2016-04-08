USE [DENVERAPP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'NexoniaEmployeesGet'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[NexoniaEmployeesGet]
GO

CREATE PROCEDURE [dbo].[NexoniaEmployeesGet] 

	
AS 

/*******************************************************************************************************
*   DENVERAPP.dbo.NexoniaEmployeesGet
*
*   Creator: Michelle Morales/David Martin  
*   Date: 03/10/2016          
*   
*          
*   Notes:  
*
*   Usage:	set statistics io on

	execute DENVERAPP.dbo.NexoniaEmployeesGet


*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------

---------------------------------------------
-- create temp tables
---------------------------------------------
---- Employee report for Nexonia
-- Employees.csv
-- Insert first row
select 'APRECEIPT' as EmployeeID
,'Approval' as lName
,'Finance' as fName
,'apreceiptmatching@integer.com' as EmployeeEmail
,'' as VendorID
,'' as Manager
,'DENVER' as Company
,'1000' as SubAccount
UNION ALL
select 'APEXPORT' as EmployeeID
,'Approval' as lName
,'Export' as fName
,'apreceiptmatching@integer.com' as EmployeeEmail
,'' as VendorID
,'' as Manager
,'DENVER' as Company
,'1000' as SubAccount

UNION

-- Rest of the employees
select ltrim(rtrim(p.employee)) as EmployeeID
,  dbo.fnSplitStrgTilda(ltrim(rtrim(p.emp_name)), 0) as lName  --doesn't work.....look into error  might have something to do with -
,  dbo.fnSplitStrgTilda(ltrim(rtrim(p.emp_name)), 1) as fName
--, ltrim(rtrim(p.emp_name)) as EmployeeName
, ltrim(rtrim(p.em_id03)) as EmployeeEmail
, ltrim(rtrim(p.em_id01)) as VendorID
, CASE WHEN p.employee = 'MSWEENEY' THEN '' ELSE LTRIM(rtrim(p.manager1)) END as Manager
--, LTRIM(rtrim((select em_id01 from PJEMPLOY where employee = p.manager1))) as ManagerVendID
--, LTRIM(rtrim((select em_id03 from PJEMPLOY where employee = p.manager1))) as ManagerEmail
, ltrim(rtrim(p.cpnyid)) as Company
, ltrim(rtrim(p.gl_subacct)) as SubAccount
from DENVERAPP.dbo.PJEMPLOY p
where emp_status = 'A'
and emp_type_cd <> 'PROD'
and p.em_id01 <> ''
and (p.em_id01 <> '' 
	OR p.employee IN (select distinct ltrim(rtrim(p.manager1)) as ProjectMgrID
			from DENVERAPP.dbo.PJPROJ p
			where status_pa = 'A'
			AND contract_type NOT IN ('TIME','FIN','APS','MED'))
	OR p.employee IN (select distinct ltrim(rtrim(manager1)) as Sup from DENVERAPP.dbo.PJEMPLOY)		
)			
and p.employee NOT IN ('HRSALLOC')

UNION

select ltrim(rtrim(p.employee)) as EmployeeID
,  dbo.fnSplitStrgTilda(ltrim(rtrim(p.emp_name)), 0) as lName  --doesn't work.....look into error  might have something to do with -
,  dbo.fnSplitStrgTilda(ltrim(rtrim(p.emp_name)), 1) as fName
--, ltrim(rtrim(p.emp_name)) as EmployeeName
, ltrim(rtrim(p.em_id03)) as EmployeeEmail
, ltrim(rtrim(p.em_id01)) as VendorID
, CASE WHEN p.employee = 'MSWEENEY' THEN '' ELSE LTRIM(rtrim(p.manager1)) END as Manager
--, LTRIM(rtrim((select em_id01 from PJEMPLOY where employee = p.manager1))) as ManagerVendID
--, LTRIM(rtrim((select em_id03 from PJEMPLOY where employee = p.manager1))) as ManagerEmail
, ltrim(rtrim(p.cpnyid)) as Company
, ltrim(rtrim(p.gl_subacct)) as SubAccount
from SHOPPERAPP.dbo.pjemploy p
where emp_status = 'A'
and emp_type_cd <> 'PROD'
and p.em_id01 <> ''
and (p.em_id01 <> '' 
	OR p.employee IN (select distinct ltrim(rtrim(p.manager1)) as ProjectMgrID
			from SHOPPERAPP.dbo.PJPROJ p
			where status_pa = 'A'
			AND contract_type NOT IN ('TIME','FIN','APS','MED'))
	OR p.employee IN (select distinct ltrim(rtrim(manager1)) as Sup from SHOPPERAPP.dbo.pjemploy))	

UNION

-- ADD DALLAS EMPLOYEES

SELECT	LTRIM(RTRIM(P.employee)) AS 'EmployeeID',
		CASE CHARINDEX(' ' ,LTRIM(RTRIM(P.emp_name)),1) -- Get last name by simply looking after first blank space
			WHEN 0 THEN LTRIM(RTRIM(P.emp_name))
			ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(P.emp_name)),CHARINDEX(' ' ,LTRIM(RTRIM(P.emp_name)),1)+1,100)))		
		END AS 'lName',
		CASE CHARINDEX(' ' ,LTRIM(RTRIM(P.emp_name)),1) -- Get first name by simply looking for first blank space
			WHEN 0 THEN LTRIM(RTRIM(P.emp_name))
			ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(P.emp_name)),1,CHARINDEX(' ' ,LTRIM(RTRIM(P.emp_name)),1)-1)))
		END AS 'fName',
		LTRIM(RTRIM(P.em_id03)) AS 'EmployeeEmail',
		LTRIM(RTRIM(P.em_id01)) AS 'VendorID',
		LTRIM(RTRIM(P.manager1)) AS 'Manager', -- Superviosr field in DSL screen
		'DALLAS' AS 'Company', -- Hardcode Dallas company
		'0000' AS 'SubAccount'  -- Hardcode to agency subaccount to prevent entries into incorrect subaccount/subaccounts not used in Dallas
FROM	DALLASAPP.DBO.PJEMPLOY P
WHERE	P.emp_status = 'A' -- Only currently active employees
		AND P.emp_type_cd <> 'PROD' --Exclude the client "employees" the system adds
		AND LTRIM(RTRIM(P.em_id01)) <> '' -- Only employees with vendor ID set	

UNION ALL

-- ADD DALLAS STUDIO EMPLOYEES

SELECT	LTRIM(RTRIM(P.employee)) AS 'EmployeeID',
		CASE CHARINDEX(' ' ,LTRIM(RTRIM(P.emp_name)),1) -- Get last name by simply looking after first blank space
			WHEN 0 THEN LTRIM(RTRIM(P.emp_name))
			ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(P.emp_name)),CHARINDEX(' ' ,LTRIM(RTRIM(P.emp_name)),1)+1,100)))		
		END AS 'lName',
		CASE CHARINDEX(' ' ,LTRIM(RTRIM(P.emp_name)),1) -- Get first name by simply looking for first blank space
			WHEN 0 THEN LTRIM(RTRIM(P.emp_name))
			ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(P.emp_name)),1,CHARINDEX(' ' ,LTRIM(RTRIM(P.emp_name)),1)-1)))
		END AS 'fName',
		LTRIM(RTRIM(P.em_id03)) AS 'EmployeeEmail',
		LTRIM(RTRIM(P.em_id01)) AS 'VendorID',
		LTRIM(RTRIM(P.manager1)) AS 'Manager', -- Superviosr field in DSL screen
		'DALLAS' AS 'Company', -- Hardcode Dallas company
		'0000' AS 'SubAccount'  -- Hardcode to agency subaccount to prevent entries into incorrect subaccount/subaccounts not used in Dallas
FROM	DALLASSTUDIOAPP.DBO.PJEMPLOY P
WHERE	P.emp_status = 'A' -- Only currently active employees
		AND P.emp_type_cd <> 'PROD' --Exclude the client "employees" the system adds
		AND LTRIM(RTRIM(P.em_id01)) <> '' -- Only employees with vendor ID set	
                  
---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're using a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------


---------------------------------------------
-- permissions
---------------------------------------------
grant execute on NexoniaEmployeesGet to BFGROUP
go

grant execute on NexoniaEmployeesGet to MSDSL
go

grant control on NexoniaEmployeesGet to MSDSL
go

grant execute on NexoniaEmployeesGet to MSDynamicsSL
go