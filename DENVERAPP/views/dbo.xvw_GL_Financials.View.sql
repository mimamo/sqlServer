USE [DENVERAPP]
GO
/****** Object:  View [dbo].[xvw_GL_Financials]    Script Date: 12/21/2015 15:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvw_GL_Financials]
AS
/*-Revenue*/ SELECT CASE WHEN sub = '1045' THEN 'NEWYORK' WHEN sub = '1031' THEN 'APS' WHEN sub = '1032' THEN 'ICP' ELSE 'DENVER' END AS Agency, p.project, 
                      'Revenue' AS acct, Sum(CuryCrAmt - CuryDrAmt) AS Amount, gl.perpost
FROM         PJPROJ p RIGHT OUTER JOIN
                      GLTran gl ON p.project = gl.ProjectID
WHERE     ((Acct BETWEEN '4000' AND '4698' OR
                      Acct BETWEEN '4700' AND '4999') AND Sub NOT IN ('1050', '1051', '1052')) AND gl.CpnyID = 'DENVER' AND gl.Posted = 'P' AND gl.LedgerId = 'ACTUAL' AND 
                      perpost >= '201201' AND p.pm_id01 NOT LIKE '9SAN%'
GROUP BY gl.perpost, p.project, gl.sub
/*, gl.Acct*/ UNION ALL
/*Payroll*/ SELECT CASE WHEN sub = '1045' THEN 'NEWYORK' WHEN sub = '1031' THEN 'APS' WHEN sub = '1032' THEN 'ICP' ELSE 'DENVER' END AS Agency, projectid, 
                      'Payroll' AS acct, Sum(CuryDrAmt - CuryCrAmt) AS Amount, PerPost
FROM         GLTran
WHERE     (Acct IN ('6000', '6001', '6002', '6003') AND Sub NOT IN ('1050', '1051', '1052')) AND CpnyID = 'DENVER' AND Posted = 'P' AND LedgerId = 'ACTUAL' AND 
                      perpost >= '201201'
GROUP BY PerPost, projectid, sub
/*, Acct*/ UNION ALL
/* Other Comp Costs*/ SELECT CASE WHEN sub = '1045' THEN 'NEWYORK' WHEN sub = '1031' THEN 'APS' WHEN sub = '1032' THEN 'ICP' ELSE 'DENVER' END AS Agency, 
                      projectid, 'Other Comp' AS acct, Sum(CuryDrAmt - CuryCrAmt) AS Amount, PerPost
FROM         GLTran
WHERE     (Acct IN ('6700', '7450', '6600', '6601', '6900', '6708', '6711', '5025', '7451', '7452', '7453', '7454', '6712', '6713', '6714', '6650', '6715', '6710', '5028', '6255') AND 
                      Sub NOT IN ('1050', '1051', '1052')) AND CpnyID = 'DENVER' AND Posted = 'P' AND LedgerId = 'ACTUAL' AND perpost >= '201201'
GROUP BY PerPost, projectid, sub
/*, Acct*/ UNION ALL
/*Payroll Related*/ SELECT CASE WHEN sub = '1045' THEN 'NEWYORK' WHEN sub = '1031' THEN 'APS' WHEN sub = '1032' THEN 'ICP' ELSE 'DENVER' END AS Agency, 
                      projectid, 'Payroll Related' AS acct, Sum(CuryDrAmt - CuryCrAmt) AS Amount, PerPost
FROM         GLTran
WHERE     (Acct IN ('6200', '6245', '6250', '6300', '6360', '6400', '6401', '6500', '6800', '6950') AND Sub NOT IN ('1050', '1051', '1052')) AND CpnyID = 'DENVER' AND 
                      Posted = 'P' AND LedgerId = 'ACTUAL' AND perpost >= '201201'
GROUP BY PerPost, projectid, sub
/*, Acct*/ UNION ALL
/*SEA Expenses*/ SELECT CASE WHEN sub = '1045' THEN 'NEWYORK' WHEN sub = '1031' THEN 'APS' WHEN sub = '1032' THEN 'ICP' ELSE 'DENVER' END AS Agency, 
                      projectid, 'SEA' AS acct, SUM(gl.dramt - gl.cramt) AS Amount, gl.perpost
FROM         GLTRAN AS gl
WHERE     ((gl.acct BETWEEN '5000' AND '5999' AND gl.acct <> '5010') AND Sub NOT IN ('1050', '1051', '1052')) AND perpost >= '201201'
GROUP BY gl.PerPost, gl.projectid, gl.sub
/*, gl.Acct*/ UNION ALL
/* Rent*/ SELECT CASE WHEN sub = '1045' THEN 'NEWYORK' WHEN sub = '1031' THEN 'APS' WHEN sub = '1032' THEN 'ICP' ELSE 'DENVER' END AS Agency, projectid, 
                      'Rent' AS acct_name, Sum(CuryDrAmt - CuryCrAmt) AS Amount, PerPost
FROM         gltran
WHERE     acct IN ('7009', '7000') AND Sub NOT IN ('1050', '1051', '1052') AND perpost >= '201201'
GROUP BY PerPost, projectid, sub
UNION ALL
/*Donovan*/ SELECT CASE WHEN sub = '1045' THEN 'NEWYORK' WHEN sub = '1031' THEN 'APS' WHEN sub = '1032' THEN 'ICP' ELSE 'DENVER' END AS Agency, projectid, 
                      'Donovan' AS acct, Sum(CuryDrAmt - CuryCrAmt) AS Amount, PerPost
FROM         GLTran
WHERE     (Acct IN ('7205', '7140') AND Sub NOT IN ('1050', '1051', '1052')) AND perpost >= '201201'
GROUP BY PerPost, projectid, sub
/*, Acct*/ UNION ALL
/* Leagel Fees*/ SELECT CASE WHEN sub = '1045' THEN 'NEWYORK' WHEN sub = '1031' THEN 'APS' WHEN sub = '1032' THEN 'ICP' ELSE 'DENVER' END AS Agency, 
                      projectid, 'Legal' AS acct_name, Sum(CuryDrAmt - CuryCrAmt) AS Amount, PerPost
FROM         gltran
WHERE     acct IN ('7480') AND Sub NOT IN ('1050', '1051', '1052') AND perpost >= '201201'
GROUP BY PerPost, projectid, sub
UNION ALL
/*Client Service Costs*/ SELECT CASE WHEN sub = '1045' THEN 'NEWYORK' WHEN sub = '1031' THEN 'APS' WHEN sub = '1032' THEN 'ICP' ELSE 'DENVER' END AS Agency, 
                      projectid, 'Client Service Costs' AS acct, Sum(CuryDrAmt - CuryCrAmt) AS Amount, PerPost
FROM         GLTran
WHERE     (Acct IN ('7150', '5002', '7071', '7154', '5004', '7073', '7153', '5003', '7072', '7156', '5008', '7075', '7155', '5005', '7160', '5001', '5009', '7074', '7076', '7170', '5006', 
                      '7172', '7171', '5007') AND Sub NOT IN ('1050', '1051', '1052')) AND CpnyID = 'DENVER' AND Posted = 'P' AND LedgerId = 'ACTUAL' AND perpost >= '201201'
GROUP BY PerPost, projectid, sub
/*, Acct*/ UNION ALL
/*Severance*/ SELECT CASE WHEN sub = '1045' THEN 'NEWYORK' WHEN sub = '1031' THEN 'APS' WHEN sub = '1032' THEN 'ICP' ELSE 'DENVER' END AS Agency, projectid, 
                      'Severance' AS acct, Sum(CuryDrAmt - CuryCrAmt) AS Amount, PerPost
FROM         GLTran
WHERE     (Acct IN ('6100') AND Sub NOT IN ('1050', '1051', '1052')) AND perpost >= '201201'
GROUP BY PerPost, projectid, sub
/*, Acct*/ UNION ALL
/*Miscellaneous*/ SELECT CASE WHEN sub = '1045' THEN 'NEWYORK' WHEN sub = '1031' THEN 'APS' WHEN sub = '1032' THEN 'ICP' ELSE 'DENVER' END AS Agency, 
                      projectid, 'Miscellaneous' AS acct, Sum(CuryDrAmt - CuryCrAmt) AS Amount, PerPost
FROM         GLTran
WHERE     (Acct IN ('7545', '7614', '7546', '7800', '7542', '7547', '7635', '7548', '7615', '7620', '7516') AND Sub NOT IN ('1050', '1051', '1052')) AND CpnyID = 'DENVER' AND 
                      Posted = 'P' AND LedgerId = 'ACTUAL' AND perpost >= '201201'
GROUP BY PerPost, projectid, sub
/*, Acct*/ UNION ALL
/*Rent Expense*/ SELECT CASE WHEN sub = '1045' THEN 'NEWYORK' WHEN sub = '1031' THEN 'APS' WHEN sub = '1032' THEN 'ICP' ELSE 'DENVER' END AS Agency, 
                      projectid, 'Rent Expense' AS acct, Sum(CuryDrAmt - CuryCrAmt) AS Amount, PerPost
FROM         GLTran
WHERE     (Acct IN ('7000', '7001', '7002', '7003', '7004', '7006', '7007', '7008', '7009', '7010', '7061') AND Sub NOT IN ('1050', '1051', '1052')) AND CpnyID = 'DENVER' AND 
                      Posted = 'P' AND LedgerId = 'ACTUAL' AND perpost >= '201201'
GROUP BY PerPost, projectid, sub
/*, Acct*/ UNION ALL
/*General Legal Expense*/ SELECT CASE WHEN sub = '1045' THEN 'NEWYORK' WHEN sub = '1031' THEN 'APS' WHEN sub = '1032' THEN 'ICP' ELSE 'DENVER' END AS Agency,
                       projectid, 'Legal Expense' AS acct, Sum(CuryDrAmt - CuryCrAmt) AS Amount, PerPost
FROM         GLTran
WHERE     (Acct IN ('7480', '5014', '7481', '7482', '7390', '7483') AND Sub NOT IN ('1050', '1051', '1052')) AND CpnyID = 'DENVER' AND Posted = 'P' AND LedgerId = 'ACTUAL' AND
                       perpost >= '201201'
GROUP BY PerPost, projectid, sub
/*, Acct*/ UNION ALL
/*Interest*/ SELECT CASE WHEN sub = '1045' THEN 'NEWYORK' WHEN sub = '1031' THEN 'APS' WHEN sub = '1032' THEN 'ICP' ELSE 'DENVER' END AS Agency, projectid, 
                      'Interest' AS acct, Sum(CuryDrAmt - CuryCrAmt) AS Amount, PerPost
FROM         GLTran
WHERE     (Acct IN ('7052', '7600', '9052', '7560', '7561', '7562') AND Sub NOT IN ('1050', '1051', '1052')) AND CpnyID = 'DENVER' AND Posted = 'P' AND LedgerId = 'ACTUAL' AND
                       perpost >= '201201'
GROUP BY PerPost, projectid, sub
/*, Acct*/ UNION ALL
/*Management Fee*/ SELECT CASE WHEN sub = '1045' THEN 'NEWYORK' WHEN sub = '1031' THEN 'APS' WHEN sub = '1032' THEN 'ICP' ELSE 'DENVER' END AS Agency, 
                      projectid, 'Management Fee' AS acct, Sum(CuryDrAmt - CuryCrAmt) AS Amount, PerPost
FROM         GLTran
WHERE     (Acct IN ('8180', '8190') AND Sub NOT IN ('1050', '1051', '1052')) AND CpnyID = 'DENVER' AND Posted = 'P' AND LedgerId = 'ACTUAL' AND perpost >= '201201'
GROUP BY PerPost, projectid, sub
/*, Acct*/ UNION ALL
/*Audit*/ SELECT CASE WHEN sub = '1045' THEN 'NEWYORK' WHEN sub = '1031' THEN 'APS' WHEN sub = '1032' THEN 'ICP' ELSE 'DENVER' END AS Agency, projectid, 
                      'Audit Fees' AS acct, Sum(CuryDrAmt - CuryCrAmt) AS Amount, PerPost
FROM         GLTran
WHERE     (Acct IN ('7485') AND Sub NOT IN ('1050', '1051', '1052')) AND perpost >= '201201'
GROUP BY PerPost, projectid, sub
/*, Acct*/ UNION ALL
/*Depreciation*/ SELECT CASE WHEN sub = '1045' THEN 'NEWYORK' WHEN sub = '1031' THEN 'APS' WHEN sub = '1032' THEN 'ICP' ELSE 'DENVER' END AS Agency, 
                      projectid, 'Depreciation' AS acct, Sum(CuryDrAmt - CuryCrAmt) AS Amount, PerPost
FROM         GLTran
WHERE     (Acct IN ('7030', '7040', '7031', '7032', '7033', '9030', '9040', '9031', '9032', '9033') AND Sub NOT IN ('1050', '1051', '1052')) AND perpost >= '201201'
GROUP BY PerPost, projectid, sub
/*, Acct*/ UNION ALL
/*Equipment Rental*/ SELECT CASE WHEN sub = '1045' THEN 'NEWYORK' WHEN sub = '1031' THEN 'APS' WHEN sub = '1032' THEN 'ICP' ELSE 'DENVER' END AS Agency, 
                      projectid, 'Equipment Rental' AS acct, Sum(CuryDrAmt - CuryCrAmt) AS Amount, PerPost
FROM         GLTran
WHERE     (Acct IN ('7050', '7055', '7250', '7251', '7252', '9050', '9055', '9250', '9251', '9252') AND Sub NOT IN ('1050', '1051', '1052')) AND CpnyID = 'DENVER' AND 
                      Posted = 'P' AND LedgerId = 'ACTUAL' AND perpost >= '201201'
GROUP BY PerPost, projectid, sub
/*, Acct*/ UNION ALL
/*Amortization*/ SELECT CASE WHEN sub = '1045' THEN 'NEWYORK' WHEN sub = '1031' THEN 'APS' WHEN sub = '1032' THEN 'ICP' ELSE 'DENVER' END AS Agency, 
                      projectid, 'Amortization' AS acct, Sum(CuryDrAmt - CuryCrAmt) AS Amount, PerPost
FROM         GLTran
WHERE     (Acct IN ('7311', '7313', '7314', '7315', '9311') AND Sub NOT IN ('1050', '1051', '1052')) AND CpnyID = 'DENVER' AND Posted = 'P' AND LedgerId = 'ACTUAL' AND 
                      perpost >= '201201'
GROUP BY PerPost, projectid, sub
/*, Acct*/ UNION ALL
/*Other General*/ SELECT CASE WHEN sub = '1045' THEN 'NEWYORK' WHEN sub = '1031' THEN 'APS' WHEN sub = '1032' THEN 'ICP' ELSE 'DENVER' END AS Agency, 
                      projectid, 'Other General' AS acct, Sum(CuryDrAmt - CuryCrAmt) AS Amount, PerPost
FROM         GLTran
WHERE     (Acct IN ('7205', '7550', '7140', '7095', '7200', '5019', '7091', '7106', '7094', '7097', '7231', '5015', '7319', '7096', '7060', '7098', '7099', '7320', '7310', '7090', '7321', 
                      '7345', '7322', '7318', '7234', '7230', '7232', '5011', '7270', '7340', '7514', '7280', '7265', '7271', '5016', '7272', '5000', '5017', '5018', '5020', '7100', '7110', '7411', 
                      '7412', '7413', '7414', '7416', '7417', '7418', '7419', '7420', '7421', '7422', '7423', '7424', '7428', '7410', '7470', '7505', '7520', '7521', '7425', '7426', '7549', '7051', 
                      '7233', '7551', '7105', '7092', '9051', '9549', '9551', '7435', '7430', '5024', '5027', '7490', '5029', '7080', '7525', '7500', '5023', '7070', '7460', '7440', '7461', '7462', 
                      '7463', '7441', '7442', '7443', '7445', '7446', '7447', '7448', '5013', '7616', '7543', '7544', '5010', '5026', '5030', '7370', '7180', '7184', '5012', '7510', '5022', '7511', 
                      '7210', '5021', '7211', '7212', '7213', '7220', '7214', '7700', '7530', '7053') AND Sub NOT IN ('1050', '1051', '1052')) AND CpnyID = 'DENVER' AND Posted = 'P' AND 
                      LedgerId = 'ACTUAL' AND perpost >= '201201'
GROUP BY PerPost, projectid, sub
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvw_GL_Financials'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvw_GL_Financials'
GO
