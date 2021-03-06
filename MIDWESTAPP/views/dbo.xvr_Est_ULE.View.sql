USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[xvr_Est_ULE]    Script Date: 12/21/2015 15:55:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- View which returns the Last Estimate Amount by Job /Function
CREATE VIEW [dbo].[xvr_Est_ULE]

AS

SELECT c.Project
, c.pjt_entity
, c.RevId
, c.Amount as 'ULEAmount'
, h.status
FROM PJREVCAT c JOIN 
(SELECT h.project
, Max(RevID) as 'ULERevID'
FROM PJREVHDR h 
WHERE h.status in ('I', 'C')
GROUP BY h.project
) ULE ON c.project = ULE.Project and c.RevID = ULE.ULERevID
	JOIN PJREVHDR h ON h.Project = ULE.PRoject and h.RevID = ULE.ULERevID
GO
