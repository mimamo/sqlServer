USE [DENVERAPP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'NexoniaJobFunctionsGet'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[NexoniaJobFunctionsGet]
GO

CREATE PROCEDURE [dbo].[NexoniaJobFunctionsGet] 

	
AS 

/*******************************************************************************************************
*   DENVERAPP.dbo.NexoniaJobFunctionsGet
*
*   Creator: Michelle Morales/David Martin  
*   Date: 03/10/2016          
*   
*          
*   Notes:  
*
*   Usage:	set statistics io on

	execute DENVERAPP.dbo.NexoniaJobFunctionsGet


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


                  
---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're using a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------

-- Jobs report for Nexonia
-- JobsFunctions.csv
select ltrim(rtrim(p.project)) as ProjectID,
ltrim(rtrim(pe.pjt_entity)) as FunctionID,
'DENVER' as Company
from 
DENVERAPP.dbo.PJPROJ p left outer join
DENVERAPP.dbo.PJPENT pe on p.project = pe.project
where p.status_pa = 'A'
AND pe.status_pa = 'A'
AND p.contract_type NOT IN ('TIME','FIN','APS')
AND pe.pjt_entity NOT IN ('00900','00925','00945','00950','00975','00999','06360','06410','06435','06440','10000','10500','13165', '28500')

UNION ALL

select ltrim(rtrim(p.project)) as ProjectID,
ltrim(rtrim(pe.pjt_entity)) as FunctionID,
'SHOPPERNY' as Company
from 
SHOPPERAPP.dbo.PJPROJ p left outer join
SHOPPERAPP.dbo.PJPENT pe on p.project = pe.project
where p.status_pa = 'A'
AND pe.status_pa = 'A'
AND p.contract_type NOT IN ('TIME','FIN','APS')
AND pe.pjt_entity NOT IN ('00900','00925','00945','00950','00975','00999','06360','06410','06435','06440','10000','10500','13165', '28500')

UNION


-- ADD DALLAS REGULAR FUNCTION CODES (Excluding Billable Travel)
SELECT	LTRIM(RTRIM(P.project)) AS ProjectID,
		CASE
			WHEN P.customer = 'CIN' AND p.alloc_method_cd <> 'NONB' THEN 'CIN - ' + LTRIM(RTRIM(PE.pjt_entity)) -- Use AT&T specific function codes
			WHEN C.TaxID00 = '' AND PE.pjt_entity NOT LIKE 'UB%' THEN 'NONTAX - ' + LTRIM(RTRIM(PE.pjt_entity)) -- Use tax-exempt specific function codes
			ELSE LTRIM(RTRIM(PE.pjt_entity)) 
		END AS FunctionID,
		'DALLAS' AS Company
FROM	DALLASAPP.dbo.PJPROJ P 
		INNER JOIN DALLASAPP.dbo.PJPENT PE ON P.project = PE.project -- Switch to inner join in case a job is missing a function code
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND PE.pjt_entity = B.code_value  -- Using the code file maintenance table to exclude specific function codes
		LEFT JOIN DALLASAPP.dbo.Customer C ON C.CustId = P.customer
WHERE	P.status_pa = 'A'
		AND PE.status_pa = 'A'
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND PE.pjt_entity <> '90200'
		
UNION ALL

-- ADD DALLAS REGULAR FUNCTION CODES (Billable Travel - Airfare)
SELECT	LTRIM(RTRIM(P.project)) AS ProjectID,
		CASE
			WHEN P.customer = 'CIN' AND p.alloc_method_cd <> 'NONB' THEN 'CIN - ' + LTRIM(RTRIM(PE.pjt_entity)) -- Use AT&T specific function codes
			WHEN C.TaxID00 = '' THEN 'NONTAX - ' + LTRIM(RTRIM(PE.pjt_entity)) -- Use tax-exempt specific function codes
			ELSE LTRIM(RTRIM(PE.pjt_entity)) 
		END + ' - Airfare' AS FunctionID,
		'DALLAS' AS Company
FROM	DALLASAPP.dbo.PJPROJ P 
		INNER JOIN DALLASAPP.dbo.PJPENT PE ON P.project = PE.project -- Switch to inner join in case a job is missing a function code
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND PE.pjt_entity = B.code_value  -- Using the code file maintenance table to exclude specific function codes
		LEFT JOIN DALLASAPP.dbo.Customer C ON C.CustId = P.customer
WHERE	P.status_pa = 'A'
		AND PE.status_pa = 'A'
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND PE.pjt_entity = '90200'

UNION ALL

-- ADD DALLAS REGULAR FUNCTION CODES (Billable Travel - Car)
SELECT	LTRIM(RTRIM(P.project)) AS ProjectID,
		CASE
			WHEN P.customer = 'CIN' AND p.alloc_method_cd <> 'NONB' THEN 'CIN - ' + LTRIM(RTRIM(PE.pjt_entity)) -- Use AT&T specific function codes
			WHEN C.TaxID00 = '' THEN 'NONTAX - ' + LTRIM(RTRIM(PE.pjt_entity)) -- Use tax-exempt specific function codes
			ELSE LTRIM(RTRIM(PE.pjt_entity)) 
		END + ' - Car' AS FunctionID,
		'DALLAS' AS Company
FROM	DALLASAPP.dbo.PJPROJ P 
		INNER JOIN DALLASAPP.dbo.PJPENT PE ON P.project = PE.project -- Switch to inner join in case a job is missing a function code
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND PE.pjt_entity = B.code_value  -- Using the code file maintenance table to exclude specific function codes
		LEFT JOIN DALLASAPP.dbo.Customer C ON C.CustId = P.customer
WHERE	P.status_pa = 'A'
		AND PE.status_pa = 'A'
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND PE.pjt_entity = '90200'

UNION ALL

-- ADD DALLAS REGULAR FUNCTION CODES (Billable Travel - Entertainment)
SELECT	LTRIM(RTRIM(P.project)) AS ProjectID,
		CASE
			WHEN P.customer = 'CIN' AND p.alloc_method_cd <> 'NONB' THEN 'CIN - ' + LTRIM(RTRIM(PE.pjt_entity)) -- Use AT&T specific function codes
			WHEN C.TaxID00 = '' THEN 'NONTAX - ' + LTRIM(RTRIM(PE.pjt_entity)) -- Use tax-exempt specific function codes
			ELSE LTRIM(RTRIM(PE.pjt_entity))  
		END + ' - Entertainment' AS FunctionID,
		'DALLAS' AS Company
FROM	DALLASAPP.dbo.PJPROJ P 
		INNER JOIN DALLASAPP.dbo.PJPENT PE ON P.project = PE.project -- Switch to inner join in case a job is missing a function code
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND PE.pjt_entity = B.code_value  -- Using the code file maintenance table to exclude specific function codes
		LEFT JOIN DALLASAPP.dbo.Customer C ON C.CustId = P.customer
WHERE	P.status_pa = 'A'
		AND PE.status_pa = 'A'
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND PE.pjt_entity = '90200'

UNION ALL
	
-- ADD DALLAS REGULAR FUNCTION CODES (Billable Travel - Hotel)
SELECT	LTRIM(RTRIM(P.project)) AS ProjectID,
		CASE
			WHEN P.customer = 'CIN' AND p.alloc_method_cd <> 'NONB' THEN 'CIN - ' + LTRIM(RTRIM(PE.pjt_entity)) -- Use AT&T specific function codes
			WHEN C.TaxID00 = '' THEN 'NONTAX - ' + LTRIM(RTRIM(PE.pjt_entity)) -- Use tax-exempt specific function codes
			ELSE LTRIM(RTRIM(PE.pjt_entity))  
		END + ' - Hotel' AS FunctionID,
		'DALLAS' AS Company
FROM	DALLASAPP.dbo.PJPROJ P 
		INNER JOIN DALLASAPP.dbo.PJPENT PE ON P.project = PE.project -- Switch to inner join in case a job is missing a function code
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND PE.pjt_entity = B.code_value  -- Using the code file maintenance table to exclude specific function codes
		LEFT JOIN DALLASAPP.dbo.Customer C ON C.CustId = P.customer
WHERE	P.status_pa = 'A'
		AND PE.status_pa = 'A'
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND PE.pjt_entity = '90200'

UNION ALL

-- ADD DALLAS REGULAR FUNCTION CODES (Billable Travel - Meals)
SELECT	LTRIM(RTRIM(P.project)) AS ProjectID,
		CASE
			WHEN P.customer = 'CIN' AND p.alloc_method_cd <> 'NONB' THEN 'CIN - ' + LTRIM(RTRIM(PE.pjt_entity)) -- Use AT&T specific function codes
			WHEN C.TaxID00 = '' THEN 'NONTAX - ' + LTRIM(RTRIM(PE.pjt_entity)) -- Use tax-exempt specific function codes
			ELSE LTRIM(RTRIM(PE.pjt_entity))  
		END + ' - Meals' AS FunctionID,
		'DALLAS' AS Company
FROM	DALLASAPP.dbo.PJPROJ P 
		INNER JOIN DALLASAPP.dbo.PJPENT PE ON P.project = PE.project -- Switch to inner join in case a job is missing a function code
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND PE.pjt_entity = B.code_value  -- Using the code file maintenance table to exclude specific function codes
		LEFT JOIN DALLASAPP.dbo.Customer C ON C.CustId = P.customer
WHERE	P.status_pa = 'A'
		AND PE.status_pa = 'A'
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND PE.pjt_entity = '90200'

UNION ALL
		
-- ADD DALLAS REGULAR FUNCTION CODES (Billable Travel - Mileage)
SELECT	LTRIM(RTRIM(P.project)) AS ProjectID,
		CASE
			WHEN P.customer = 'CIN' AND p.alloc_method_cd <> 'NONB' THEN 'CIN - ' + LTRIM(RTRIM(PE.pjt_entity)) -- Use AT&T specific function codes
			WHEN C.TaxID00 = '' THEN 'NONTAX - ' + LTRIM(RTRIM(PE.pjt_entity)) -- Use tax-exempt specific function codes
			ELSE LTRIM(RTRIM(PE.pjt_entity))  
		END + ' - Mileage' AS FunctionID,
		'DALLAS' AS Company
FROM	DALLASAPP.dbo.PJPROJ P 
		INNER JOIN DALLASAPP.dbo.PJPENT PE ON P.project = PE.project -- Switch to inner join in case a job is missing a function code
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND PE.pjt_entity = B.code_value  -- Using the code file maintenance table to exclude specific function codes
		LEFT JOIN DALLASAPP.dbo.Customer C ON C.CustId = P.customer
WHERE	P.status_pa = 'A'
		AND PE.status_pa = 'A'
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND PE.pjt_entity = '90200'

UNION ALL

-- ADD DALLAS REGULAR FUNCTION CODES (Billable Travel - Other)
SELECT	LTRIM(RTRIM(P.project)) AS ProjectID,
		CASE
			WHEN P.customer = 'CIN' AND p.alloc_method_cd <> 'NONB' THEN 'CIN - ' + LTRIM(RTRIM(PE.pjt_entity)) -- Use AT&T specific function codes
			WHEN C.TaxID00 = '' THEN 'NONTAX - ' + LTRIM(RTRIM(PE.pjt_entity)) -- Use tax-exempt specific function codes
			ELSE LTRIM(RTRIM(PE.pjt_entity))  
		END + ' - Other' AS FunctionID,
		'DALLAS' AS Company
FROM	DALLASAPP.dbo.PJPROJ P 
		INNER JOIN DALLASAPP.dbo.PJPENT PE ON P.project = PE.project -- Switch to inner join in case a job is missing a function code
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND PE.pjt_entity = B.code_value  -- Using the code file maintenance table to exclude specific function codes
		LEFT JOIN DALLASAPP.dbo.Customer C ON C.CustId = P.customer
WHERE	P.status_pa = 'A'
		AND PE.status_pa = 'A'
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND PE.pjt_entity = '90200'

ORDER BY	Company, ProjectID

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on NexoniaJobFunctionsGet to BFGROUP
go

grant execute on NexoniaJobFunctionsGet to MSDSL
go

grant control on NexoniaJobFunctionsGet to MSDSL
go

grant execute on NexoniaJobFunctionsGet to MSDynamicsSL
go