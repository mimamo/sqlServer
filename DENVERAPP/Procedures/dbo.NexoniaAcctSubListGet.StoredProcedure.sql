USE [DENVERAPP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'NexoniaAcctSubListGet'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[NexoniaAcctSubListGet]
GO

CREATE PROCEDURE [dbo].[NexoniaAcctSubListGet] 

	
AS 

/*******************************************************************************************************
*   DENVERAPP.dbo.NexoniaAcctSubListGet
*
*   Creator: Michelle Morales/David Martin  
*   Date: 03/10/2016          
*   
*          
*   Notes:  
*
*   Usage:	set statistics io on

	execute DENVERAPP.dbo.NexoniaAcctSubListGet


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

-- Create account / Subaccount list AcctSubList.csv
select ltrim(rtrim(ac.acct)) as GLAcct
, ltrim(rtrim(ac.SUB)) as GLSub
, ltrim(rtrim(ac.Descr)) as Descr
, 'DENVER' as Company
, 'DENVER' as Company2
from DENVERSYS.DBO.acctsub ac 
inner join DENVERAPP.dbo.Account a on ac.Acct = a.Acct
where ac.CpnyID = 'Denver' 
and a.User5 = 'Y'
and ac.Active = '1'
AND ac.Sub NOT IN ('1099','1060','1055','1019','1030','1085','1025','1018','1042','1026','1016','2700')

UNION

select ltrim(rtrim(ac.acct)) as GLAcct
, ltrim(rtrim(ac.SUB)) as GLSub
, ltrim(rtrim(ac.Descr)) as Descr
, 'SHOPPERNY' as Company
, 'SHOPPERNY' as Company2
from DENVERSYS.DBO.acctsub ac 
inner join SHOPPERAPP.dbo.Account a on ac.Acct = a.Acct
where ac.CpnyID = 'SHOPPERNY' 
and a.User5 = 'Y'
and ac.Active = '1'
AND ac.Sub NOT IN ('1099','1060','1055','1019','1030','1085','1025','1018','1042','1026','1016','2700')

UNION

-- ADD DALLAS


SELECT	LTRIM(RTRIM(A.Acct)) AS 'GLAcct',
		LTRIM(RTRIM(S.Sub)) AS 'GLSub',
		LTRIM(RTRIM(A.Descr)) AS 'Descr',
		'DALLAS' AS 'Company',
		'DALLAS' AS 'Company2'
FROM	DALLASAPP.dbo.Account A, DALLASAPP.dbo.SubAcct S
WHERE	S.Sub IN ('0000')
		AND A.Active = 1
		-- AND A.User5 = 'Y' -- Not Needed For Dallas

ORDER BY Company


---------------------------------------------
-- permissions
---------------------------------------------
grant execute on NexoniaAcctSubListGet to BFGROUP
go

grant execute on NexoniaAcctSubListGet to MSDSL
go

grant control on NexoniaAcctSubListGet to MSDSL
go

grant execute on NexoniaAcctSubListGet to MSDynamicsSL
go