USE [SHOPPER_DEV_APP]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.views WITH(NOLOCK)
            WHERE NAME = 'xvr_Est_ULE_Project'
                AND type = 'V'
           )
    DROP VIEW [dbo].[xvr_Est_ULE_Project]
GO

-- View which returns the Last Estimate Amount by Job /Function
CREATE VIEW [dbo].[xvr_Est_ULE_Project]

AS

/*******************************************************************************************************
*   shopper_dev_app.dbo.xvr_Est_ULE_Project 
*
*   Creator:   
*   Date:          
*   
*
*   Notes:         
					select top 100 * 
					from shopper_dev_app.dbo.xvr_Est_ULE_Project
					where project = '00008415NYC'

					select top 100 * 
					from shopperapp.dbo.xvr_Est_ULE_Project
					where project = '00008415NYC'
*
*   Usage:	
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	02/16/2016	51274: Use statuses I and P instead of I and C.
********************************************************************************************************/

SELECT c.Project,
	c.RevId,
	ULEAmount = sum(c.Amount),
	h.[status]
FROM shopper_dev_app.dbo.PJREVCAT c 
inner join (SELECT h.project,
				ULERevID = Max(RevID)
			FROM shopper_dev_app.dbo.PJREVHDR h 
			WHERE h.[status] in ('I', 'P')
			GROUP BY h.project) ULE 
	ON c.project = ULE.Project 
	and c.RevID = ULE.ULERevID
inner join shopper_dev_app.dbo.PJREVHDR h 
	ON h.Project = ULE.PRoject 
	and h.RevID = ULE.ULERevID
GROUP BY c.Project, c.RevID, h.[status]
GO


---------------------------------------------
-- permissions
---------------------------------------------
grant select on xvr_Est_ULE_Project to public
go

grant select on xvr_Est_ULE_Project to BFGROUP
go

grant delete on xvr_Est_ULE_Project to BFGROUP
go

grant insert on xvr_Est_ULE_Project to BFGROUP
go

grant update on xvr_Est_ULE_Project to BFGROUP
go

grant control on xvr_Est_ULE_Project to MSDSL
go

grant select on xvr_Est_ULE_Project to MSDSL
go

grant select on xvr_Est_ULE_Project to MSDynamicsSL
go
