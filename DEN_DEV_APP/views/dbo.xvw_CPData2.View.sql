USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[xvw_CPData2]    Script Date: 12/21/2015 14:05:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvw_CPData2]
AS
/*
Adding column for major profit center grouping per Jill Picard 7/23/14
*/

/* PROJECT REVENUE*/ SELECT 'REV' AS Acct_Type, CASE WHEN (p.project = '' OR
                      p.project = '00000000ZZZ' OR
                      p.project IS NULL OR
                      c.ClassGroup = '40DGEN') THEN 'INDIRECT' ELSE 'DIRECT' END AS CP_Type, 'REVENUE' AS CP_Group, 
                      CASE WHEN gl.sub = '1045' THEN 'NEWYORK' WHEN gl.sub = '1031' THEN 'APS' WHEN gl.sub = '1032' THEN 'ICP' ELSE 'AGENCY' END AS PCenter, 
                      CASE WHEN gl.sub = '1031' OR gl.sub = '1032' THEN 'EG+' 
                           ELSE 'DENVER' END AS MPCenter,                      
                      'Project Revenue' AS acct, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, p.project, Sum(CuryCrAmt - CuryDrAmt) 
                      AS Amount, gl.perpost, gl.Sub, gl.Acct as GLAcct
FROM         PJPROJ p RIGHT OUTER JOIN
                      GLTran gl ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings AS c ON p.pm_id01 = c.CustId
WHERE     ((Acct BETWEEN '4000' AND '4509' OR
                      Acct BETWEEN '4511' AND '4519' OR
                      Acct BETWEEN '4521' AND '4696' OR
--                      Acct BETWEEN '4521' AND '4698' OR Changed to above per JP 7/17/14
                      Acct BETWEEN '4700' AND '4999') AND Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'DENVER' AND gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND 
                      perpost >= '201301'
GROUP BY gl.perpost, p.project, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name, acct
UNION ALL
/* RETAINED REVENUE*/ SELECT 'REV' AS Acct_Type, CASE WHEN (p.project = '' OR
                      p.project = '00000000ZZZ' OR
                      p.project IS NULL OR
                      c.ClassGroup = '40DGEN') THEN 'INDIRECT' ELSE 'DIRECT' END AS CP_Type, 'REVENUE' AS CP_Group, 
                      CASE WHEN gl.sub = '1045' THEN 'NEWYORK' WHEN gl.sub = '1031' THEN 'APS' WHEN gl.sub = '1032' THEN 'ICP' ELSE 'AGENCY' END AS PCenter,
                      CASE WHEN gl.sub = '1031' OR gl.sub = '1032' THEN 'EG+' 
                           ELSE 'DENVER' END AS MPCenter, 
                      'Retained Revenue' AS acct, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, p.project, Sum(CuryCrAmt - CuryDrAmt) 
                      AS Amount, gl.perpost, gl.Sub, gl.Acct
FROM         PJPROJ p RIGHT OUTER JOIN
                      GLTran gl ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings AS c ON p.pm_id01 = c.CustId
WHERE     (Acct IN ('4510', '4520') AND Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'DENVER' AND gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND 
                      perpost >= '201301'
GROUP BY gl.perpost, p.project, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name, gl.Acct
UNION ALL
/* TOTAL REVENUE*/ SELECT 'REV' AS Acct_Type, CASE WHEN (p.project = '' OR
                      p.project = '00000000ZZZ' OR
                      p.project IS NULL OR
                      c.ClassGroup = '40DGEN') THEN 'INDIRECT' ELSE 'DIRECT' END AS CP_Type, 'REVENUE' AS CP_Group, 
                      CASE WHEN gl.sub = '1045' THEN 'NEWYORK' WHEN gl.sub = '1031' THEN 'APS' WHEN gl.sub = '1032' THEN 'ICP' ELSE 'AGENCY' END AS PCenter, 
                      CASE WHEN gl.sub = '1031' OR gl.sub = '1032' THEN 'EG+' 
                           ELSE 'DENVER' END AS MPCenter,
                      'Total Revenue' AS acct, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, p.project, Sum(CuryCrAmt - CuryDrAmt) 
                      AS Amount, gl.perpost, gl.Sub, gl.Acct
FROM         PJPROJ p RIGHT OUTER JOIN
                      GLTran gl ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings AS c ON p.pm_id01 = c.CustId
WHERE     ((Acct BETWEEN '4000' AND '4696' OR
             --Above changed per JP 7/17/14 original: Acct BETWEEN '4000' AND '4698' OR
                      Acct BETWEEN '4700' AND '4999') AND Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'DENVER' AND gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND 
                      perpost >= '201301'
GROUP BY gl.perpost, p.project, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name, gl.Acct
UNION ALL
/*Payroll*/ SELECT 'EX' AS Acct_Type, CASE WHEN (gl.projectid = '' OR
                      gl.projectid = '00000000ZZZ' OR
                      gl.projectid IS NULL OR
                      c.ClassGroup = '40DGEN') THEN 'INDIRECT' ELSE 'DIRECT' END AS CP_Type, 'LABOR' AS CP_Group, 
                      CASE WHEN sub = '1045' THEN 'NEWYORK' WHEN sub = '1031' THEN 'APS' WHEN sub = '1032' THEN 'ICP' ELSE 'AGENCY' END AS Agency,
                      CASE WHEN gl.sub = '1031' OR gl.sub = '1032' THEN 'EG+' 
                           ELSE 'DENVER' END AS MPCenter,
                            'Payroll' AS acct, 
                      c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) AS Amount, gl.perpost, 
                      gl.Sub, gl.Acct
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('6000', '6001', '6002', '6003') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'DENVER' AND gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND 
                      gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name, gl.Acct
UNION ALL
/* Other Comp Costs*/ SELECT 'EX' AS Acct_Type, CASE WHEN (gl.projectid = '' OR
                      gl.projectid = '00000000ZZZ' OR
                      gl.projectid IS NULL OR
                      c.ClassGroup = '40DGEN') THEN 'INDIRECT' ELSE 'DIRECT' END AS CP_Type, 'LABOR' AS CP_Group, 
                      CASE WHEN gl.sub = '1045' THEN 'NEWYORK' WHEN gl.sub = '1031' THEN 'APS' WHEN gl.sub = '1032' THEN 'ICP' ELSE 'AGENCY' END AS Agency,
                      CASE WHEN gl.sub = '1031' OR gl.sub = '1032' THEN 'EG+' 
                           ELSE 'DENVER' END AS MPCenter, 
                      'Other Comp' AS acct, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) 
                      AS Amount, gl.perpost, gl.Sub, gl.Acct
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('6700', '7450', '6600', '6601', '6900', '6708', '6711', '5025', '7451', '7452', '7453', '7454', '6712', '6713', '6714', '6650', '6715', '6710', '5028', '6255') AND 
                      gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'DENVER' AND gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name, gl.Acct
UNION ALL
/*Payroll Related*/ SELECT 'EX' AS Acct_Type, CASE WHEN (gl.projectid = '' OR
                      gl.projectid = '00000000ZZZ' OR
                      gl.projectid IS NULL OR
                      c.ClassGroup = '40DGEN') THEN 'INDIRECT' ELSE 'DIRECT' END AS CP_Type, 'LABOR' AS CP_Group, 
                      CASE WHEN gl.sub = '1045' THEN 'NEWYORK' WHEN gl.sub = '1031' THEN 'APS' WHEN gl.sub = '1032' THEN 'ICP' ELSE 'AGENCY' END AS Agency, 
                      CASE WHEN gl.sub = '1031' OR gl.sub = '1032' THEN 'EG+' 
                           ELSE 'DENVER' END AS MPCenter,
                      'Payroll Related' AS acct, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) 
                      AS Amount, gl.perpost, gl.Sub, gl.Acct
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('6200', '6245', '6250', '6300', '6360', '6400', '6401', '6500', '6800', '6950') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'DENVER' AND 
                      gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name, gl.Acct
UNION ALL
/*SEA Expenses*/ SELECT 'EX' AS Acct_Type, CASE WHEN (gl.projectid = '' OR
                      gl.projectid = '00000000ZZZ' OR
                      gl.projectid IS NULL OR
                      c.ClassGroup = '40DGEN') THEN 'INDIRECT' ELSE 'DIRECT' END AS CP_Type, 'SEA' AS CP_Group, 
                      CASE WHEN gl.sub = '1045' THEN 'NEWYORK' WHEN gl.sub = '1031' THEN 'APS' WHEN gl.sub = '1032' THEN 'ICP' ELSE 'AGENCY' END AS Agency, 
                      CASE WHEN gl.sub = '1031' OR gl.sub = '1032' THEN 'EG+' 
                           ELSE 'DENVER' END AS MPCenter,
                      'SEA' AS acct, 
                      c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) AS Amount, gl.perpost, 
                      gl.Sub, gl.Acct
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings AS c ON p.pm_id01 = c.CustId
WHERE     ((gl.acct BETWEEN '5000' AND '5999' AND gl.acct <> '5010') AND gl.Sub NOT IN ('1050', '1051', '1052'))
           AND gl.CpnyID = 'DENVER' AND gl.Posted = 'P' AND 
                      gl.LedgerId = 'ACTUAL' AND gl.perpost >= '201409'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name, gl.Acct
UNION ALL
/*Rent*/ SELECT 'EX' AS Acct_Type, CASE WHEN (gl.projectid = '' OR
                      gl.projectid = '00000000ZZZ' OR
                      gl.projectid IS NULL OR
                      c.ClassGroup = '40DGEN') THEN 'INDIRECT' ELSE 'DIRECT' END AS CP_Type, 'RENT' AS CP_Group, 
                      CASE WHEN gl.sub = '1045' THEN 'NEWYORK' WHEN gl.sub = '1031' THEN 'APS' WHEN gl.sub = '1032' THEN 'ICP' ELSE 'AGENCY' END AS Agency,
                      CASE WHEN gl.sub = '1031' OR gl.sub = '1032' THEN 'EG+' 
                           ELSE 'DENVER' END AS MPCenter,
                       'Rent' AS acct, 
                      c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) AS Amount, gl.perpost, 
                      gl.Sub, gl.Acct
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings AS c ON p.pm_id01 = c.CustId
WHERE     (gl.acct IN ('7000', '7001', '7002', '7003', '7004', '7006', '7007', '7008', '7009', '7010', '7061') 
AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'DENVER' AND
                       gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name, gl.Acct
UNION ALL
/*Donovan*/ SELECT 'EX' AS Acct_Type, CASE WHEN (gl.projectid = '' OR
                      gl.projectid = '00000000ZZZ' OR
                      gl.projectid IS NULL OR
                      c.ClassGroup = '40DGEN') THEN 'INDIRECT' ELSE 'DIRECT' END AS CP_Type, 'DONOVAN' AS CP_Group, 
                      CASE WHEN gl.sub = '1045' THEN 'NEWYORK' WHEN gl.sub = '1031' THEN 'APS' WHEN gl.sub = '1032' THEN 'ICP' ELSE 'AGENCY' END AS Agency, 
                      CASE WHEN gl.sub = '1031' OR gl.sub = '1032' THEN 'EG+' 
                           ELSE 'DENVER' END AS MPCenter,
                      'Donovan' AS acct, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) AS Amount,
                       gl.perpost, gl.Sub, gl.Acct
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings AS c ON p.pm_id01 = c.CustId
WHERE     (gl.acct IN ('7205', '7140') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'DENVER' AND gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND 
                      gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name, gl.Acct
UNION ALL
/*Leagel Fees*/ SELECT 'EX' AS Acct_Type, CASE WHEN (gl.projectid = '' OR
                      gl.projectid = '00000000ZZZ' OR
                      gl.projectid IS NULL OR
                      c.ClassGroup = '40DGEN') THEN 'INDIRECT' ELSE 'DIRECT' END AS CP_Type, CASE WHEN (gl.projectid = '' OR
                      gl.projectid = '00000000ZZZ' OR
                      gl.projectid IS NULL) THEN 'OVERHEAD' ELSE 'LEGAL' END AS CP_Group, 
                      CASE WHEN gl.sub = '1045' THEN 'NEWYORK' WHEN gl.sub = '1031' THEN 'APS' WHEN gl.sub = '1032' THEN 'ICP' ELSE 'AGENCY' END AS Agency, 
                      CASE WHEN gl.sub = '1031' OR gl.sub = '1032' THEN 'EG+' 
                           ELSE 'DENVER' END AS MPCenter,
                      'Legal' AS acct, 
                      c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) AS Amount, gl.perpost, 
                      gl.Sub, gl.Acct
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings AS c ON p.pm_id01 = c.CustId
WHERE     (gl.acct IN ('7480', '5014', '7481', '7482', '7390', '7483') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'DENVER' AND gl.Posted = 'P' AND 
                      gl.LedgerId = 'ACTUAL' AND gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name, gl.Acct
UNION ALL
/*Client Service Costs*/ SELECT 'EX' AS Acct_Type, 'INDIRECT' AS CP_Type, 'OVERHEAD' AS CP_Group, 
                      CASE WHEN gl.sub = '1045' THEN 'NEWYORK' WHEN gl.sub = '1031' THEN 'APS' WHEN gl.sub = '1032' THEN 'ICP' ELSE 'AGENCY' END AS Agency,
                      CASE WHEN gl.sub = '1031' OR gl.sub = '1032' THEN 'EG+' 
                           ELSE 'DENVER' END AS MPCenter, 
                      'Client Service Costs' AS acct, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) 
                      AS Amount, gl.perpost, gl.Sub, gl.Acct
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('7150', '5002', '7071', '7154', '5004', '7073', '7153', '5003', '7072', '7156', '7157',
     --added 7157, per JP 7/17/14
     '5008', '7075', '7155', '5005', '7160', '5001', '5009', '7074', '7076', '7170', '5006', 
                      '7172', '7171', '5007') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'DENVER' AND gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND 
                      gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name, gl.Acct
UNION ALL
/*Severance*/ SELECT 'EX' AS Acct_Type, 'INDIRECT' AS CP_Type, 'OVERHEAD' AS CP_Group, 
                      CASE WHEN gl.sub = '1045' THEN 'NEWYORK' WHEN gl.sub = '1031' THEN 'APS' WHEN gl.sub = '1032' THEN 'ICP' ELSE 'AGENCY' END AS Agency,
                      CASE WHEN gl.sub = '1031' OR gl.sub = '1032' THEN 'EG+' 
                           ELSE 'DENVER' END AS MPCenter, 
                      'Severance' AS acct, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) 
                      AS Amount, gl.perpost, gl.Sub, gl.Acct
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('6100') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'DENVER' AND gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND 
                      gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name, gl.Acct
UNION ALL
/*Miscellaneous*/ SELECT 'EX' AS Acct_Type, 'INDIRECT' AS CP_Type, 'OVERHEAD' AS CP_Group, 
                      CASE WHEN gl.sub = '1045' THEN 'NEWYORK' WHEN gl.sub = '1031' THEN 'APS' WHEN gl.sub = '1032' THEN 'ICP' ELSE 'AGENCY' END AS Agency, 
                      CASE WHEN gl.sub = '1031' OR gl.sub = '1032' THEN 'EG+' 
                           ELSE 'DENVER' END AS MPCenter,
                      'Miscellaneous' AS acct, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) 
                      AS Amount, gl.perpost, gl.Sub, gl.Acct
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('7545', '7614', '7546', '7800', '7542', '7547', '7635', '7548', '7615', '7620', '7516') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'DENVER' AND
                       gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name, gl.Acct
UNION ALL
/*Interest*/ SELECT 'EX' AS Acct_Type, 'INDIRECT' AS CP_Type, 'INTEREST' AS CP_Group, 
                      CASE WHEN gl.sub = '1045' THEN 'NEWYORK' WHEN gl.sub = '1031' THEN 'APS' WHEN gl.sub = '1032' THEN 'ICP' ELSE 'AGENCY' END AS Agency, 
                      CASE WHEN gl.sub = '1031' OR gl.sub = '1032' THEN 'EG+' 
                           ELSE 'DENVER' END AS MPCenter,
                      'Interest' AS acct, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) AS Amount, 
                      gl.perpost, gl.Sub, gl.Acct
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('7052', '7600', '9052', '7560', '7561', '7562') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'DENVER' AND gl.Posted = 'P' AND 
                      gl.LedgerId = 'ACTUAL' AND gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name, gl.Acct
UNION ALL
/*Management Fee*/ SELECT 'EX' AS Acct_Type, 'INDIRECT' AS CP_Type, 'OVERHEAD' AS CP_Group, 
                      CASE WHEN gl.sub = '1045' THEN 'NEWYORK' WHEN gl.sub = '1031' THEN 'APS' WHEN gl.sub = '1032' THEN 'ICP' ELSE 'AGENCY' END AS Agency, 
                      CASE WHEN gl.sub = '1031' OR gl.sub = '1032' THEN 'EG+' 
                           ELSE 'DENVER' END AS MPCenter,
                      'Management Fee' AS acct, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) 
                      AS Amount, gl.perpost, gl.Sub, gl.Acct
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('8180', '8190') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'DENVER' AND gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND 
                      gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name, gl.Acct
UNION ALL
/*Audit*/ SELECT 'EX' AS Acct_Type, 'INDIRECT' AS CP_Type, 'OVERHEAD' AS CP_Group, 
                      CASE WHEN gl.sub = '1045' THEN 'NEWYORK' WHEN gl.sub = '1031' THEN 'APS' WHEN gl.sub = '1032' THEN 'ICP' ELSE 'AGENCY' END AS Agency,
                      CASE WHEN gl.sub = '1031' OR gl.sub = '1032' THEN 'EG+' 
                           ELSE 'DENVER' END AS MPCenter,
                       'Audit' AS acct, 
                      c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) AS Amount, gl.perpost, 
                      gl.Sub, gl.Acct
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('7485') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'DENVER' AND gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND 
                      gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name, gl.Acct
UNION ALL
/*Depreciation*/ SELECT 'EX' AS Acct_Type, 'INDIRECT' AS CP_Type, 'OVERHEAD' AS CP_Group, 
                      CASE WHEN gl.sub = '1045' THEN 'NEWYORK' WHEN gl.sub = '1031' THEN 'APS' WHEN gl.sub = '1032' THEN 'ICP' ELSE 'AGENCY' END AS Agency, 
                      CASE WHEN gl.sub = '1031' OR gl.sub = '1032' THEN 'EG+' 
                           ELSE 'DENVER' END AS MPCenter,
                      'Depreciation' AS acct, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) 
                      AS Amount, gl.perpost, gl.Sub, gl.Acct
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('7030', '7040', '7031', '7032', '7033', '9030', '9040', '9031', '9032', '9033') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'DENVER' AND 
                      gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name, gl.Acct
UNION ALL
/*Equipment Rental*/ SELECT 'EX' AS Acct_Type, 'INDIRECT' AS CP_Type, 'OVERHEAD' AS CP_Group, 
                      CASE WHEN gl.sub = '1045' THEN 'NEWYORK' WHEN gl.sub = '1031' THEN 'APS' WHEN gl.sub = '1032' THEN 'ICP' ELSE 'AGENCY' END AS Agency, 
                      CASE WHEN gl.sub = '1031' OR gl.sub = '1032' THEN 'EG+' 
                           ELSE 'DENVER' END AS MPCenter,
                      'Equipment Rental' AS acct, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) 
                      AS Amount, gl.perpost, gl.Sub, gl.Acct
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('7050', '7055', '7250', '7251', '7252', '9050', '9055', '9250', '9251', '9252') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'DENVER' AND 
                      gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name, gl.Acct
UNION ALL
/*Amortization*/ SELECT 'EX' AS Acct_Type, 'INDIRECT' AS CP_Type, 'OVERHEAD' AS CP_Group, 
                      CASE WHEN gl.sub = '1045' THEN 'NEWYORK' WHEN gl.sub = '1031' THEN 'APS' WHEN gl.sub = '1032' THEN 'ICP' ELSE 'AGENCY' END AS Agency, 
                      CASE WHEN gl.sub = '1031' OR gl.sub = '1032' THEN 'EG+' 
                           ELSE 'DENVER' END AS MPCenter,
                      'Amortization' AS acct, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) 
                      AS Amount, gl.perpost, gl.Sub, gl.Acct
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('7311', '7313', '7314', '7315', '9311') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'DENVER' AND gl.Posted = 'P' AND 
                      gl.LedgerId = 'ACTUAL' AND gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name, gl.Acct
UNION ALL
/*Other General*/ SELECT 'EX' AS Acct_Type, 'INDIRECT' AS CP_Type, 'OVERHEAD' AS CP_Group, 
                      CASE WHEN gl.sub = '1045' THEN 'NEWYORK' WHEN gl.sub = '1031' THEN 'APS' WHEN gl.sub = '1032' THEN 'ICP' ELSE 'AGENCY' END AS Agency, 
                      CASE WHEN gl.sub = '1031' OR gl.sub = '1032' THEN 'EG+' 
                           ELSE 'DENVER' END AS MPCenter,
                      'Other General' AS acct, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) 
                      AS Amount, gl.perpost, gl.Sub, gl.Acct
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('7550', '7095', '7200', '5019', '7091', '7106', '7094', '7097', '7231', '5015', '7319', '7096', '7060', '7098', '7099', '7320', '7310', '7090', '7321', '7345', '7322', 
                      '7318', '7234', '7230', '7232', '5011', '7270', '7340', '7514', '7280', '7265', '7271', '5016', '7272', '5000', '5017', '5018', '5020', '7100', '7110', '7411', '7412', '7413', 
                      '7414', '7416', '7417', '7418', '7419', '7420', '7421', '7422', '7423', '7424', '7428', '7410', '7470', '7505', '7520', '7521', '7425', '7426', '7549', '7051', '7233', '7551', 
                      '7105', '7092', '9051', '9549', '9551', '7435', '7430', '5024', '5027', '7490', '5029', '5032','7080', '7525', '7500', '5023', '7070', '7460', '7440', '7461', '7462', '7463', '7441', 
                      '7442', '7443', '7445', '7446', '7447', '7448', '5013', '7616', '7543', '7544', '5010', '5026', '5030', '7370', '7180', '7184', '5012', '7510', '5022', '7511', '7210', '5021', 
                      '7211', '7212', '7213', '7220', '7214', '7700', '7530', '7053'
                      ,'7078','7079')
                      --Per JP, added accounts 7078 and 7079 7/18/14 
                      AND gl.Sub NOT IN ('1050', '1051', '1052'
                      
                      )) AND gl.CpnyID = 'DENVER' AND gl.Posted = 'P' AND 
                      gl.LedgerId = 'ACTUAL' AND gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name, gl.Acct
GO
