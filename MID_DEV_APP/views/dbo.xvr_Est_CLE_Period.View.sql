USE [MID_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_Est_CLE_Period]    Script Date: 12/21/2015 14:17:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- View which returns the Current Locket Estimate Amount by Job /Function
CREATE VIEW [dbo].[xvr_Est_CLE_Period]

AS

SELECT c.Project
, c.pjt_entity
, c.RevId
, h.Post_Period
, c.Amount as 'CLEAmount'
FROM PJREVCAT c JOIN PJPROJEX ex ON c.Project = ex.PRoject and c.RevID = ex.pm_id25
	JOIN PJREVHDR h on c.Project = h.project and c.RevID = h.RevID
GO
