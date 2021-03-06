USE [DENVERAPP]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- View which returns the Last Estimate Amount by Job /Function
CREATE VIEW [dbo].[xvr_Est_ULE_Project]

AS

/*******************************************************************************************************
*   DENVERAPP.dbo.xvr_Est_ULE_Project 
*
*   Creator:   
*   Date:          
*   
*
*   Notes:         
*                  select top 100 * from DENVERAPP.dbo.xvr_Est_ULE_Project
*
*   Usage:	
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*
********************************************************************************************************/


SELECT c.Project,
	c.RevId,
	ULEAmount = sum(c.Amount),
	h.[status]
FROM DENVERAPP.dbo.PJREVCAT c 
inner join (SELECT h.project,
				ULERevID = Max(RevID) 
			FROM DENVERAPP.dbo.PJREVHDR h 
			WHERE h.[status] in ('I', 'C')
			GROUP BY h.project) ULE 
	ON c.project = ULE.Project 
	and c.RevID = ULE.ULERevID
inner join DENVERAPP.dbo.PJREVHDR h 
	ON h.Project = ULE.PRoject 
	and h.RevID = ULE.ULERevID
GROUP BY c.Project, c.RevID, h.[status]
GO
