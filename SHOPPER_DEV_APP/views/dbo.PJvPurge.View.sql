USE [SHOPPER_DEV_APP]
GO
/****** Object:  View [dbo].[PJvPurge]    Script Date: 12/21/2015 14:33:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[PJvPurge]
AS 
SELECT PJPROJ.Project,
'Master' = case when PJBILL.Project = PJBILL.Project_BillWith then 'Y'
			else 'N' end
FROM PJPROJ left outer join PJBILL on PJPROJ.Project = PJBILL.Project 
WHERE
PJPROJ.Status_PA = 'P'
GO
