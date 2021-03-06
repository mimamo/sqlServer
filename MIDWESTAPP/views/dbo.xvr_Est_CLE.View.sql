USE [MIDWESTAPP]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.views WITH(NOLOCK)
            WHERE NAME = 'xvr_Est_CLE'
                AND type = 'V'
           )
    DROP VIEW [dbo].[xvr_Est_CLE]
GO


CREATE VIEW [dbo].[xvr_Est_CLE]

AS

/*******************************************************************************************************
*   MIDWESTAPP.dbo.xvr_Est_CLE 
*
*   Creator:   
*   Date:          
*   
*
*   Notes:         

*
*   Usage:	
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/

SELECT c.Project
, c.pjt_entity
, c.RevId
, c.Amount as 'CLEAmount'
FROM PJREVCAT c 
JOIN PJPROJEX ex 
	ON c.Project = ex.PRoject 
	and c.RevID = ex.pm_id25
GO



/*
select distinct pm_id25
from PJPROJEX

select c.RevID, ex.pm_id25, c.Amount, *
from midwestapp.dbo.pjRevCat c
left join midwestapp.dbo.PJPROJEX ex
	ON c.Project = ex.PRoject 
--	and c.RevID = ex.pm_id25
where c.project = '00693515AGY'

select RevID, *
from midwestapp.dbo.PJREVCAT
where project = '00693515AGY'

select RevID, [status], *
from midwestapp.dbo.PJREVHDR
where project = '00693515AGY'


select  pm_id25, *
from midwestapp.dbo.PJPROJEX
where project = '00693515AGY'

SELECT c.Project,
	c.RevId,
	ULEAmount = sum(case when h.[status] = 'P' then 0 else c.Amount end),
	h.[status]
FROM midwestapp.dbo.PJREVCAT c 
inner join (SELECT h.project,
				ULERevID = Max(RevID)
			FROM midwestapp.dbo.PJREVHDR h 
			WHERE h.[status] in ('I', 'P')
			GROUP BY h.project) ULE 
	ON c.project = ULE.Project 
	and c.RevID = ULE.ULERevID
inner join midwestapp.dbo.PJREVHDR h 
	ON h.Project = ULE.PRoject 
	and h.RevID = ULE.ULERevID
GROUP BY c.Project, c.RevID, h.[status]
*/

---------------------------------------------
-- permissions
---------------------------------------------
grant select on xvr_Est_CLE to public
go

grant select on xvr_Est_CLE to BFGROUP
go

grant delete on xvr_Est_CLE to BFGROUP
go

grant insert on xvr_Est_CLE to BFGROUP
go

grant update on xvr_Est_CLE to BFGROUP
go

grant control on xvr_Est_CLE to MSDSL
go

grant select on xvr_Est_CLE to MSDSL
go

grant select on xvr_Est_CLE to MSDynamicsSL
go