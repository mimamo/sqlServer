USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[vs_PRTran2]    Script Date: 12/21/2015 14:05:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_PRTran2] AS 
    select p.Project, p.project_desc, t.Batnbr, 'NO' as CurrBatNbr
      from PJProj p INNER JOIN PRTran t 
        ON p.Project      =  t.ProjectId
       and t.Batnbr     <> '' 
       and t.TimeShtFlg =  1 
     group by p.Project, p.project_desc, BatNbr
     UNION
    select p.Project, p.project_desc, '' as BatNbr, 'YES' as CurrBatNbr
      from PJProj p
     where p.status_pa = 'A' 
       and p.status_LB = 'A'
GO
