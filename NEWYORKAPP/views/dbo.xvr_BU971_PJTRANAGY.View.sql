USE [NEWYORKAPP]
GO
/****** Object:  View [dbo].[xvr_BU971_PJTRANAGY]    Script Date: 12/21/2015 16:00:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_BU971_PJTRANAGY]

AS

SELECT max(lupd_datetime) as 'LastActivityDate', project
FROM PJTRAN
GROUP BY project
GO
