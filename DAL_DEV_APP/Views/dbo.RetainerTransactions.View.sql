USE [DAL_DEV_APP]
GO
/****** Object:  View [dbo].[RetainerTransactions]    Script Date: 12/21/2015 13:35:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[RetainerTransactions]
AS
SELECT     AA.RetainerID, AA.CustID, XX.fiscalno AS 'FiscalNo', XX.employee AS 'EmployeeID', XX.vendor_num AS 'VendorID', XX.tr_id05 AS 'LaborClass', 
                      XX.trans_date AS 'Date', XX.project AS 'ProjectID', SUM(XX.units) AS 'Hours'
FROM         dbo.RetainerJobs AS AA LEFT OUTER JOIN
                          (SELECT     RetainerID, CustID, Period1FiscalNo AS fiscalno
                            FROM          dbo.Retainers
                            UNION ALL
                            SELECT     RetainerID, CustID, Period2FiscalNo AS fiscalno
                            FROM         dbo.Retainers AS Retainers_11
                            UNION ALL
                            SELECT     RetainerID, CustID, Period3FiscalNo AS fiscalno
                            FROM         dbo.Retainers AS Retainers_10
                            UNION ALL
                            SELECT     RetainerID, CustID, Period4FiscalNo AS fiscalno
                            FROM         dbo.Retainers AS Retainers_9
                            UNION ALL
                            SELECT     RetainerID, CustID, Period5FiscalNo AS fiscalno
                            FROM         dbo.Retainers AS Retainers_8
                            UNION ALL
                            SELECT     RetainerID, CustID, Period6FiscalNo AS fiscalno
                            FROM         dbo.Retainers AS Retainers_7
                            UNION ALL
                            SELECT     RetainerID, CustID, Period7FiscalNo AS fiscalno
                            FROM         dbo.Retainers AS Retainers_6
                            UNION ALL
                            SELECT     RetainerID, CustID, Period8FiscalNo AS fiscalno
                            FROM         dbo.Retainers AS Retainers_5
                            UNION ALL
                            SELECT     RetainerID, CustID, Period9FiscalNo AS fiscalno
                            FROM         dbo.Retainers AS Retainers_4
                            UNION ALL
                            SELECT     RetainerID, CustID, Period10FiscalNo AS fiscalno
                            FROM         dbo.Retainers AS Retainers_3
                            UNION ALL
                            SELECT     RetainerID, CustID, Period11FiscalNo AS fiscalno
                            FROM         dbo.Retainers AS Retainers_2
                            UNION ALL
                            SELECT     RetainerID, CustID, Period12FiscalNo AS fiscalno
                            FROM         dbo.Retainers AS Retainers_1) AS BB ON AA.RetainerID = BB.RetainerID LEFT OUTER JOIN
                          (SELECT     employee, fiscalno, trans_date, project, units, vendor_num, tr_id05
                            FROM          dbo.PJTRAN AS A
                            WHERE      (acct = 'DIRECT SALARY') OR
                                                   (acct = 'FREELANCE')) AS XX ON AA.project = XX.project AND BB.fiscalno = XX.fiscalno
GROUP BY AA.RetainerID, AA.CustID, XX.fiscalno, XX.employee, XX.fiscalno, XX.trans_date, XX.project, XX.vendor_num, XX.tr_id05
HAVING      (SUM(XX.units) <> 0)
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[20] 3) )"
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
         Configuration = "(H (4[30] 2[40] 3) )"
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
         Begin Table = "AA"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 99
               Right = 205
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "XX"
            Begin Extent = 
               Top = 6
               Left = 448
               Bottom = 114
               Right = 615
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BB"
            Begin Extent = 
               Top = 6
               Left = 243
               Bottom = 99
               Right = 410
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
         Width = 2280
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RetainerTransactions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RetainerTransactions'
GO
