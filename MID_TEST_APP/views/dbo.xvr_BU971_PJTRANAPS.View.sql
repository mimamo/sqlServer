USE [MID_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_BU971_PJTRANAPS]    Script Date: 12/21/2015 14:27:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_BU971_PJTRANAPS]

AS

SELECT max(lupd_datetime) as 'LastActivityDate', project
FROM PJTRAN
GROUP BY project
GO
