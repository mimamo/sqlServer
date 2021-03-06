USE [MID_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_PO022_PJBILL]    Script Date: 12/21/2015 14:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PO022_PJBILL]

AS

SELECT DISTINCT a.project as 'bproject'
, b.project
, g.ProjectChildCount
, g.ProjectDisposition
FROM PJBILL b LEFT JOIN
(SELECT CASE WHEN project_billwith = ''
			THEN project
			ELSE project_billwith  END AS 'lProject'
, project
, project_billwith
FROM PJBILL) a ON b.project_billwith = a.lProject LEFT JOIN (SELECT f.ChildCount as 'ProjectChildCount'
, f.project_billwith
, g.project
, CASE WHEN f.ChildCount = 0 AND f.project_billwith = 'NONE'
        THEN 'StandAlone Job'
        WHEN f.ChildCount = 1 AND f.project_billwith = g.project
        THEN 'Parent Job w/ One Child'
        WHEN f.ChildCount = 1 AND f.project_billwith <> g.project
        THEN CAST('Child Job of Parent Job ' + rtrim(f.project_billwith) + ' w/ No Siblings' as varchar(100))
        WHEN f.ChildCount > 1 AND f.project_billwith <> 'NONE' AND f.project_billwith <> g.project
        THEN CAST('Child Job of Parent Job ' + rtrim(f.project_billwith) + ' w/ Siblings' as varchar(100))
        WHEN f.ChildCount > 1 AND f.project_billwith <> 'NONE' AND f.project_billwith = g.project
        THEN 'Parent Job w/ Children' 
        ELSE 'NonBillable Job' end as 'ProjectDisposition' 
FROM PJBILL g (nolock) LEFT JOIN
(SELECT isnull(d.ChildCount, 0) as 'ChildCount'
, isnull(d.project_billwith, 'NONE') as 'project_billwith'
, e.project
FROM PJBILL e (nolock) LEFT JOIN 
(SELECT count(c.project_billwith) as 'ChildCount'
, c.project_billwith
FROM (SELECT a.project
, a.project_billwith
FROM PJBILL b (nolock) LEFT JOIN
(SELECT project
, project_billwith
FROM PJBILL (nolock) 
WHERE project_billwith <> '') a ON b.project = a.project
WHERE b.project_billwith <> a.project) c
GROUP BY c.project_billwith) d ON d.project_billwith = e.project) f ON g.project_billwith = f.project) g ON b.project = g.project
GO
