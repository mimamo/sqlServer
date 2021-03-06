USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[xvw_Labor]    Script Date: 12/21/2015 14:10:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* LABOR
------  NEW LABOR VIEW THAT TIES OUT*/
CREATE  VIEW [dbo].[xvw_Labor] with schemabinding 
AS
SELECT       
     CASE WHEN c.ClassGroup = '40DGEN' THEN 'INDIRECT' ELSE 'DIRECT' END AS CP_Type, 
     'HOURS' AS CP_Group, 
     CASE  WHEN (t .gl_subacct = '1045' OR p.gl_subacct = '1045') THEN 'NEWYORK'
    --      WHEN p.gl_subacct = '1045' THEN 'NEWYORK' 
          WHEN t .gl_subacct = '1031' THEN 'APS' 
          WHEN t .gl_subacct = '1032' THEN 'ICP' 
     ELSE 'AGENCY' 
     END AS PCenter, 
     a.acct, c.ClassGroup, c.GroupDesc, c.ClassId, 
     c.Descr AS ClassDesc, c.CustId, 
     c.Name AS CustName, t.project, 
     CASE WHEN t .employee = 'ASLINGSBY' THEN '0' ELSE t .units END AS TTLHrs, 
     t.fiscalno, t.trans_date, 
     CASE WHEN t .Fiscalno >= 
           CONVERT(char(4),YEAR(t .trans_date)) + 
           CASE WHEN len(CONVERT(varchar, month(t .trans_date))) = 1 
           THEN '0' 
           ELSE '' 
           END 
              + CONVERT(varchar, MONTH(t .trans_date)) 
     THEN t .Fiscalno 
     ELSE CONVERT(char(4), YEAR(t .trans_date)) + 
          CASE WHEN len(CONVERT(varchar, month(t .trans_date))) = 1 
               THEN '0' 
               ELSE '' 
               END 
               + CONVERT(varchar, MONTH(t .trans_date)) 
     END AS FiscalPeriod, 
     CONVERT(CHAR(4), YEAR(t.trans_date)) + 
           CASE WHEN LEN(CONVERT(VARCHAR, MONTH(t .trans_date))) = 1 
           THEN '0' 
           ELSE '' 
           END
      + CONVERT(VARCHAR, MONTH(t.trans_date)) AS TransPeriod, 
      t.employee, 
      isnull(t.gl_subacct,'') as gl_subacct
FROM  dbo.PJTran AS t LEFT OUTER JOIN
      dbo.PJPROJ AS p ON t.project = p.project LEFT OUTER JOIN
      dbo.xvw_ClientGroupings AS c ON p.pm_id01 = c.CustId LEFT OUTER JOIN
      dbo.PJACCT AS a ON t.acct = a.acct
WHERE     (t.fiscalno >= '201401') AND (t.acct = 'LABOR')
and t.gl_subacct not in ('1050', '1051', '1052')
--added above filter to exclude corporate and be consistent with wage calculations
-- Per Jill P. 7/18/14
GO
