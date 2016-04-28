USE [DENVERAPP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'NexoniaFunctionsGet'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[NexoniaFunctionsGet]
GO

CREATE PROCEDURE [dbo].[NexoniaFunctionsGet] 

	
AS 

/*******************************************************************************************************
*   DENVERAPP.dbo.NexoniaFunctionsGet
*
*   Creator: Michelle Morales/David Martin  
*   Date: 03/10/2016          
*   
*          
*   Notes:  
*
*   Usage:	set statistics io on

	execute DENVERAPP.dbo.NexoniaFunctionsGet


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
select Account, 
	code_ID, 
	descr, 
	Taxable = 'No',
	Company = 'DENVER',
	Company2 = 'DENVER' 
from DENVERAPP.dbo.xIGFunctionCode 
where code_ID not in ( '13550', 'NBIZ10','UB05','LSWU11','70013' ) 
	AND code_ID not like '999%' 

UNION

select Account, 
	code_ID, 
	descr, 
	Taxable = 'No',
	Company = 'SHOPPERNY',
	Company2 = 'SHOPPERNY' 
from SHOPPERAPP.dbo.xIGFunctionCode where code_ID not in ( '13550', 'NBIZ10','UB05','LSWU11','70013' ) 
	AND code_ID not like '999%' 

UNION

/*------------------------------------------------|
|												  |
|  Normal Function Codes						  |
|												  |
|------------------------------------------------*/

-- ADD DALLAS REGULAR FUNCTION CODES (Excluding Billable Travel)
SELECT	LTRIM(RTRIM(A.Account)) AS 'Account',
		LTRIM(RTRIM(A.code_ID)) AS 'code_ID',
		LTRIM(RTRIM(A.descr)) AS 'descr',
		CASE
			WHEN A.user02 = 'TAX' THEN 'Yes'
			ELSE 'No'
		END AS 'Taxable',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.xIGFunctionCode A 
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
WHERE	A.status = 'A' -- Active Function Codes Only
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND A.code_ID NOT IN ('90200','20300') -- Exclude Billable Travel and Studio

UNION ALL

-- ADD DALLAS REGULAR FUNCTION CODES (Billable Travel Airfare)
SELECT	'1231' AS 'Account',
		'90200 - Airfare' AS 'code_ID',
		'Billable - Travel - Airfare' AS 'descr',
		'No' AS 'Taxable',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.xIGFunctionCode A 
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
WHERE	A.status = 'A' -- Active Function Codes Only
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND A.code_ID = '90200'

UNION ALL

-- ADD DALLAS REGULAR FUNCTION CODES (Billable Travel Car)
SELECT	'1232' AS 'Account',
		'90200 - Car' AS 'code_ID',
		'Billable - Travel - Car' AS 'descr',
		'No' AS 'Taxable',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.xIGFunctionCode A 
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
WHERE	A.status = 'A' -- Active Function Codes Only
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND A.code_ID = '90200'

UNION ALL

-- ADD DALLAS REGULAR FUNCTION CODES (Billable Travel Mileage)
SELECT	'1232' AS 'Account',
		'90200 - Mileage' AS 'code_ID',
		'Billable - Travel - Mileage' AS 'descr',
		'No' AS 'Taxable',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.xIGFunctionCode A 
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
WHERE	A.status = 'A' -- Active Function Codes Only
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND A.code_ID = '90200'

UNION ALL

-- ADD DALLAS REGULAR FUNCTION CODES (Billable Travel Entertainment)
SELECT	'1233' AS 'Account',
		'90200 - Entertainment' AS 'code_ID',
		'Billable - Travel - Entertainment' AS 'descr',
		'No' AS 'Taxable',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.xIGFunctionCode A 
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
WHERE	A.status = 'A' -- Active Function Codes Only
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND A.code_ID = '90200'

UNION ALL

-- ADD DALLAS REGULAR FUNCTION CODES (Billable Travel Hotel)
SELECT	'1234' AS 'Account',
		'90200 - Hotel' AS 'code_ID',
		'Billable - Travel - Hotel' AS 'descr',
		'No' AS 'Taxable',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.xIGFunctionCode A 
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
WHERE	A.status = 'A' -- Active Function Codes Only
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND A.code_ID = '90200'

UNION ALL

-- ADD DALLAS REGULAR FUNCTION CODES (Billable Travel Meals)
SELECT	'1235' AS 'Account',
		'90200 - Meals' AS 'code_ID',
		'Billable - Travel - Meals' AS 'descr',
		'No' AS 'Taxable',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.xIGFunctionCode A 
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
WHERE	A.status = 'A' -- Active Function Codes Only
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND A.code_ID = '90200'

UNION ALL

-- ADD DALLAS REGULAR FUNCTION CODES (Billable Travel Other)
SELECT	'1236' AS 'Account',
		'90200 - Other' AS 'code_ID',
		'Billable - Travel - Other' AS 'descr',
		'No' AS 'Taxable',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.xIGFunctionCode A 
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
WHERE	A.status = 'A' -- Active Function Codes Only
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND A.code_ID = '90200'

UNION ALL

/*------------------------------------------------|
|												  |
|  Non-Taxable Client-Specific Function Codes	  |
|												  |
|------------------------------------------------*/

-- ADD DALLAS NON-TAX CLIENTS BILLABLE FUNCTION CODES (Excluding Billable Travel)
SELECT	LTRIM(RTRIM(A.Account)) AS 'Account',
		'NONTAX - ' + LTRIM(RTRIM(A.code_ID)) AS 'code_ID',
		'Tax-Exempt Billable - ' + LTRIM(RTRIM(A.descr)) AS 'descr',
		CASE
			WHEN A.user02 = 'TAX' THEN 'Yes'
			ELSE 'No'
		END AS 'Taxable',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.xIGFunctionCode A 
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
WHERE	A.status = 'A' -- Active Function Codes Only
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND A.code_ID NOT IN ('90200','20300') -- Exclude Billable Travel and Studio
		AND A.code_ID NOT LIKE 'UB%'

UNION ALL

-- ADD DALLAS NON-TAX CLIENTS BILLABLE FUNCTION CODES (Billable Travel Airfare)
SELECT	'1231' AS 'Account',
		'NONTAX - 90200 - Airfare' AS 'code_ID',
		'Tax-Exempt Billable - Travel - Airfare' AS 'descr',
		'No' AS 'Taxable',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.xIGFunctionCode A 
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
WHERE	A.status = 'A' -- Active Function Codes Only
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND A.code_ID = '90200'

UNION ALL

-- ADD DALLAS NON-TAX CLIENTS BILLABLE FUNCTION CODES (Billable Travel Car)
SELECT	'1232' AS 'Account',
		'NONTAX - 90200 - Car' AS 'code_ID',
		'Tax-Exempt Billable - Travel - Car' AS 'descr',
		'No' AS 'Taxable',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.xIGFunctionCode A 
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
WHERE	A.status = 'A' -- Active Function Codes Only
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND A.code_ID = '90200'

UNION ALL

-- ADD DALLAS NON-TAX CLIENTS BILLABLE FUNCTION CODES (Billable Travel Mileage)
SELECT	'1232' AS 'Account',
		'NONTAX - 90200 - Mileage' AS 'code_ID',
		'Tax-Exempt Billable - Travel - Mileage' AS 'descr',
		'No' AS 'Taxable',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.xIGFunctionCode A 
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
WHERE	A.status = 'A' -- Active Function Codes Only
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND A.code_ID = '90200'

UNION ALL

-- ADD DALLAS NON-TAX CLIENTS BILLABLE FUNCTION CODES (Billable Travel Entertainment)
SELECT	'1233' AS 'Account',
		'NONTAX - 90200 - Entertainment' AS 'code_ID',
		'Tax-Exempt Billable - Travel - Entertainment' AS 'descr',
		'No' AS 'Taxable',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.xIGFunctionCode A 
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
WHERE	A.status = 'A' -- Active Function Codes Only
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND A.code_ID = '90200'

UNION ALL

-- ADD DALLAS NON-TAX CLIENTS BILLABLE FUNCTION CODES (Billable Travel Hotel)
SELECT	'1234' AS 'Account',
		'NONTAX - 90200 - Hotel' AS 'code_ID',
		'Tax-Exempt Billable - Travel - Hotel' AS 'descr',
		'No' AS 'Taxable',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.xIGFunctionCode A 
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
WHERE	A.status = 'A' -- Active Function Codes Only
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND A.code_ID = '90200'

UNION ALL

-- ADD DALLAS NON-TAX CLIENTS BILLABLE FUNCTION CODES (Billable Travel Meals)
SELECT	'1235' AS 'Account',
		'NONTAX - 90200 - Meals' AS 'code_ID',
		'Tax-Exempt Billable - Travel - Meals' AS 'descr',
		'No' AS 'Taxable',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.xIGFunctionCode A 
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
WHERE	A.status = 'A' -- Active Function Codes Only
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND A.code_ID = '90200'

UNION ALL

-- ADD DALLAS NON-TAX CLIENTS BILLABLE FUNCTION CODES (Billable Travel Other)
SELECT	'1236' AS 'Account',
		'NONTAX - 90200 - Other' AS 'code_ID',
		'Tax-Exempt Billable - Travel - Other' AS 'descr',
		'No' AS 'Taxable',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.xIGFunctionCode A 
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
WHERE	A.status = 'A' -- Active Function Codes Only
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND A.code_ID = '90200'
		
UNION ALL

/*------------------------------------------------|
|												  |
|  AT&T Client-Specific Function Codes			  |
|												  |
|------------------------------------------------*/

-- ADD DALLAS AT&T BILLABLE FUNCTION CODES (Excluding Billable Travel)
SELECT	LTRIM(RTRIM(A.Account)) AS 'Account',
		'CIN - ' + LTRIM(RTRIM(A.code_ID)) AS 'code_ID',
		'AT&T Billable - ' + LTRIM(RTRIM(A.descr)) AS 'descr',
		CASE
			WHEN A.user02 = 'TAX' THEN 'Yes'
			ELSE 'No'
		END AS 'Taxable',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.xIGFunctionCode A 
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
WHERE	A.status = 'A' -- Active Function Codes Only
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND A.code_ID NOT IN ('90200','20300') -- Exclude Billable Travel and Studio
		AND A.code_ID NOT LIKE 'UB%'

UNION ALL

-- ADD DALLAS AT&T BILLABLE FUNCTION CODES (Billable Travel Airfare)
SELECT	'1231' AS 'Account',
		'CIN - 90200 - Airfare' AS 'code_ID',
		'AT&T Billable - Travel - Airfare' AS 'descr',
		'No' AS 'Taxable',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.xIGFunctionCode A 
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
WHERE	A.status = 'A' -- Active Function Codes Only
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND A.code_ID = '90200'

UNION ALL

-- ADD DALLAS AT&T BILLABLE FUNCTION CODES (Billable Travel Car)
SELECT	'1232' AS 'Account',
		'CIN - 90200 - Car' AS 'code_ID',
		'AT&T Billable - Travel - Car' AS 'descr',
		'No' AS 'Taxable',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.xIGFunctionCode A 
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
WHERE	A.status = 'A' -- Active Function Codes Only
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND A.code_ID = '90200'

UNION ALL

-- ADD DALLAS AT&T BILLABLE FUNCTION CODES (Billable Travel Mileage)
SELECT	'1232' AS 'Account',
		'CIN - 90200 - Mileage' AS 'code_ID',
		'AT&T Billable - Travel - Mileage' AS 'descr',
		'No' AS 'Taxable',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.xIGFunctionCode A 
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
WHERE	A.status = 'A' -- Active Function Codes Only
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND A.code_ID = '90200'

UNION ALL

-- ADD DALLAS AT&T BILLABLE FUNCTION CODES (Billable Travel Entertainment)	DON'T USE FOR AT&T
-- SELECT	'1233' AS 'Account',
--			'CIN - 90200 - Entertainment' AS 'code_ID',
--			'AT&T Billable - Travel - Entertainment' AS 'descr',
--			'No' AS 'Taxable',
--			'DALLAS' AS 'Company'
-- FROM	DALLASAPP.dbo.xIGFunctionCode A 
--			LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
-- WHERE	A.status = 'A' -- Active Function Codes Only
--			AND B.code_value IS NULL -- Function Codes Not On The Exclude List
--			AND A.code_ID = '90200'
--
-- UNION ALL

-- ADD DALLAS AT&T BILLABLE FUNCTION CODES (Billable Travel Hotel)
SELECT	'1234' AS 'Account',
		'CIN - 90200 - Hotel' AS 'code_ID',
		'AT&T Billable - Travel - Hotel' AS 'descr',
		'No' AS 'Taxable',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.xIGFunctionCode A 
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
WHERE	A.status = 'A' -- Active Function Codes Only
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND A.code_ID = '90200'

UNION ALL

-- ADD DALLAS AT&T BILLABLE FUNCTION CODES (Billable Travel Meals)
SELECT	'1235' AS 'Account',
		'CIN - 90200 - Meals' AS 'code_ID',
		'AT&T Billable - Travel - Meals' AS 'descr',
		'No' AS 'Taxable',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.xIGFunctionCode A 
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
WHERE	A.status = 'A' -- Active Function Codes Only
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND A.code_ID = '90200'

UNION ALL

-- ADD DALLAS AT&T BILLABLE FUNCTION CODES (Billable Travel Other)
SELECT	'1236' AS 'Account',
		'CIN - 90200 - Other' AS 'code_ID',
		'AT&T Billable - Travel - Other' AS 'descr',
		'No' AS 'Taxable',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.xIGFunctionCode A 
		LEFT JOIN DALLASAPP.dbo.PJCODE B ON B.code_type = 'NEX1' AND A.code_ID = B.code_value  -- Using the code file maintenance table to exclude specific function codes
WHERE	A.status = 'A' -- Active Function Codes Only
		AND B.code_value IS NULL -- Function Codes Not On The Exclude List
		AND A.code_ID = '90200'
		
ORDER BY code_ID
		
		

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on NexoniaFunctionsGet to BFGROUP
go

grant execute on NexoniaFunctionsGet to MSDSL
go

grant control on NexoniaFunctionsGet to MSDSL
go

grant execute on NexoniaFunctionsGet to MSDynamicsSL
go