USE [DENVERAPP]
GO
/****** Object:  View [dbo].[xvr_AGY_Hours]    Script Date: 12/21/2015 15:42:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_AGY_Hours]
AS
SELECT     'AGY' AS Agency,
                          (SELECT     RTRIM(REPLACE(emp_name, '~', ', ')) AS Expr1
                            FROM          dbo.PJEMPLOY AS p
                            WHERE      (employee = dbo.PJLABHDR.Approver)) AS Approver, dbo.PJLABHDR.pe_date AS Period_End_Date, '' AS Date_Entered, 
                      dbo.PJLABDET.day1_hr1 AS Monday, dbo.PJLABDET.day2_hr1 AS Tuesday, dbo.PJLABDET.day3_hr1 AS Wednesday, dbo.PJLABDET.day4_hr1 AS Thursday, 
                      dbo.PJLABDET.day5_hr1 AS Friday, dbo.PJLABDET.day6_hr1 AS Saturday, dbo.PJLABDET.day7_hr1 AS Sunday, dbo.PJPROJ.pm_id01 AS Client_ID, 
                      dbo.PJPROJ.pm_id02 AS Product_ID, dbo.PJLABDET.project AS Project_ID, dbo.PJEMPLOY.emp_name, dbo.PJEMPLOY.emp_status, 
                      dbo.PJLABHDR.le_status AS TC_Status, dbo.xPJEMPPJT.ep_id05 AS Emp_Pay_Type, dbo.xPJEMPPJT.effect_date AS Effective_Date, 
                      dbo.PJEMPLOY.employee AS Emp_ID, 0 AS PTOHours, 0 AS GENHours, 0 AS WTDHours, dbo.PJPROJ.project_desc, dbo.PJLABDET.linenbr, dbo.PJLABDET.docnbr, 
                      CASE WHEN SUBSTRING(dbo.PJEMPLOY.user2, 5, 27) = '' THEN 'MISSING' ELSE SUBSTRING(dbo.PJEMPLOY.user2, 5, 27) END AS ADPFileID, 
                      CASE WHEN LEFT(dbo.PJEMPLOY.user2, 3) = '' THEN 'MISSING' ELSE LEFT(dbo.PJEMPLOY.user2, 3) END AS PayGroup, c.Name AS Client, x.descr AS Product, 
                      0 AS TempEmp, dbo.PJEMPLOY.gl_subacct AS Dept_ID, s.Descr AS Department, ISNULL(dbo.PJEMPLOY.em_id16, 'CO') AS WorkStateID, ISNULL(dbo.State.Descr, 
                      'Colorado') AS WorkState, ISNULL
                          ((SELECT     TOP (1) ADate
                              FROM         dbo.xAPJLABHDR WITH (nolock)
                              WHERE     (docnbr = dbo.PJLABHDR.docnbr) AND (le_status = 'C')
                              ORDER BY ADate DESC, ATime DESC), '1900/01/01') AS DateTimeCompleted, ISNULL
                          ((SELECT     TOP (1) ADate
                              FROM         dbo.xAPJLABHDR AS xAPJLABHDR_1 WITH (nolock)
                              WHERE     (docnbr = dbo.PJLABHDR.docnbr) AND (le_status = 'A') AND (ASolomonUserID = '') AND (AApplication = 'PHP 5')
                              ORDER BY ADate DESC, ATime DESC), '1900/01/01') AS DateTimeApproved, 
                      CASE WHEN PJLABHDR.le_type = 'R' THEN 'Original' WHEN PJLABHDR.le_type = 'C' THEN 'Corrected' END AS Timecard_Type, 
                      dbo.PJLABDET.docnbr AS Expr1
FROM         dbo.PJEMPLOY WITH (nolock) INNER JOIN
                      dbo.xPJEMPPJT ON dbo.PJEMPLOY.employee = dbo.xPJEMPPJT.employee LEFT OUTER JOIN
                      dbo.PJLABHDR WITH (nolock) ON dbo.xPJEMPPJT.employee = dbo.PJLABHDR.employee INNER JOIN
                      dbo.PJLABDET WITH (nolock) ON dbo.PJLABHDR.docnbr = dbo.PJLABDET.docnbr LEFT OUTER JOIN
                      dbo.PJPROJ WITH (nolock) ON dbo.PJLABDET.project = dbo.PJPROJ.project LEFT OUTER JOIN
                      dbo.Customer AS c WITH (nolock) ON dbo.PJPROJ.pm_id01 = c.CustId LEFT OUTER JOIN
                      dbo.xIGProdCode AS x WITH (nolock) ON dbo.PJPROJ.pm_id02 = x.code_ID LEFT OUTER JOIN
                      dbo.SubAcct AS s WITH (nolock) ON dbo.PJEMPLOY.gl_subacct = s.Sub LEFT OUTER JOIN
                      dbo.State WITH (nolock) ON dbo.PJEMPLOY.em_id16 = dbo.State.StateProvId
WHERE     (dbo.PJLABHDR.le_status IN ('C', 'P', 'A', 'I')) AND (dbo.PJLABHDR.pe_date > '1/1/2011')
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
         Begin Table = "PJEMPLOY"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 219
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "xPJEMPPJT"
            Begin Extent = 
               Top = 6
               Left = 257
               Bottom = 125
               Right = 417
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PJLABHDR"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 245
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PJLABDET"
            Begin Extent = 
               Top = 126
               Left = 236
               Bottom = 245
               Right = 398
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PJPROJ"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 365
               Right = 229
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 246
               Left = 267
               Bottom = 365
               Right = 441
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "x"
            Begin Extent = 
               Top = 366
               Left = 38
               Bottom = 485
               Right = 206
            End
            DisplayFlags = 280
        ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_AGY_Hours'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'    TopColumn = 0
         End
         Begin Table = "s"
            Begin Extent = 
               Top = 366
               Left = 244
               Bottom = 485
               Right = 408
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "State"
            Begin Extent = 
               Top = 486
               Left = 38
               Bottom = 605
               Right = 202
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_AGY_Hours'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_AGY_Hours'
GO
