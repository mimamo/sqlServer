USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_PA920_main]    Script Date: 12/21/2015 13:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PA920_main]
AS
SELECT     SUBSTRING(p.project, 0, 4) AS CustomerCode, ISNULL(c.Name, 'Customer Name Unavailable') AS CustomerName, SUBSTRING(p.project, 4, 3) 
                      AS ProductCode, bcyc.code_value_desc AS ProductDesc, p.project, p.project_desc AS ProjectDesc, p.purchase_order_num AS PONumber, 
                      p.status_pa AS StatusPA, p.start_date AS StartDate, p.start_date AS OnShelfDate, p.pm_id08 AS CloseDate, ISNULL(est.EstimateAmountEAC, 0) 
                      AS EstimateAmountEAC, ISNULL(est.EstimateAmountFAC, 0) AS EstimateAmountFAC, ISNULL(est.EstimateAmountTotal, 0) AS EstimateAmountTotal, 
                      ISNULL(act.acct, '') AS ActAcct, ISNULL(act.Amount01, 0) AS Amount01, ISNULL(act.Amount02, 0) AS Amount02, ISNULL(act.Amount03, 0) AS Amount03, 
                      ISNULL(act.Amount04, 0) AS Amount04, ISNULL(act.Amount05, 0) AS Amount05, ISNULL(act.Amount06, 0) AS Amount06, ISNULL(act.Amount07, 0) 
                      AS Amount07, ISNULL(act.Amount08, 0) AS Amount08, ISNULL(act.Amount09, 0) AS Amount09, ISNULL(act.Amount10, 0) AS Amount10, 
                      ISNULL(act.Amount11, 0) AS Amount11, ISNULL(act.Amount12, 0) AS Amount12, ISNULL(act.Amount13, 0) AS Amount13, ISNULL(act.Amount14, 0) 
                      AS Amount14, ISNULL(act.Amount15, 0) AS Amount15, ISNULL(act.AmountBF, 0) AS AmountBF, ISNULL(act.FSYearNum, '1900') AS FSYearNum, 
                      ISNULL(act.AcctGroupCode, '') AS AcctGroupCode, ISNULL(act.ControlCode, '') AS ControlCode
FROM         dbo.PJPROJ AS p LEFT OUTER JOIN
                      dbo.Customer AS c ON p.customer = c.CustId LEFT OUTER JOIN
                      dbo.PJCODE AS bcyc ON p.pm_id02 = bcyc.code_value AND bcyc.code_type = 'BCYC' LEFT OUTER JOIN
                      dbo.xvr_PA920_Estimates AS est ON p.project = est.Project LEFT OUTER JOIN
                      dbo.xvr_PA920_Actuals AS act ON p.project = act.project
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
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 220
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 258
               Bottom = 114
               Right = 423
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "bcyc"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 201
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "est"
            Begin Extent = 
               Top = 114
               Left = 239
               Bottom = 222
               Right = 421
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "act"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 193
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
En' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_PA920_main'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'd
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_PA920_main'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_PA920_main'
GO
