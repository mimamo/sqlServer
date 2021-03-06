USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[X_EmployeeOvertimeHours]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[X_EmployeeOvertimeHours]
AS
SELECT     DT5.Employee, A.emp_name AS 'EmployeeName', MAX(B.ep_id05) AS 'PayType', DT5.WeekEnding, DT5.WorkedHours, DT5.PTOHours, 
                      DT5.WorkedHours + DT5.PTOHours AS 'TotalHours', CASE WHEN (DT5.WorkedHours + DT5.PTOHours) 
                      >= 37.5 THEN 37.5 ELSE (DT5.WorkedHours + DT5.PTOHours) END AS 'NormalHours', CASE WHEN ((DT5.WorkedHours > 37.5) AND 
                      (DT5.WorkedHours - 37.5) <= 2.5 AND (DT5.WorkedHours - 37.5) > 0) THEN ((DT5.WorkedHours - 37.5) + DT5.PTOHours) 
                      WHEN ((DT5.WorkedHours > 37.5) AND (DT5.WorkedHours - 37.5) > 2.5) THEN (2.5 + DT5.PTOHours) WHEN ((DT5.WorkedHours <= 37.5) AND 
                      (DT5.WorkedHours + DT5.PTOHours) > 37.5) THEN (DT5.WorkedHours + DT5.PTOHours) - 37.5 WHEN (DT5.WorkedHours >= 40) THEN (DT5.PTOHours) 
                      ELSE 0 END AS 'StraightOTHours', CASE WHEN (DT5.WorkedHours > 40) THEN (DT5.WorkedHours - 40) ELSE 0 END AS 'OTHours'
FROM         (SELECT     COALESCE (DT2.employee, DT4.employee) AS Employee, COALESCE (DT2.pe_date, DT4.pe_date) AS WeekEnding, 
                                              COALESCE (DT4.WorkedHours, 0) AS WorkedHours, COALESCE (DT2.PTOHours, 0) AS PTOHours
                       FROM          (SELECT     employee, pe_date, SUM(total_hrs) AS PTOHours
                                               FROM          (SELECT     A.employee, A.pe_date, B.total_hrs
                                                                       FROM          dbo.PJLABHDR AS A LEFT OUTER JOIN
                                                                                              dbo.PJLABDET AS B ON A.docnbr = B.docnbr
                                                                       WHERE      (A.le_status = 'P') AND (B.pjt_entity IN ('EMP01', 'EMP02', 'EMP03', 'EMP04', 'EMP05', 'EMP05', 'EMP06', 'EMP07', 
                                                                                              'EMP08', 'EMP10', 'EMP11', 'EMP12', 'EMP13', 'EMP014'))) AS DT1
                                               GROUP BY employee, pe_date
                                               HAVING      (SUM(total_hrs) <> 0)) AS DT2 FULL OUTER JOIN
                                                  (SELECT     employee, pe_date, SUM(total_hrs) AS WorkedHours
                                                    FROM          (SELECT     A.employee, A.pe_date, B.total_hrs
                                                                            FROM          dbo.PJLABHDR AS A LEFT OUTER JOIN
                                                                                                   dbo.PJLABDET AS B ON A.docnbr = B.docnbr
                                                                            WHERE      (A.le_status = 'P') AND (B.pjt_entity NOT IN ('EMP01', 'EMP02', 'EMP03', 'EMP04', 'EMP05', 'EMP05', 'EMP06', 
                                                                                                   'EMP07', 'EMP08', 'EMP10', 'EMP11', 'EMP12', 'EMP13', 'EMP014'))) AS DT3
                                                    GROUP BY employee, pe_date
                                                    HAVING      (SUM(total_hrs) <> 0)) AS DT4 ON DT2.employee = DT4.employee AND DT2.pe_date = DT4.pe_date) AS DT5 LEFT OUTER JOIN
                      dbo.PJEMPLOY AS A ON A.employee = DT5.Employee LEFT OUTER JOIN
                      dbo.PJEMPPJT AS B ON DT5.Employee = B.employee AND B.effect_date <= DT5.WeekEnding
GROUP BY DT5.Employee, A.emp_name, DT5.WeekEnding, DT5.WorkedHours, DT5.PTOHours, DT5.WorkedHours
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
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 243
               Bottom = 114
               Right = 431
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "B"
            Begin Extent = 
               Top = 6
               Left = 469
               Bottom = 114
               Right = 636
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "DT5"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 205
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
      Begin ColumnWidths = 12
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'X_EmployeeOvertimeHours'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'X_EmployeeOvertimeHours'
GO
