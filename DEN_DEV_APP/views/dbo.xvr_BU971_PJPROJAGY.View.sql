USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_BU971_PJPROJAGY]    Script Date: 12/21/2015 14:05:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_BU971_PJPROJAGY]

AS

SELECT project as 'LinkProject', status_pa, manager1, pm_id08
FROM PJPROJ
GO
