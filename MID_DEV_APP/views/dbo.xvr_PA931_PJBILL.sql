USE [MID_DEV_APP]
GO

IF EXISTS (
            SELECT 1
            FROM sys.views WITH(NOLOCK)
            WHERE NAME = 'xvr_PA931_PJBILL'
                AND type = 'V'
           )
    DROP VIEW [dbo].[xvr_PA931_PJBILL]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[xvr_PA931_PJBILL]

AS 

/*******************************************************************************************************
*	MID_DEV_APP.dbo.xvr_PA931_PJBILL.sql


	select * 
	from MID_DEV_APP.dbo.xvr_PA931_PJBILL
	where bproject = '00383813AGY'
		or project = '00383813AGY'

    select * 
	from MID_DEV_APP.dbo.PJBILL
	where project = '00515814AGY'
		or project_billwith = '00515814AGY'
		

     
*   Modifications:   
*   Name				Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/

SELECT DISTINCT bproject = a.project,
	b.project,
	ProjectChildCount = isnull(d.ChildCount, 0),
	ProjectDisposition = CASE WHEN isnull(d.ChildCount, 0) = 0 AND isnull(d.project_billwith, 'NONE') = 'NONE' THEN 'StandAlone Job'
		WHEN isnull(d.ChildCount, 0) = 1 AND isnull(d.project_billwith, 'NONE') = g.project THEN 'Parent Job w/ One Child'
		WHEN isnull(d.ChildCount, 0) = 1 AND isnull(d.project_billwith, 'NONE') <> g.project THEN CAST('Child Job of Parent Job ' + rtrim(isnull(d.project_billwith, 'NONE')) + ' w/ No Siblings' as varchar(100))
		WHEN isnull(d.ChildCount, 0) > 1 AND isnull(d.project_billwith, 'NONE') <> 'NONE' AND isnull(d.project_billwith, 'NONE') <> g.project THEN CAST('Child Job of Parent Job ' + rtrim(isnull(d.project_billwith, 'NONE')) + ' w/ Siblings' as varchar(100))
		WHEN isnull(d.ChildCount, 0) > 1 AND isnull(d.project_billwith, 'NONE') <> 'NONE' AND isnull(d.project_billwith, 'NONE') = g.project THEN 'Parent Job w/ Children' 
		ELSE 'NonBillable Job' 
	end 
FROM MID_DEV_APP.dbo.PJBILL b 
LEFT JOIN MID_DEV_APP.dbo.PJBILL a 
	ON b.project_billwith = CASE WHEN a.project_billwith = '' THEN a.project ELSE a.project_billwith END
LEFT JOIN MID_DEV_APP.dbo.PJBILL g
	ON b.project = g.project
LEFT JOIN MID_DEV_APP.dbo.PJBILL e (nolock) 
	ON g.project_billwith = e.project
LEFT JOIN  (SELECT ChildCount = count(c.project_billwith),
				c.project_billwith
			FROM MID_DEV_APP.dbo.PJBILL c
			LEFT JOIN MID_DEV_APP.dbo.PJBILL b (nolock) 
				ON c.project = b.project
				and b.project_billwith <> ''	
			LEFT JOIN MID_DEV_APP.dbo.PJBILL a (nolock) 
				ON b.project = a.project
				and a.project_billwith <> ''
			WHERE b.project_billwith <> a.project				
			GROUP BY c.project_billwith) d 
	ON d.project_billwith = e.project
	


GO


