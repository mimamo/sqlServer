USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[xTrapsTimeHdr]    Script Date: 12/21/2015 14:05:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xTrapsTimeHdr]

AS

SELECT * 
FROM xtraps_timhdr 
WHERE trigger_status not in('IM', 'RI')
GO
