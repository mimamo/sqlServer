USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xqwip_summary_prelim_1200_to_1299]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*union all 
select rp.ri_id, dw.project projectid, 0 prj_amt 
from rptruntime rp 
cross join xqwip_denver dw 
where not exists(select projectid from rptruntime r 
cross join gltran 
where gltran.perpost <= r.begpernbr and posted = 'P' and gltran.acct between '1200' and '1299' 
and r.ri_id = rp.ri_id and gltran.projectid = dw.project) */
CREATE VIEW [dbo].[xqwip_summary_prelim_1200_to_1299]
AS
SELECT     rp.RI_ID, dbo.GLTran.ProjectID, SUM(dbo.GLTran.DrAmt - dbo.GLTran.CrAmt) AS proj_amt
FROM         dbo.RptRuntime AS rp INNER JOIN
                      dbo.GLTran ON rp.BegPerNbr >= dbo.GLTran.PerPost
WHERE     (dbo.GLTran.Acct BETWEEN '1200' AND '1299') AND (dbo.GLTran.Posted = 'P') OR
                      (dbo.GLTran.Acct = '1321') AND (dbo.GLTran.Posted = 'P')
GROUP BY rp.RI_ID, dbo.GLTran.ProjectID
GO
