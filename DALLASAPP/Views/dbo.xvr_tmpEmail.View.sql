USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_tmpEmail]    Script Date: 12/21/2015 13:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_tmpEmail]

AS

SELECT DISTINCT a.user1, a.pm_id21, a.project
FROM (
SELECT CASE WHEN (RTRIM(LTRIM(x.pm_id21))) = ''
			THEN ''
			ELSE (RTRIM(LTRIM(x.pm_id21)) + '@pg.com') end as 'pm_id21'
, RTRIM(LTRIM(p.user1)) as 'user1'
, p.project
FROM PJPROJ p JOIN PJPROJEX x ON p.project = x.project
WHERE x.pm_id21 <> ''
	--AND p.status_pa = 'A'
) a
WHERE a.user1 <> ''
GO
