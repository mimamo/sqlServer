USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_PA934_Main]    Script Date: 12/21/2015 14:05:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PA934_Main]
AS
SELECT     p.pm_id01 AS CustomerCode, ISNULL(c.Name, 'Customer Name Unavailable') AS CustomerName, p.pm_id02 AS ProductCode, 
                      ISNULL(bcyc.code_value_desc, '') AS ProductDesc, p.project, p.project_desc AS ProjectDesc, p.status_pa AS StatusPA, p.start_date AS StartDate, 
                      p.manager1 AS PM, fu.pjt_entity AS FunctionCode, ISNULL(fun.FunctionCode, '') AS TrxFunctionCode, ISNULL(fun.EstimateAmountFunctionTotal, 0) 
                      AS FunctionCLE, ISNULL(est.EstimateAmountTotal, 0) AS TotalCLE, CASE WHEN fu.pjt_entity IN ('00900') THEN 'Agency' WHEN fu.pjt_entity IN ('00925') 
                      THEN 'I&S' WHEN fu.pjt_entity IN ('12900', '12600', '15450', '00975') THEN 'ICP' WHEN fu.pjt_entity IN ('06410', '06415', '06120', '06110', '06112', 
                      '06130', '06170', '06180', '01620', '06435') THEN 'Digital' ELSE 'Other' END AS FunctionBucket, ISNULL(t.Hours, 0) AS Hours, 
                      p.end_date AS OnShelfDate, ule.ULEAmount
FROM         dbo.PJPROJ AS p INNER JOIN
                      dbo.PJPROJEX AS x ON p.project = x.project INNER JOIN
                      dbo.PJPENT AS fu ON p.project = fu.project LEFT OUTER JOIN
                      dbo.xvr_PA934_PJTRAN AS t ON fu.project = t.Project AND fu.pjt_entity = t.pjt_entity LEFT OUTER JOIN
                      dbo.Customer AS c ON p.pm_id01 = c.CustId LEFT OUTER JOIN
                      dbo.xvr_PA934_JobEstimates AS est ON fu.project = est.Project LEFT OUTER JOIN
                      dbo.xvr_PA934_FunctionEstimates AS fun ON fu.project = fun.project AND fu.pjt_entity = fun.FunctionCode LEFT OUTER JOIN
                      dbo.PJCODE AS bcyc ON p.pm_id02 = bcyc.code_value AND bcyc.code_type = 'BCYC' LEFT OUTER JOIN
                      dbo.xvr_Est_ULE_Project AS ule ON p.project = ule.Project
WHERE     (p.contract_type <> 'APS')
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
         Begin Table = "x"
            Begin Extent = 
               Top = 6
               Left = 258
               Bottom = 114
               Right = 418
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "fu"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 211
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t"
            Begin Extent = 
               Top = 114
               Left = 249
               Bottom = 207
               Right = 400
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 210
               Left = 249
               Bottom = 318
               Right = 414
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "est"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 220
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "fun"
            Begin Extent = 
               Top = 330
               Left = 38
               Bottom = 438
               Right = 261
            End
            DisplayFlags = 280
            TopColumn = 0
         E' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_PA934_Main'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'nd
         Begin Table = "bcyc"
            Begin Extent = 
               Top = 318
               Left = 299
               Bottom = 426
               Right = 462
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ule"
            Begin Extent = 
               Top = 426
               Left = 299
               Bottom = 534
               Right = 450
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
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_PA934_Main'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_PA934_Main'
GO
