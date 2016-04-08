USE [DENVERAPP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'NexoniaSubAccountsGet'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[NexoniaSubAccountsGet]
GO

CREATE PROCEDURE [dbo].[NexoniaSubAccountsGet] 

	
AS 

/*******************************************************************************************************
*   DENVERAPP.dbo.NexoniaSubAccountsGet
*
*   Creator: Michelle Morales/David Martin  
*   Date: 03/10/2016          
*   
*          
*   Notes:  
*
*   Usage:	set statistics io on

	execute DENVERAPP.dbo.NexoniaSubAccountsGet


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
-- GL SubAccounts for Nexonia
-- SubAccounts.csv
select distinct ltrim(rtrim(s.Sub)) as SubAccountID,
ltrim(rtrim(s.Descr)) as SubAccountName,
'DENVER' as Company
--ltrim(rtrim( 
from DENVERAPP.dbo.SubAcct s
where s.Sub NOT IN ('1099','1060','1055','1019','1030','1085','1025','1018','1042','1026','1016','2700')

UNION

select distinct ltrim(rtrim(s.Sub)) as SubAccountID,
ltrim(rtrim(s.Descr)) as SubAccountName,
'SHOPPERNY' as Company
--ltrim(rtrim( 
from SHOPPERAPP.dbo.SubAcct s
where s.Sub NOT IN ('1099','1060','1055','1019','1030','1085','1025','1018','1042','1026','1016','2700')

UNION

-- ADD DALLAS

SELECT	LTRIM(RTRIM(S.Sub)) AS SubAccountID,
		LTRIM(RTRIM(S.Descr)) as SubAccountName,
		'DALLAS' as Company
FROM	DALLASAPP.dbo.SubAcct S
WHERE	S.Sub IN ('0000')

ORDER BY Company

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on NexoniaSubAccountsGet to BFGROUP
go

grant execute on NexoniaSubAccountsGet to MSDSL
go

grant control on NexoniaSubAccountsGet to MSDSL
go

grant execute on NexoniaSubAccountsGet to MSDynamicsSL
go