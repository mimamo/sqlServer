USE [DALLASAPP]
GO
/****** Object:  View [dbo].[vs_PRTran]    Script Date: 12/21/2015 13:44:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_PRTran] AS 
    select e.EmpId, e.Name, t.Batnbr, 'NO' as CurrBatNbr
      from Employee e INNER JOIN PRTran t 
        ON e.EmpId      =  t.EmpId
       and t.Batnbr     <> '' 
       and t.TimeShtFlg =  1 
     group by e.EmpId, e.Name, BatNbr
     UNION
    select e.EmpId, e.Name, '' as BatNbr, 'YES' as CurrBatNbr
      from Employee e
GO
