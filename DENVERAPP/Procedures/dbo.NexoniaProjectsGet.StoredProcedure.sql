USE [DENVERAPP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'NexoniaProjectsGet'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[NexoniaProjectsGet]
GO

CREATE PROCEDURE [dbo].[NexoniaProjectsGet] 

	
AS 

/*******************************************************************************************************
*   DENVERAPP.dbo.NexoniaProjectsGet
*
*   Creator: Michelle Morales/David Martin  
*   Date: 03/10/2016          
*   
*          
*   Notes:  
*
*   Usage:	set statistics io on

	execute DENVERAPP.dbo.NexoniaProjectsGet


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
-- Project report for Nexonia
-- Projects.csv
select ltrim(rtrim(p.project)) as Project
, ltrim(rtrim(p.project_desc)) as ProjectDescripton
, ltrim(rtrim(p.manager1)) as ProjectMgrID
--, LTRIM(rtrim((select em_id01 from PJEMPLOY where employee = p.manager1))) as PMVendID
, CASE WHEN right(rtrim(p.project),3) = 'AGY' OR right(rtrim(p.project),3) = 'IGG' OR right(rtrim(p.project),3) = 'BAL' THEN 'Yes' ELSE 'No' END as PMApproval
, gl_subacct
, 'DENVER' as Company
, 'DENVER' as Company2
from DENVERAPP.dbo.PJPROJ p
where status_pa = 'A'
AND status_ap <> 'I'
AND contract_type NOT IN ('TIME','FIN','APS','MED')

UNION 

select ltrim(rtrim(p.project)) as Project
, ltrim(rtrim(p.project_desc)) as ProjectDescripton
, ltrim(rtrim(p.manager1)) as ProjectMgrID
--, LTRIM(rtrim((select em_id01 from PJEMPLOY where employee = p.manager1))) as PMVendID
, CASE WHEN right(rtrim(p.project),3) = 'AGY' OR right(rtrim(p.project),3) = 'IGG' OR right(rtrim(p.project),3) = 'BAL' THEN 'Yes' ELSE 'No' END as PMApproval
, gl_subacct
, 'SHOPPERNY' as Company
, 'SHOPPERNY' as Company2
from SHOPPERAPP.dbo.PJPROJ p
where status_pa = 'A'
AND status_ap <> 'I'
AND contract_type NOT IN ('TIME','FIN','APS','MED')

UNION


-- ADD DALLAS

SELECT		LTRIM(RTRIM(P.project)) AS 'Project',
			LTRIM(RTRIM(P.project)) + ' - ' + LTRIM(RTRIM(p.project_desc)) AS 'ProjectDescripton',
			LTRIM(RTRIM(p.manager2)) AS 'ProjectMgrID',
			CASE
				WHEN LEFT(P.project,3) = 'BGT' THEN 'No'
				ELSE 'Yes'
			END AS 'PMApproval',
			'0000' AS 'gl_subacct',
			'DALLAS' AS 'Company',
			'DALLAS' AS 'Company2'
FROM		DALLASAPP.dbo.PJPROJ P
WHERE		P.status_pa = 'A'
			AND P.status_ap = 'A'
			AND P.project NOT LIKE 'INTTMP%'
			
ORDER BY Company

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on NexoniaProjectsGet to BFGROUP
go

grant execute on NexoniaProjectsGet to MSDSL
go

grant control on NexoniaProjectsGet to MSDSL
go

grant execute on NexoniaProjectsGet to MSDynamicsSL
go