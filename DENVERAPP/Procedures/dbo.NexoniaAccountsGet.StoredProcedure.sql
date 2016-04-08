USE [DENVERAPP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'NexoniaAccountsGet'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[NexoniaAccountsGet]
GO

CREATE PROCEDURE [dbo].[NexoniaAccountsGet] 

	
AS 

/*******************************************************************************************************
*   DENVERAPP.dbo.NexoniaAccountsGet
*
*   Creator: Michelle Morales/David Martin  
*   Date: 03/10/2016          
*   
*          
*   Notes:  
*
*   Usage:	set statistics io on

	execute DENVERAPP.dbo.NexoniaAccountsGet


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
-- GL Accounts for Nexonia
-- Accounts.csv
select ltrim(rtrim(a.Acct)) as AccountID,
ltrim(rtrim(a.Descr)) as AccountName,
'DENVER' as Company
from DENVERAPP.dbo.Account a 
where User5 = 'Y'

UNION

select ltrim(rtrim(a.Acct)) as AccountID,
ltrim(rtrim(a.Descr)) as AccountName,
'SHOPPERNY' as Company
from SHOPPERAPP.dbo.Account a 
where User5 = 'Y'

UNION

select ltrim(rtrim(a.Acct)) as AccountID,
ltrim(rtrim(a.Descr)) as AccountName,
'DALLAS' as Company
from DALLASAPP.dbo.Account a 
where User5 = 'Y'
order by Company


---------------------------------------------
-- permissions
---------------------------------------------
grant execute on NexoniaAccountsGet to BFGROUP
go

grant execute on NexoniaAccountsGet to MSDSL
go

grant control on NexoniaAccountsGet to MSDSL
go

grant execute on NexoniaAccountsGet to MSDynamicsSL
go