USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xTrapsTimeHdr]    Script Date: 12/21/2015 13:44:22 ******/
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
