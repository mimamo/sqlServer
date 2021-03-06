USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_Est_CLE]    Script Date: 12/21/2015 13:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- View which returns the Current Locket Estimate Amount by Job /Function
CREATE VIEW [dbo].[xvr_Est_CLE]

AS

SELECT c.Project
, c.pjt_entity
, c.RevId
, c.Amount as 'CLEAmount'
FROM PJREVCAT c JOIN PJPROJEX ex ON c.Project = ex.PRoject and c.RevID = ex.pm_id25
GO
