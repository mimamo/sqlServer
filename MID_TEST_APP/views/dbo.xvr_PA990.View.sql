USE [MID_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_PA990]    Script Date: 12/21/2015 14:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PA990]
as
SELECT PJPROJ.start_date, PJPROJ.project as Parent, PJPROJ_1.project as Child
FROM PJPROJ left outer join PJPROJ as PJPROJ_1
	on substring(pjproj.project,1,8) = substring(pjproj_1.project,1,8)
WHERE substring(pjproj_1.project,9,3)='APS' and
	substring(pjproj.project,9,3)='AGY' and
	PJPROJ.start_date <= GetDate()
GO
