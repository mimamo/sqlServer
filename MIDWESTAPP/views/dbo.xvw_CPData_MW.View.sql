USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[xvw_CPData_MW]    Script Date: 12/21/2015 15:55:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvw_CPData_MW]
AS
/* TOTAL REVENUE*/ SELECT 'REV' AS Acct_Type, CASE WHEN (p.project = '' OR
                      p.project = '00000000ZZZ' OR
                      p.project IS NULL OR
                      c.Custid IN ('2MWINT', '3DNVER', '3MWINT')) THEN 'INDIRECT' ELSE 'DIRECT' END AS CP_Type, 'REVENUE' AS CP_Group, 'MIDWEST Agency' AS PCenter, 
                      'Total Revenue' AS acct, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, p.project, Sum(CuryCrAmt - CuryDrAmt) 
                      AS Amount, gl.perpost, gl.Sub
FROM         PJPROJ p RIGHT OUTER JOIN
                      GLTran gl ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings_MW AS c ON p.pm_id01 = c.CustId
WHERE     ((Acct BETWEEN '4000' AND '4698' OR
                      Acct BETWEEN '4700' AND '4999') AND Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'MIDWEST' AND gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND 
                      perpost >= '201301'
GROUP BY gl.perpost, p.project, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name
UNION ALL
/*Payroll*/ SELECT 'EX' AS Acct_Type, CASE WHEN (gl.projectid = '' OR
                      gl.projectid = '00000000ZZZ' OR
                      gl.projectid IS NULL OR
                      c.Custid IN ('2MWINT', '3DNVER', '3MWINT')) THEN 'INDIRECT' ELSE 'DIRECT' END AS CP_Type, 'LABOR' AS CP_Group, 
                      CASE WHEN sub = '1045' THEN 'NEWYORK' WHEN sub = '1031' THEN 'APS' WHEN sub = '1032' THEN 'ICP' ELSE 'AGENCY' END AS Agency, 'Payroll' AS acct, 
                      c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) AS Amount, gl.perpost, 
                      gl.Sub
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings_MW AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('6000', '6001', '6002', '6003') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'MIDWEST' AND gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND 
                      gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name
UNION ALL
/* Other Comp Costs*/ SELECT 'EX' AS Acct_Type, CASE WHEN (gl.projectid = '' OR
                      gl.projectid = '00000000ZZZ' OR
                      gl.projectid IS NULL OR
                      c.Custid IN ('2MWINT', '3DNVER', '3MWINT')) THEN 'INDIRECT' ELSE 'DIRECT' END AS CP_Type, 'LABOR' AS CP_Group, 'MIDWEST Agency' AS Agency, 
                      'Other Comp' AS acct, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) 
                      AS Amount, gl.perpost, gl.Sub
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings_MW AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('6700', '7450', '6600', '6601', '6900', '6708', '6711', '5025', '7451', '7452', '7453', '7454', '6712', '6713', '6714', '6650', '6715', '6710', '5028', '6255') AND 
                      gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'MIDWEST' AND gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name
UNION ALL
/*Payroll Related*/ SELECT 'EX' AS Acct_Type, CASE WHEN (gl.projectid = '' OR
                      gl.projectid = '00000000ZZZ' OR
                      gl.projectid IS NULL OR
                      c.Custid IN ('2MWINT', '3DNVER', '3MWINT')) THEN 'INDIRECT' ELSE 'DIRECT' END AS CP_Type, 'LABOR' AS CP_Group, 'MIDWEST Agency' AS Agency, 
                      'Payroll Related' AS acct, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) 
                      AS Amount, gl.perpost, gl.Sub
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings_MW AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('6200', '6245', '6250', '6300', '6360', '6400', '6401', '6500', '6800', '6950') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'MIDWEST' AND 
                      gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name
UNION ALL
/*SEA Expenses*/ SELECT 'EX' AS Acct_Type, CASE WHEN (gl.projectid = '' OR
                      gl.projectid = '00000000ZZZ' OR
                      gl.projectid IS NULL OR
                      c.Custid IN ('2MWINT', '3DNVER', '3MWINT')) THEN 'INDIRECT' ELSE 'DIRECT' END AS CP_Type, 'SEA' AS CP_Group, 'MIDWEST Agency' AS Agency, 'SEA' AS acct, 
                      c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) AS Amount, gl.perpost, 
                      gl.Sub
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings_MW AS c ON p.pm_id01 = c.CustId
WHERE     ((gl.acct BETWEEN '5000' AND '5999' AND gl.acct <> '5010') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'MIDWEST' AND gl.Posted = 'P' AND 
                      gl.LedgerId = 'ACTUAL' AND gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name
UNION ALL
/*Rent*/ SELECT 'EX' AS Acct_Type, 'INDIRECT' AS CP_Type, 'OVERHEAD' AS CP_Group, 'MIDWEST Agency' AS Agency, 'Rent' AS acct, c.ClassGroup, c.GroupDesc, c.ClassId, 
                      c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) AS Amount, gl.perpost, gl.Sub
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings_MW AS c ON p.pm_id01 = c.CustId
WHERE     (gl.acct IN ('7000') /*, '7001', '7002', '7003', '7004', '7006', '7007', '7008', '7009', '7010', '7061') */ AND gl.Sub NOT IN ('1050', '1051', '1052')) AND 
                      gl.CpnyID = 'MIDWEST' AND gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name
UNION ALL
/*Donovan*/ SELECT 'EX' AS Acct_Type, CASE WHEN (gl.projectid = '' OR
                      gl.projectid = '00000000ZZZ' OR
                      gl.projectid IS NULL OR
                      c.Custid IN ('2MWINT', '3DNVER', '3MWINT')) THEN 'INDIRECT' ELSE 'DIRECT' END AS CP_Type, 'DONOVAN' AS CP_Group, 'MIDWEST Agency' AS Agency, 
                      'Donovan' AS acct, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) 
                      + 4657 AS Amount, gl.perpost, gl.Sub
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings_MW AS c ON p.pm_id01 = c.CustId
WHERE     (gl.acct IN ('7205', '7140') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'MIDWEST' AND gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND 
                      gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name
UNION ALL
/*Leagel Fees*/ SELECT 'EX' AS Acct_Type, 'INDIRECT' AS CP_Type, 'OVERHEAD' AS CP_Group, 'MIDWEST Agency' AS Agency, 'Legal' AS acct, c.ClassGroup, c.GroupDesc, 
                      c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) AS Amount, gl.perpost, gl.Sub
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings_MW AS c ON p.pm_id01 = c.CustId
WHERE     (gl.acct IN ('7480', '5014', '7481', '7482', '7390', '7483') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'MIDWEST' AND gl.Posted = 'P' AND 
                      gl.LedgerId = 'ACTUAL' AND gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name
UNION ALL
/*Client Service Costs*/ SELECT 'EX' AS Acct_Type, 'INDIRECT' AS CP_Type, 'OVERHEAD' AS CP_Group, 'MIDWEST Agency' AS Agency, 'Client Service Costs' AS acct, 
                      c.ClassGroup, c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) AS Amount, gl.perpost, 
                      gl.Sub
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings_MW AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('7150', '5002', '7071', '7154', '5004', '7073', '7153', '5003', '7072', '7156', '5008', '7075', '7155', '5005', '7160', '5001', '5009', '7074', '7076', '7170', '5006', 
                      '7172', '7171', '5007') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'MIDWEST' AND gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND 
                      gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name
UNION ALL
/*Severance*/ SELECT 'EX' AS Acct_Type, 'INDIRECT' AS CP_Type, 'OVERHEAD' AS CP_Group, 'MIDWEST Agency' AS Agency, 'Severance' AS acct, c.ClassGroup, c.GroupDesc, 
                      c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) AS Amount, gl.perpost, gl.Sub
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings_MW AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('6100') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'MIDWEST' AND gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND 
                      gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name
UNION ALL
/*Miscellaneous*/ SELECT 'EX' AS Acct_Type, 'INDIRECT' AS CP_Type, 'OVERHEAD' AS CP_Group, 'MIDWEST Agency' AS Agency, 'Miscellaneous' AS acct, c.ClassGroup, 
                      c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) AS Amount, gl.perpost, gl.Sub
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings_MW AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('7545', '7614', '7546', '7800', '7542', '7547', '7635', '7548', '7615', '7620', '7516') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND 
                      gl.CpnyID = 'MIDWEST' AND gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name
UNION ALL
/*Interest*/ SELECT 'EX' AS Acct_Type, 'INDIRECT' AS CP_Type, 'INTEREST' AS CP_Group, 'MIDWEST Agency' AS Agency, 'Interest' AS acct, c.ClassGroup, c.GroupDesc, 
                      c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) AS Amount, gl.perpost, gl.Sub
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings_MW AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('7052', '7600', '9052', '7560', '7561', '7562') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'MIDWEST' AND gl.Posted = 'P' AND 
                      gl.LedgerId = 'ACTUAL' AND gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name
UNION ALL
/*Management Fee*/ SELECT 'EX' AS Acct_Type, 'INDIRECT' AS CP_Type, 'OVERHEAD' AS CP_Group, 'MIDWEST Agency' AS Agency, 'Management Fee' AS acct, c.ClassGroup, 
                      c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) AS Amount, gl.perpost, gl.Sub
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings_MW AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('8180', '8190') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'MIDWEST' AND gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND 
                      gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name
UNION ALL
/*Audit*/ SELECT 'EX' AS Acct_Type, 'INDIRECT' AS CP_Type, 'OVERHEAD' AS CP_Group, 'MIDWEST Agency' AS Agency, 'Audit' AS acct, c.ClassGroup, c.GroupDesc, c.ClassId, 
                      c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) AS Amount, gl.perpost, gl.Sub
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings_MW AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('7485') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'MIDWEST' AND gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND 
                      gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name
UNION ALL
/*Depreciation*/ SELECT 'EX' AS Acct_Type, 'INDIRECT' AS CP_Type, 'OVERHEAD' AS CP_Group, 'MIDWEST Agency' AS Agency, 'Depreciation' AS acct, c.ClassGroup, 
                      c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) AS Amount, gl.perpost, gl.Sub
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings_MW AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('7030', '7040', '7031', '7032', '7033', '9030', '9040', '9031', '9032', '9033') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'MIDWEST' AND 
                      gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name
UNION ALL
/*Equipment Rental*/ SELECT 'EX' AS Acct_Type, 'INDIRECT' AS CP_Type, 'OVERHEAD' AS CP_Group, 'MIDWEST Agency' AS Agency, 'Equipment Rental' AS acct, c.ClassGroup, 
                      c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) AS Amount, gl.perpost, gl.Sub
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings_MW AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('7050', '7055', '7250', '7251', '7252', '9050', '9055', '9250', '9251', '9252') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'MIDWEST' AND 
                      gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name
UNION ALL
/*Amortization*/ SELECT 'EX' AS Acct_Type, 'INDIRECT' AS CP_Type, 'OVERHEAD' AS CP_Group, 'MIDWEST Agency' AS Agency, 'Amortization' AS acct, c.ClassGroup, 
                      c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) AS Amount, gl.perpost, gl.Sub
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings_MW AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('7311', '7313', '7314', '7315', '9311') AND gl.Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'MIDWEST' AND gl.Posted = 'P' AND 
                      gl.LedgerId = 'ACTUAL' AND gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name
UNION ALL
/*Other General*/ SELECT 'EX' AS Acct_Type, 'INDIRECT' AS CP_Type, 'OVERHEAD' AS CP_Group, 'MIDWEST Agency' AS Agency, 'Other General' AS acct, c.ClassGroup, 
                      c.GroupDesc, c.ClassId, c.descr AS ClassDesc, c.CustId, c.Name AS CustName, gl.projectid, Sum(CuryDrAmt - CuryCrAmt) AS Amount, gl.perpost, gl.Sub
FROM         GLTran gl LEFT OUTER JOIN
                      PJPROJ p ON p.project = gl.ProjectID LEFT OUTER JOIN
                      xvw_ClientGroupings_MW AS c ON p.pm_id01 = c.CustId
WHERE     (gl.Acct IN ('7140', '7205', '7550', '7200', '5019', '7091', '7095', '7106', '7094', '7097', '7231', '5015', '7319', '7096', '7060', '7098', '7099', '7320', '7310', '7090', '7321', 
                      '7345', '7322', '7318', '7234', '7230', '7232', '5011', '7270', '7340', '7514', '7280', '7265', '7271', '5016', '5000', '5017', '5018', '5020', '7100', '7110', '7411', '7412', 
                      '7413', '7414', '7416', '7417', '7418', '7419', '7420', '7421', '7422', '7423', '7424', '7428', '7410', '7470', '7505', '7520', '7521', '7425', '7426', '7549', '7051', '7233', 
                      '7551', '7105', '7092', '9051', '9549', '9551', '7435', '7430', '5024', '5027', '7490', '5029', '7080', '7525', '7500', '5023', '7070', '7460', '7440', '7461', '7462', '7463', 
                      '7441', '7442', '7443', '7445', '7446', '7447', '7448', '5013', '7616', '7543', '7544', '5010', '5026', '5030', '7370', '7180', '7184', '5012', '7510', '5022', '7511', '7210', 
                      '5021', '7211', '7212', '7213', '7220', '7214', '7700', '7530', '7061', '7007', '7006', '7001', '7002', '7008', '7003', '7010', '7004') AND gl.Sub NOT IN ('1050', '1051', 
                      '1052')) AND gl.CpnyID = 'MIDWEST' AND gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND gl.perpost >= '201301'
GROUP BY gl.perpost, gl.projectid, gl.sub, c.ClassGroup, c.GroupDesc, c.ClassId, c.descr, c.CustId, c.Name
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvw_CPData_MW'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvw_CPData_MW'
GO
