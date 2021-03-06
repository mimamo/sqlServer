USE [DAL_DEV_APP]
GO
/****** Object:  View [dbo].[xmaba_2]    Script Date: 12/21/2015 13:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xmaba_2]
AS
SELECT     rp.RI_ID, dbo.PJPROJ.project AS projectid, dbo.PJPROJ.project_desc, XX.TranDate, XX.CrAmt, XX.DrAmt, XX.Crtd_Prog, XX.TranDesc, XX.RefNbr, 
                      dbo.PJPROJ.customer, dbo.Customer.Name AS customer_name, CASE WHEN dramt <> 0 THEN CASE WHEN datediff(day, trandate, reportdate) 
                      < 30 THEN dramt ELSE 0 END ELSE CASE WHEN datediff(day, trandate, reportdate) < 30 THEN - 1 * cramt ELSE 0 END END AS crrnt, 
                      CASE WHEN dramt <> 0 THEN CASE WHEN datediff(day, trandate, reportdate) BETWEEN 30 AND 
                      59 THEN dramt ELSE 0 END ELSE CASE WHEN datediff(day, trandate, reportdate) BETWEEN 30 AND 
                      59 THEN - 1 * cramt ELSE 0 END END AS thrity_to_59, CASE WHEN dramt <> 0 THEN CASE WHEN datediff(day, trandate, reportdate) BETWEEN 60 AND 
                      89 THEN dramt ELSE 0 END ELSE CASE WHEN datediff(day, trandate, reportdate) BETWEEN 60 AND 
                      89 THEN - 1 * cramt ELSE 0 END END AS sixty_to_89, CASE WHEN dramt <> 0 THEN CASE WHEN datediff(day, trandate, reportdate) BETWEEN 90 AND 
                      119 THEN dramt ELSE 0 END ELSE CASE WHEN datediff(day, trandate, reportdate) BETWEEN 90 AND 
                      119 THEN - 1 * cramt ELSE 0 END END AS ninety_to_119, CASE WHEN dramt <> 0 THEN CASE WHEN datediff(day, trandate, reportdate) BETWEEN 
                      120 AND 179 THEN dramt ELSE 0 END ELSE CASE WHEN datediff(day, trandate, reportdate) BETWEEN 120 AND 
                      179 THEN - 1 * cramt ELSE 0 END END AS one_twenty_to_179, CASE WHEN dramt <> 0 THEN CASE WHEN datediff(day, trandate, reportdate) 
                      >= 180 THEN dramt ELSE 0 END ELSE CASE WHEN datediff(day, trandate, reportdate) 
                      >= 180 THEN - 1 * cramt ELSE 0 END END AS one_eighty_and_higher
FROM         dbo.RptRuntime AS rp CROSS JOIN
                      dbo.PJPROJ LEFT OUTER JOIN
                          (SELECT DISTINCT 
                                                   AA.source_trx_id, AA.source_trx_date AS TranDate, AA.amount AS CrAmt, 0 AS DrAmt, 'BIREG' AS Crtd_Prog, '' AS TranDesc, 
                                                   AA.project AS ProjectID, A.PerPost, SUBSTRING(AA.in_id11, 11, 6) AS RefNbr
                            FROM          dbo.GLTran AS A LEFT OUTER JOIN
                                                   dbo.PJINVHDR AS B ON A.RefNbr = B.invoice_num LEFT OUTER JOIN
                                                   dbo.PJInvDet AS AA ON AA.draft_num = B.draft_num
                            WHERE      (A.JrnlType = 'IN') AND (A.Acct BETWEEN '1200' AND '1299' OR
                                                   A.Acct = '1321') AND (A.Posted = 'P') AND (AA.bill_status = 'B') AND (AA.acct LIKE 'WIP%')
                            UNION ALL
                            SELECT     RefNbr, TranDate, CrAmt, DrAmt, Crtd_Prog, TranDesc, ProjectID, PerPost, RefNbr AS Expr1
                            FROM         dbo.GLTran
                            WHERE     (Posted = 'P') AND (JrnlType <> 'IN') AND (Acct BETWEEN '1200' AND '1299' OR
                                                  Acct = '1321') AND (ProjectID <> '')
                            UNION ALL
                            SELECT     RefNbr, TranDate, CrAmt, DrAmt, Crtd_Prog, TranDesc,
                                                      (SELECT     TOP (1) z2.ProjectID
                                                        FROM          dbo.ARDoc AS z2 INNER JOIN
                                                                               dbo.ARAdjust AS z3 ON z2.RefNbr = z3.AdjdRefNbr
                                                        WHERE      (z3.AdjgRefNbr = z1.RefNbr)) AS ProjectID, PerPost, RefNbr AS Expr1
                            FROM         dbo.GLTran AS z1
                            WHERE     (Posted = 'P') AND (JrnlType <> 'IN') AND (Acct BETWEEN '1200' AND '1299' OR
                                                  Acct = '1321') AND (ProjectID = '')) AS XX ON dbo.PJPROJ.project = XX.ProjectID AND XX.PerPost <= rp.BegPerNbr LEFT OUTER JOIN
                      dbo.Customer ON dbo.PJPROJ.customer = dbo.Customer.CustId
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[25] 4[26] 2[21] 3) )"
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
         Top = -1353
         Left = 0
      End
      Begin Tables = 
         Begin Table = "rp"
            Begin Extent = 
               Top = 1359
               Left = 38
               Bottom = 1467
               Right = 192
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PJPROJ"
            Begin Extent = 
               Top = 1359
               Left = 230
               Bottom = 1467
               Right = 412
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Customer"
            Begin Extent = 
               Top = 1359
               Left = 639
               Bottom = 1467
               Right = 794
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "XX"
            Begin Extent = 
               Top = 1359
               Left = 450
               Bottom = 1467
               Right = 601
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
      Begin ColumnWidths = 19
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
         Ou' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xmaba_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'tput = 720
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xmaba_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xmaba_2'
GO
